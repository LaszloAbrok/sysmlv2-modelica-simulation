import tkinter as tk
from tkinter import ttk, messagebox

from simulation import run_motor_simulation

PARAM_MAP = {
    "none": [],
    "sinusoidal": ["amplitude", "frequency", "phase"],
    "offset": ["offset"],
    "drift": ["drift_rate"],
    "step": ["time_start", "step_value"],
    "stuck": ["time_start", "stuck_value"]
}

def create_sensor_panel(parent, title):
    frame = tk.LabelFrame(parent, text=title, padx=10, pady=10)
    
    tk.Label(frame, text="Error type:").grid(row=0, column=0, sticky="e")
    combo = ttk.Combobox(frame, values=list(PARAM_MAP.keys()), state="readonly", width=15)
    combo.set("none")
    combo.grid(row=0, column=1, pady=5)
    
    labels = []
    entries = []
    for i in range(3):
        lbl = tk.Label(frame, text="")
        lbl.grid(row=i+1, column=0, sticky="e")
        ent = tk.Entry(frame, width=18)
        ent.insert(0, "0.0")
        ent.grid(row=i+1, column=1, pady=2)
        
        lbl.grid_remove() 
        ent.grid_remove() 
        
        labels.append(lbl)
        entries.append(ent)
        
    def on_combo_change(event):
        selected = combo.get()
        params_needed = PARAM_MAP[selected]
        
        for i in range(3):
            if i < len(params_needed):
                labels[i].config(text=params_needed[i] + ":")
                labels[i].grid()
                entries[i].grid()
            else:
                labels[i].grid_remove()
                entries[i].grid_remove()
                
    combo.bind("<<ComboboxSelected>>", on_combo_change)
    return frame, combo, labels, entries

def on_run_clicked():
    try:
        val_r = float(val_r_entry.get())
        val_l = float(val_l_entry.get())
        
        def get_sensor_params(combo, labels, entries):
            noise_type = combo.get()
            params = {}
            if noise_type != "none":
                needed_keys = PARAM_MAP[noise_type]
                for i, key in enumerate(needed_keys):
                    params[key] = float(entries[i].get())
            return (noise_type, params)

        s1_config = get_sensor_params(s1_combo, s1_labels, s1_entries)
        s2_config = get_sensor_params(s2_combo, s2_labels, s2_entries)
        s3_config = get_sensor_params(s3_combo, s3_labels, s3_entries)
        
    except ValueError:
        messagebox.showerror("Error", "Please only give real inputs!")
        return

    try:
        run_motor_simulation(val_r, val_l, s1_config, s2_config, s3_config)
    except Exception as e:
        messagebox.showerror("Simulation error", str(e))

root = tk.Tk()
root.title("DC Motor Control Simulation")
root.geometry("400x750")

s1_frame, s1_combo, s1_labels, s1_entries = create_sensor_panel(root, "Rotation speed sensor #1")
s1_frame.pack(fill="x", padx=20, pady=5)

s2_frame, s2_combo, s2_labels, s2_entries = create_sensor_panel(root, "Rotation speed sensor #2")
s2_frame.pack(fill="x", padx=20, pady=5)

s3_frame, s3_combo, s3_labels, s3_entries = create_sensor_panel(root, "Rotation speed sensor #3")
s3_frame.pack(fill="x", padx=20, pady=5)

phys_frame = tk.LabelFrame(root, text="DC Motor parameters", padx=10, pady=10)
phys_frame.pack(fill="x", padx=20, pady=5)

tk.Label(phys_frame, text="DC Motor resistance (Ohm):").pack(anchor="w")
val_r_entry = tk.Entry(phys_frame)
val_r_entry.insert(0, "1.0")
val_r_entry.pack(fill="x", pady=2)

tk.Label(phys_frame, text="DC Motor coil inductance (H):").pack(anchor="w", pady=(10,0))
val_l_entry = tk.Entry(phys_frame)
val_l_entry.insert(0, "0.01")
val_l_entry.pack(fill="x", pady=2)

btn_run = tk.Button(root, text="Run simulation", command=on_run_clicked, bg="#274BC2", fg="white", font=("Arial", 12, "bold"))
btn_run.pack(pady=20, ipadx=20, ipady=10)

root.mainloop()