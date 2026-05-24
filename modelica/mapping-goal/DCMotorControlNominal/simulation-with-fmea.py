import os
import time           # <-- NEW: For execution time tracking
import json
import shutil
import multiprocessing
import numpy as np
import pandas as pd
import psutil
import matplotlib.pyplot as plt
from concurrent.futures import ProcessPoolExecutor
from scipy.stats import qmc, norm, expon, weibull_min, uniform
from fmpy import simulate_fmu, extract

def map_to_distribution(lhs_samples, param_config):
    """Maps LHS uniform samples [0,1] to the desired probability distribution."""
    dist_type = param_config["distribution"]
    
    if dist_type == "Normal":
        mean = param_config["mean"]
        std = param_config["standardDeviation"]
        return norm.ppf(lhs_samples, loc=mean, scale=std)
        
    elif dist_type == "Uniform":
        lower = param_config["lowerBound"]
        upper = param_config["upperBound"]
        return uniform.ppf(lhs_samples, loc=lower, scale=(upper - lower))
        
    elif dist_type == "Exponential":
        lmbda = param_config["lambda"]
        return expon.ppf(lhs_samples, scale=(1.0 / lmbda))
        
    elif dist_type == "Weibull":
        shape = param_config["shape"]
        scale = param_config["scale"]
        return weibull_min.ppf(lhs_samples, c=shape, scale=scale)
    else:
        raise ValueError(f"Unknown distribution: {dist_type}")

def evaluate_kpis(result, start_values):
    """
    Evaluates the physical severity, detection status, and timing metrics of a single run.
    """
    t = result['time']
    w_target = result['ramp.y']
    w_physical = result['speedSensor3.w'] 
    pid_y = result['pid.y'] # needed for saturation checking
    
    # extracting fault flags
    crit_fail = result['systemMonitor.critical_failure']
    fdi1 = result['fDIMonitor1.fault_detected']
    fdi2 = result['fDIMonitor2.fault_detected']
    fdi3 = result['fDIMonitor3.fault_detected']
    
    # combined detection of boolean array
    any_detection = (crit_fail > 0.5) | (fdi1 > 0.5) | (fdi2 > 0.5) | (fdi3 > 0.5)
    detected = np.any(any_detection)
    
    latency = None
    if detected:
        fault_starts = [v for k, v in start_values.items() if 'startTime' in k and v < 1e99]
        if fault_starts:
            actual_fault_start = min(fault_starts)
            det_idx = np.argmax(any_detection)
            det_time = t[det_idx]
            # ensure latency is not negative (due to numerical noise before fault)
            latency = max(0.0, det_time - actual_fault_start)

    # mask out the startup transient (0-1.0s) to only check steady-state physics
    steady_state_mask = t > 1.0
    w_steady = w_physical[steady_state_mask]
    target_steady = w_target[steady_state_mask]
    
    #overshoot & undershoot Error (>15 or <-15 rad/s) ---
    if len(w_steady) > 0:
        error_array = w_steady - target_steady
        overshoot = np.max(error_array) > 15.0
        undershoot = np.min(error_array) < -15.0
    else:
        overshoot = False
        undershoot = False
        
    # instability (standard deviation > 2.0 rad/s)
    instability = np.std(w_steady) > 2.0 if len(w_steady) > 0 else False
    
    # actuator saturation (assuming limits at +/- 200.0) ---
    saturation = np.max(np.abs(pid_y)) > 200.0
    
    # settling ime (+/- 2.0 rad/s tolerance) ---
    settling_time = None
    if len(t) > 0:
        abs_error = np.abs(w_physical - w_target)
        # find the last index where the error is out of bounds
        out_of_bounds = np.where(abs_error > 2.0)[0]
        if len(out_of_bounds) > 0:
            last_out_idx = out_of_bounds[-1]
            if last_out_idx < len(t) - 1:
                settling_time = t[last_out_idx + 1]
        else:
            settling_time = 0.0 # error never exceeded tolerance

    return {
        "overshoot": bool(overshoot),
        "undershoot": bool(undershoot),
        "instability": bool(instability),
        "saturation": bool(saturation),
        "detected": bool(detected),
        "latency": latency,
        "settling_time": settling_time
    }

def run_single_simulation(args):
    """Isolated worker function to run a single simulation and evaluate KPIs."""
    unzipdir, start_time, stop_time, step_size, start_values, is_fault_active = args
    try:
        result = simulate_fmu(
            unzipdir,
            start_time=start_time,
            stop_time=stop_time,
            start_values=start_values,
            fmi_type='CoSimulation',
            output=[
                'time', 'ramp.y', 
                'speedSensor1.w', 'speedSensor2.w', 'speedSensor3.w', 
                'medianVoter.y', 'pid.y', # <-- NEW: added pid.y
                'systemMonitor.critical_failure',
                'fDIMonitor1.fault_detected',
                'fDIMonitor2.fault_detected',
                'fDIMonitor3.fault_detected'
            ],
            output_interval=step_size
        )
        
        # calculate KPIs (passing start_values to calculate latency)
        kpis = evaluate_kpis(result, start_values)
        
        #memory usage (MB) of this worker process
        process = psutil.Process(os.getpid())
        mem_mb = process.memory_info().rss / (1024 * 1024)
        
        return (result, kpis, is_fault_active, mem_mb)
    except Exception as e:
        print(f"Error in worker thread: {e}")
        return None

if __name__ == '__main__':
    total_start_time = time.time() # tracking total exectuion time (inlcudes everything else not just the simulation scenarios)
    print("Starting Monte Carlo Simulations and FMEA")
    
    with open('scenarios.json', 'r') as f:
        config = json.load(f)

    FMU_FILENAME = config['fmu_filename']
    STOP_TIME = config['stop_time']
    STEP_SIZE = config['step_size']

    print("Extracting FMU...")
    unzipdir = extract(FMU_FILENAME)

    os.makedirs("mc_plots", exist_ok=True)
    fmea_data_rows = []

    for scenario in config['scenarios']:
        scenario_start_time = time.time()
        
        scenario_name = scenario['name']
        n_runs = scenario['runs']
        p_occur = scenario.get('occurrence_probability', 1.0)
        param_configs = scenario.get('parameters', {})
        
        print(f"\n--- Scenario: {scenario_name} ({n_runs} runs) ---")
        
        param_names = list(param_configs.keys())
        d_dimensions = max(1, len(param_names) + 1)
        
        sampler = qmc.LatinHypercube(d=d_dimensions)
        lhs_matrix = sampler.random(n=n_runs)
        
        sim_args_list = []
        
        for i in range(n_runs):
            start_values = {}
            is_fault_active = lhs_matrix[i, 0] <= p_occur
            
            for j, param_name in enumerate(param_names):
                if is_fault_active:
                    raw_sample = lhs_matrix[i, j+1]
                    val = map_to_distribution(raw_sample, param_configs[param_name])
                    if "startTime" in param_name or "duration" in param_name:
                        val = max(0.0, val)
                    start_values[param_name] = val
                else:
                    if "startTime" in param_name:
                        start_values[param_name] = 1e99
                    elif "gainFactor" in param_name:
                        start_values[param_name] = 1.0
                    else:
                        start_values[param_name] = 0.0

            sim_args_list.append((unzipdir, 0.0, STOP_TIME, STEP_SIZE, start_values, is_fault_active))

        all_results = []
        scenario_memory = []
        
        # initialize KPI counters and lists for averages
        scenario_kpis = {
            "overshoot": 0, "undershoot": 0, "instability": 0, 
            "saturation": 0, "detected": 0, "total_faults": 0
        }
        latency_list = []
        settling_list = []
        
        max_cores = max(1, multiprocessing.cpu_count() - 1)
        print(f"  > Running simulations in parallel on {max_cores} cores...")

        with ProcessPoolExecutor(max_workers=max_cores) as executor:
            for i, res_tuple in enumerate(executor.map(run_single_simulation, sim_args_list)):
                if res_tuple is not None:
                    res_data, res_kpi, fault_was_active, mem_mb = res_tuple
                    
                    all_results.append(res_data)
                    scenario_memory.append(mem_mb)
                    
                    if fault_was_active:
                        scenario_kpis["total_faults"] += 1
                        if res_kpi["overshoot"]: scenario_kpis["overshoot"] += 1
                        if res_kpi["undershoot"]: scenario_kpis["undershoot"] += 1
                        if res_kpi["instability"]: scenario_kpis["instability"] += 1
                        if res_kpi["saturation"]: scenario_kpis["saturation"] += 1
                        if res_kpi["detected"]: scenario_kpis["detected"] += 1
                        
                        if res_kpi["latency"] is not None:
                            latency_list.append(res_kpi["latency"])
                        if res_kpi["settling_time"] is not None:
                            settling_list.append(res_kpi["settling_time"])
                
                if (i + 1) % 10 == 0 or (i + 1) == n_runs:
                    print(f"    Processed: {i + 1}/{n_runs}...")

        if not all_results:
            print("  [Error] No simulations ran successfully in this scenario.")
            continue
            
        scenario_duration = time.time() - scenario_start_time
        avg_memory = np.mean(scenario_memory) if scenario_memory else 0.0

        actual_faults = scenario_kpis["total_faults"]
        if actual_faults > 0:
            pct_overshoot = (scenario_kpis["overshoot"] / actual_faults) * 100
            pct_undershoot = (scenario_kpis["undershoot"] / actual_faults) * 100
            pct_instability = (scenario_kpis["instability"] / actual_faults) * 100
            pct_saturation = (scenario_kpis["saturation"] / actual_faults) * 100
            pct_detected = (scenario_kpis["detected"] / actual_faults) * 100
            
            avg_latency = np.mean(latency_list) if latency_list else 0.0
            avg_settling = np.mean(settling_list) if settling_list else 0.0
        else:
            pct_overshoot = pct_undershoot = pct_instability = pct_saturation = pct_detected = 0.0
            avg_latency = avg_settling = 0.0
            
        fmea_data_rows.append({
            "Failure Scenario": scenario_name,
            "Occur. Prob. (%)": p_occur * 100,
            "Overshoot Rate (%)": round(pct_overshoot, 1),
            "Undershoot Rate (%)": round(pct_undershoot, 1), # <-- NEW
            "Instability Rate (%)": round(pct_instability, 1),
            "Saturation Rate (%)": round(pct_saturation, 1), # <-- NEW
            "Detection Rate (%)": round(pct_detected, 1),
            "Avg Latency (s)": round(avg_latency, 3),        # <-- NEW
            "Avg Settling Time (s)": round(avg_settling, 3), # <-- NEW
            "Avg Memory (MB)": round(avg_memory, 1),         # <-- NEW
            "Exec. Time (s)": round(scenario_duration, 1)    # <-- NEW
        })

        print("  > Generating plot...")
        plt.figure(figsize=(12, 6))
        
        ideal_time = all_results[0]['time']
        ideal_w = all_results[0]['ramp.y']
        plt.plot(ideal_time, ideal_w, color='black', linewidth=2, linestyle='--', label='Target Speed (Ramp)')

        for idx, res in enumerate(all_results):
            t = res['time']
            label_s1 = 'Sensor 1' if idx == 0 else None
            label_s2 = 'Sensor 2 (+1.0 offset)' if idx == 0 else None
            label_s3 = 'Sensor 3 (+2.0 offset)' if idx == 0 else None
            label_voter = 'Voter Output' if idx == 0 else None
            
            plt.plot(t, res['speedSensor1.w'], color='red', alpha=0.1, linewidth=1, label=label_s1)
            plt.plot(t, res['speedSensor2.w'] + 1.0, color='magenta', alpha=0.1, linewidth=1, label=label_s2)
            plt.plot(t, res['speedSensor3.w'] + 2.0, color='green', alpha=0.1, linewidth=1, label=label_s3)
            plt.plot(t, res['medianVoter.y'], color='blue', alpha=0.2, linewidth=1.5, label=label_voter)

        plt.title(f"Monte Carlo Simulation - {scenario_name} ({n_runs} runs)")
        plt.xlabel("Time [s]")
        plt.ylabel("Speed [rad/s]")
        plt.grid(True, linestyle=':', alpha=0.7)
        plt.legend(loc='lower right')
        plt.tight_layout()
        
        filepath = os.path.join("mc_plots", f"{scenario_name}.png")
        plt.savefig(filepath, dpi=300)
        plt.close()

    print("\n--- FMEA Report Generation ---")
    df_fmea = pd.DataFrame(fmea_data_rows)
    
    print("\nEvaluated Scenarios:")
    print(df_fmea.to_string(index=False))
    
    csv_filename = "FMEA_Report.csv"
    df_fmea.to_csv(csv_filename, index=False, encoding='utf-8')
    print(f"\n[OK] CSV report saved: {csv_filename}")
    
    try:
        excel_filename = "FMEA_Report.xlsx"
        df_fmea.to_excel(excel_filename, index=False, engine='openpyxl')
        print(f"[OK] Excel report saved: {excel_filename}")
    except ImportError:
        print("[Info] Install 'openpyxl' (pip install openpyxl) to save the report in Excel format.")

    shutil.rmtree(unzipdir, ignore_errors=True)

    total_duration = time.time() - total_start_time
    mins, secs = divmod(total_duration, 60)
    print(f"\n[OK] All simulations completed! Total execution time: {int(mins)}m {int(secs)}s")