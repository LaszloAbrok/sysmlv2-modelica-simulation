import os
import json
import shutil
import multiprocessing
import numpy as np
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

def run_single_simulation(args):
    """Isolated worker function to run a single simulation."""
    unzipdir, start_time, stop_time, step_size, start_values = args
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
                'medianVoter.y'
            ],
            output_interval=step_size
        )
        return result
    except Exception as e:
        print(f"Error in worker thread: {e}")
        return None

if __name__ == '__main__':
    print("--- Starting Monte Carlo Simulation Framework ---")
    
    with open('scenarios.json', 'r') as f:
        config = json.load(f)

    FMU_FILENAME = config['fmu_filename']
    STOP_TIME = config['stop_time']
    STEP_SIZE = config['step_size']

    print("Extracting FMU...")
    unzipdir = extract(FMU_FILENAME)

    os.makedirs("mc_plots", exist_ok=True)

    for scenario in config['scenarios']:
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

            sim_args_list.append((unzipdir, 0.0, STOP_TIME, STEP_SIZE, start_values))

        # parrallel execution
        all_results = []
        max_cores = max(1, multiprocessing.cpu_count() - 1)
        print(f"  > Running simulations in parallel on {max_cores} cores...")

        with ProcessPoolExecutor(max_workers=max_cores) as executor:
            for i, result in enumerate(executor.map(run_single_simulation, sim_args_list)):
                if result is not None:
                    all_results.append(result)
                
                # progress indicator
                if (i + 1) % 10 == 0 or (i + 1) == n_runs:
                    print(f"    Processed: {i + 1}/{n_runs}...")

        if not all_results:
            print("  [Error] No simulations ran successfully in this scenario.")
            continue

        # plotting ans saving
        print("  > Generating plot...")
        plt.figure(figsize=(12, 6))
        
        ideal_time = all_results[0]['time']
        ideal_w = all_results[0]['ramp.y']
        plt.plot(ideal_time, ideal_w, color='black', linewidth=2, linestyle='--', label='Target Speed (Ramp)')

        for idx, res in enumerate(all_results):
            t = res['time']
            
            # label handling to avoid duplications
            label_s1 = 'Sensor 1' if idx == 0 else None
            label_s2 = 'Sensor 2 (+1.0 offset)' if idx == 0 else None
            label_s3 = 'Sensor 3 (+2.0 offset)' if idx == 0 else None
            label_voter = 'Voter Output (to PID)' if idx == 0 else None
            
            # draw sensors with thin, transparent lines (spderweb like effect)
            plt.plot(t, res['speedSensor1.w'], color='red', alpha=0.1, linewidth=1, label=label_s1)
            plt.plot(t, res['speedSensor2.w'] + 1.0, color='magenta', alpha=0.1, linewidth=1, label=label_s2)
            plt.plot(t, res['speedSensor3.w'] + 2.0, color='green', alpha=0.1, linewidth=1, label=label_s3)
            
            # draw Voter output slightly thicker
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

    # cleanup
    shutil.rmtree(unzipdir, ignore_errors=True)
    print("\n[OK] All simulations completed! Plots are saved in the 'mc_plots' folder.")