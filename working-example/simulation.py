import matplotlib.pyplot as plt
import fmpy
import numpy as np
import os

from error_generator import generate_error_profile

def run_motor_simulation(val_r, val_l, s1_config, s2_config, s3_config):
    
    # set path
    script_dir = os.path.dirname(os.path.abspath(__file__))
    fmu_file_name = os.path.normpath(os.path.join(script_dir, 'fmu/DCMotorControlAdvanced.fmu'))
    
    time_vec = np.arange(0.0, 10.0, 0.005)
    
    zaj1, trig1, stuck1 = generate_error_profile(time_vec, s1_config[0], s1_config[1])
    zaj2, trig2, stuck2 = generate_error_profile(time_vec, s2_config[0], s2_config[1])
    zaj3, trig3, stuck3 = generate_error_profile(time_vec, s3_config[0], s3_config[1])
    
    # input matrix
    dtype = [('time', np.float64), 
             ('sensor_failure_injection_1', np.float64),
             ('sensor_failure_injection_2', np.float64), 
             ('sensor_failure_injection_3', np.float64),
             ('stuck_value_trigger_1', np.float64),       
             ('stuck_value_1', np.float64),       
             ('resistor_failure_injection', np.float64), 
             ('inductor_failure_injection', np.float64)]
    
    input_data = np.zeros(len(time_vec), dtype=dtype)
    
    input_data['time'] = time_vec
    input_data['sensor_failure_injection_1'] = zaj1
    input_data['sensor_failure_injection_2'] = zaj2
    input_data['sensor_failure_injection_3'] = zaj3
    
    # currenty only sensor #1 has switch for stuck value
    # TODO implement them on the others aswell
    input_data['stuck_value_trigger_1'] = trig1
    input_data['stuck_value_1'] = stuck1
    
    input_data['resistor_failure_injection'] = val_r
    input_data['inductor_failure_injection'] = val_l
    
    print("Inputs:")
    print(input_data)
    
    simulation_outputs = [
        "true_sensor.w",
        "voter.y",
        "sensor_failure_injection_1",
        "sensor_failure_injection_2",
        "sensor_failure_injection_3",
        "resistor_failure_injection",
        "inductor_failure_injection",
        "variable_resistor.R",
        "inductor.L",
        "add1.y",
        "add2.y",
        "add3.y",
        "amplifier.v"
    ]
    
    # run simulation
    try:
        print("Starting simulation...")
        results = fmpy.simulate_fmu(
            fmu_file_name,
            start_time = 0.0,
            stop_time = 10.0,
            debug_logging=True,
            output_interval=0.005,
            step_size=0.0005,
            input = input_data,
            output = simulation_outputs,
            relative_tolerance=1e-2,
            fmi_type='ModelExchange' # fixes numerical errors idk why
             # from now on it is not cosimulation!!!
        )
        print("Simulation completed.")
    except Exception as e:
        # raise exception
        raise Exception(f"FMU Futtatási hiba: {str(e)}")

    fig, axs = plt.subplots(4, 2, figsize=(14, 10), sharex=True)
    
    axs = axs.flatten()

    # plots, might change them according to the desired data
    
    # true sensor
    axs[0].plot(results['time'], results['true_sensor.w'], label='true sensor data', color='red', alpha=0.7)
    axs[0].set_title('True rotational speed measurement')
    axs[0].set_ylabel('Rotational speed [rad/s]')
    axs[0].legend(loc='upper right')
    axs[0].grid(True)
    
    # Failure injection 1
    axs[1].plot(results['time'], results['sensor_failure_injection_1'], label='injected noise 1', color='red', alpha=0.7)
    axs[1].set_title('Injected noise on the sensor 1')
    axs[1].set_ylabel('Rotational speed [rad/s]')
    axs[1].legend(loc='upper right')
    axs[1].grid(True)
    
    # Failure injection 2
    axs[2].plot(results['time'], results['sensor_failure_injection_2'], label='injected noise 2', color='orange', alpha=0.7)
    axs[2].set_title('Injected noise on the sensor 2')
    axs[2].set_ylabel('Rotational speed [rad/s]')
    axs[2].legend(loc='upper right')
    axs[2].grid(True)
    
    # Failure injection 3
    axs[3].plot(results['time'], results['sensor_failure_injection_3'], label='injected noise 3', color='magenta', alpha=0.7)
    axs[3].set_title('Injected noise on the sensor 3')
    axs[3].set_ylabel('Rotational speed [rad/s]')
    axs[3].legend(loc='upper right')
    axs[3].grid(True)

    # sensor 1 with injected noise
    axs[4].plot(results['time'], results['add1.y'], label='sensor 1', color='red', alpha=0.7)
    axs[4].set_title('Sensor 1 with injected noise')
    axs[4].set_ylabel('Rotational speed [rad/s]')
    axs[4].legend(loc='upper right')
    axs[4].grid(True)
    
    # sensor 2 with injected noise
    axs[5].plot(results['time'], results['add2.y'], label='sensor 2', color='orange', alpha=0.7)
    axs[5].set_title('Sensor 2 with injected noise')
    axs[5].set_ylabel('Rotational speed [rad/s]')
    axs[5].legend(loc='upper right')
    axs[5].grid(True)

    # sensor 3 with injected noise
    axs[6].plot(results['time'], results['add3.y'], label='sensor 3', color='magenta', alpha=0.7)
    axs[6].set_title('Sensor 3 with injected noise')
    axs[6].set_ylabel('Rotational speed [rad/s]')
    axs[6].legend(loc='upper right')
    axs[6].grid(True)
    
    # amplifier output
    axs[7].plot(results['time'], results['amplifier.v'], label='amplifier output', color='green', alpha=0.7)
    axs[7].set_title('Voltage output of the amplifier')
    axs[7].set_ylabel('Voltage')
    axs[7].legend(loc='upper right')
    axs[7].grid(True)
    
    plt.tight_layout()
    plt.subplots_adjust(bottom=0.1) # space for the lower textbox
    
    param_text = f"Parameters: Motor resistance (R) = {val_r} Ω  |  Coil inductor (L) = {val_l} H"
    
    fig.text(0.5, 0.02, param_text, ha='center', fontsize=11, fontweight='bold', 
             bbox=dict(boxstyle="round,pad=0.5", facecolor="#ada9a9", edgecolor="gray"))
    
    plt.show()
    
    print(results["variable_resistor.R"])
    print(results["inductor.L"])