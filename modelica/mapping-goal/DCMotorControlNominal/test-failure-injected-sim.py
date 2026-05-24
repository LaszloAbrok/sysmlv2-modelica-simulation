import fmpy
import matplotlib.pyplot as plt
import numpy as np
import os

# Name of the exported FMU file
fmu_filename = "System.fmu"

output_dir = "fmea_plots"
os.makedirs(output_dir, exist_ok=True)

# scenario definitons
scenarios = {
    "1_Healthy_Baseline": {},
    
    "2_Sensor1_Stuck": {
        'speedSensor1.stuckError_startTime': 0.5,
        'speedSensor1.stuckError_value': 0.0
    },
    
    "3_Sensor1_Oscillation": {
        'speedSensor1.oscError_startTime': 0.5,
        'speedSensor1.oscError_amplitude': 20.0,
        'speedSensor1.oscError_frequency': 15.0
    },
    
    "4_Sensor1_Gain": {
        'speedSensor1.gainError_startTime': 0.5,
        'speedSensor1.gainError_gainFactor': 1.5
    },
    
    "5_TMR_Breakdown_DoubleStuck": {
        'speedSensor1.stuckError_startTime': 0.5,
        'speedSensor1.stuckError_value': 0.0,
        'speedSensor2.stuckError_startTime': 0.7,
        'speedSensor2.stuckError_value': 85.0
    },
    
    "6_Hardware_ResistorOverheat": {
        'resistor.fault_startTime': 0.5,
        'resistor.fault_R': 10.0,
        'resistor.fault_duration': 5.0
    },
    
    "7_Hardware_InertiaJam": {
        'inertia.fault_startTime': 2.0,
        'inertia.fault_loadTorque': -30.0,
        'inertia.fault_duration': 10.0
    },
    
    "8_Hardware_AmplifierBrownout": {
        'amplifier.fault_startTime': 0.5,
        'amplifier.fault_gainFactor': 0.01,
        'amplifier.fault_duration': 5.0
    }
}

def run_and_plot_scenario(scenario_name, start_values):
    print(f"Running: {scenario_name}...")

    result = fmpy.simulate_fmu(
        fmu_filename,
        start_time=0.0,
        stop_time=10.0,
        step_size=0.001,
        fmi_type='ModelExchange',
        relative_tolerance=1e-3,
        start_values=start_values,
        output=[
            'time', 'ramp.y', 
            'speedSensor1.w', 'speedSensor2.w', 'speedSensor3.w', 
            'medianVoter.y', 
            'fDIMonitor1.fault_detected', 'fDIMonitor2.fault_detected', 'fDIMonitor3.fault_detected', 
            'systemMonitor.critical_failure'
        ]
    )

    t = result['time']
    w_ref = result['ramp.y']
    w_s1 = result['speedSensor1.w']
    w_s2 = result['speedSensor2.w']
    w_s3 = result['speedSensor3.w'] 
    w_voter = result['medianVoter.y']
    fdi1 = result['fDIMonitor1.fault_detected']
    fdi2 = result['fDIMonitor2.fault_detected']
    fdi3 = result['fDIMonitor3.fault_detected']
    crit = result['systemMonitor.critical_failure']

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8), sharex=True)
    fig.suptitle(f"Scenario: {scenario_name}", fontsize=14, fontweight='bold')

    ax1.plot(t, w_ref, label='Target Speed (Ramp)', color='black', linestyle='--', linewidth=1.5)
    
    ax1.plot(t, w_voter, label='Voter Output (to PID)', color='blue', linewidth=4, alpha=0.3)
    
    ax1.plot(t, w_s1, label='Sensor 1', color='red', linewidth=2)
    ax1.plot(t, w_s2 + 1.0, label='Sensor 2 (+1.0 offset)', color='magenta', linewidth=2, linestyle='--')
    ax1.plot(t, w_s3 + 2.0, label='Sensor 3 (+2.0 offset)', color='green', linewidth=2, linestyle='-.')
    
    ax1.set_ylabel('Speed [rad/s]')
    ax1.grid(True)
    ax1.legend(loc='lower right')

    ax2.plot(t, fdi1, label='FDI 1 (Local Fault)', color='red', linewidth=2)
    ax2.plot(t, fdi2 + 0.02, label='FDI 2 (Local Fault)', color='magenta', linewidth=2, linestyle='--')
    ax2.plot(t, fdi3 + 0.04, label='FDI 3 (Local Fault)', color='green', linewidth=2, linestyle='-.')
    
    ax2.plot(t, crit, label='System Monitor (Critical Failure)', color='black', linewidth=3)
    ax2.set_ylabel('Logic State [0/1]')
    ax2.set_xlabel('Time [s]')
    ax2.set_ylim(-0.1, 1.15) 
    ax2.grid(True)
    ax2.legend(loc='center right')

    plt.tight_layout()
    
    filename = f"{scenario_name}.png"
    filepath = os.path.join(output_dir, filename)
    
    plt.savefig(filepath, dpi=300)
    plt.show()

for name, params in scenarios.items():
    run_and_plot_scenario(name, params)