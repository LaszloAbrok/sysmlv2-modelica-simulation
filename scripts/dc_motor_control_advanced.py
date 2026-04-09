import matplotlib.pyplot as plt
import fmpy
import numpy as np
import tkinter as tk
from tkinter import messagebox
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
fmu_file_name = os.path.normpath(os.path.join(script_dir, '../modelica/fmus/DCMotorControlAdvanced.fmu'))

def run_simulation():
    
    # getting entries from the GUI
    
    try:
        sfj_1 = float(sfj_1_entry.get())
        sfj_2 = float(sfj_2_entry.get())
        sfj_3 = float(sfj_3_entry.get())
        val_r = float(val_r_entry.get())
        val_l = float(val_l_entry.get())
    except ValueError:
        messagebox.showerror("ValueError")
    
    time_vec = np.arange(0.0, 10.0, 0.005)
    
    # structured numpy arra for inputs
    
    dtype = [('time', np.float64), ('sfj_1', np.float64),
             ('sfj_2', np.float64), ('sfj_3', np.float64),
             ('val_r', np.float64), ('val_l', np.float64)]
    
    input_data = np.zeros(len(time_vec), dtype=dtype)
    
    input_data['time'] = time_vec

    input_data['sfj_1'] = sfj_1
    input_data['sfj_2'] = sfj_2
    input_data['sfj_3'] = sfj_3
    input_data['val_r'] = val_r
    input_data['val_l'] = val_l
    
    # print out inputs
    
    print("Inputs:")
    print(input_data)
    
    # getting outputs from the simulation
    
    simulation_outputs = [
        "true_sensor.w",
        "voter.y",
        "sensor_failure_injection_1",
        "sensor_failure_injection_2",
        "sensor_failure_injection_3",
        "resistor_failure_injection",
        "inductor_failure_injection",
        "variable_resistor.R",
        "inductor.L"
    ]
    
    try:
        print("Starting simulation...")
        results = fmpy.simulate_fmu(
            fmu_file_name,
            start_time = 0.0,
            stop_time = 10.0,
            debug_logging=True,
            output_interval=0.005,
            step_size=0.0005,
            # step_size=0.001,
            # fmi_type='ModelExchange',
            input = input_data,
            output = simulation_outputs,
            fmi_type='ModelExchange',
            # solver='CVode',
            # relative_tolerance=1e-5
        )
        print("Simulation completed.")
    except Exception as e:
        messagebox.showerror("Simulation Error", str(e))
        return

    # debug_time = 1.0
    # index = np.where(results['time'] == debug_time)[0][0]
    # print(f"resistor {results['resistor_failure_injection'][index]} Ohm")
    # print(f"inductor {results['inductor_failure_injection'][index]} H")
    
    # plotting

    fig, axs = plt.subplots(4, 1, figsize=(10, 12), sharex=True)
    
    # injected failure on the sensor

    axs[0].plot(results['time'], results['voter.y'], label='true sensor data', color='red', alpha=0.7)
    axs[0].set_title('True rotational speed measurement')
    axs[0].set_ylabel('Rotational speed [rad/s]')
    axs[0].legend(loc='upper right')
    axs[0].grid(True)

    # axs[0].plot(results['time'], results['PID.u_m'], label='true sensor data', color='red', alpha=0.7)
    # axs[0].set_title('True rotational speed measurement')
    # axs[0].set_ylabel('Rotational speed [rad/s]')
    # axs[0].legend(loc='upper right')
    # axs[0].grid(True)

    # sensor noise 1
    axs[1].plot(results['time'], results['sensor_failure_injection_1'], label='injection 1', color='red', alpha=0.7)
    axs[1].set_title('Noise on the sensor 1')
    axs[1].set_ylabel('Injected noise [rad/s]')
    axs[1].legend(loc='upper right')
    axs[1].grid(True)
    
    # sensor noise 2
    axs[2].plot(results['time'], results['sensor_failure_injection_2'], label='injection 2', color='orange', alpha=0.7)
    axs[2].set_title('Noise on the sensor 2')
    axs[2].set_ylabel('Injected noise [rad/s]')
    axs[2].legend(loc='upper right')
    axs[2].grid(True)

    # sensor noise 3
    axs[3].plot(results['time'], results['sensor_failure_injection_3'], label='injection 3', color='magenta', alpha=0.7)
    axs[3].set_title('Noise on the sensor 3')
    axs[3].set_ylabel('Injected noise [rad/s]')
    axs[3].legend(loc='upper right')
    axs[3].grid(True)
    
    plt.subplots_adjust(bottom=0.15)
    
    param_text = f"Parameters: Motor resistance (R) = {val_r} Ω  |  Coil inductor (L) = {val_l} H"
    
    fig.text(0.5, 0.04, param_text, ha='center', fontsize=11, fontweight='bold', 
             bbox=dict(boxstyle="round,pad=0.5", facecolor="#f0f0f0", edgecolor="gray"))
    
    # plt.tight_layout()
    plt.show()
    
    
    print(results["variable_resistor.R"])
    print(results["inductor.L"])


# GUI what

# --- 3. GRAFIKUS FELÜLET (GUI) FELÉPÍTÉSE ---
root = tk.Tk()
root.title("Kiberfizikai Hibainjektáló Tesztpad")
root.geometry("400x350")
root.configure(padx=20, pady=20)

# Címkék és beviteli mezők (Entry) létrehozása
tk.Label(root, text="Szenzor 1 Zaj (rad/s):").grid(row=0, column=0, sticky="w", pady=5)
sfj_1_entry = tk.Entry(root)
sfj_1_entry.insert(0, "0.0")
sfj_1_entry.grid(row=0, column=1)

tk.Label(root, text="Szenzor 2 Zaj (rad/s):").grid(row=1, column=0, sticky="w", pady=5)
sfj_2_entry = tk.Entry(root)
sfj_2_entry.insert(0, "0.0")
sfj_2_entry.grid(row=1, column=1)

tk.Label(root, text="Szenzor 3 Zaj (rad/s):").grid(row=2, column=0, sticky="w", pady=5)
sfj_3_entry = tk.Entry(root);
sfj_3_entry.insert(0, "0.0");
sfj_3_entry.grid(row=2, column=1)

tk.Label(root, text="-------------------------").grid(row=3, columnspan=2)

tk.Label(root, text="Motor Ellenállás (Ohm):").grid(row=4, column=0, sticky="w", pady=5)
val_r_entry = tk.Entry(root)
val_r_entry.insert(0, "1.0")
val_r_entry.grid(row=4, column=1) 

tk.Label(root, text="Tekercs Induktivitás (H):").grid(row=5, column=0, sticky="w", pady=5)
val_l_entry = tk.Entry(root);
val_l_entry.insert(0, "0.01");
val_l_entry.grid(row=5, column=1)

tk.Label(root, text="-------------------------").grid(row=6, columnspan=2)

# run button
btn_run = tk.Button(root, text="Szimuláció Futtatása", command=run_simulation, bg="#4CAF50", fg="white", font=("Arial", 12, "bold"))
btn_run.grid(row=7, columnspan=2, pady=15, ipadx=10, ipady=5)

# running main loop for tk
root.mainloop()
