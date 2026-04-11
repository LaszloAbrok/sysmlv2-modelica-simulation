import numpy as np


def get_sinusoidal_noise(time_vector, amplitude, frequency, phase):
    return amplitude * np.sin(2 * np.pi * frequency * time_vector + phase)

def get_offset_noise(time_vector, offset):
    return offset * np.ones_like(time_vector)

def get_drift_noise(time_vector, drift_rate):
    return drift_rate * time_vector

def get_stuck_value(time_vector, time_start, stuck_val):
    trigger = (time_vector >= time_start) 
    stuck_array = np.where(time_vector >= time_start, stuck_val, 0.0)
    return trigger, stuck_array


def generate_error_profile(time_vector, noise_type, params):
    
    error = np.zeros_like(time_vector, dtype = np.float64)
    trigger = np.zeros_like(time_vector, dtype = np.float64)
    stuck_value = np.zeros_like(time_vector, dtype = np.float64)
    
    if noise_type == "sinusoidal":
        amplitude = params.get("amplitude", 1.0)
        frequency = params.get("frequency", 1.0)
        phase = params.get("phase", 0.0)
        error = get_sinusoidal_noise(time_vector, amplitude, frequency, phase)
    
    elif noise_type == "offset":
        offset = params.get("offset", 0.0)
        error = get_offset_noise(time_vector, offset)

    elif noise_type == "drift":
        drift_rate = params.get("drift_rate", 0.0)
        error = get_drift_noise(time_vector, drift_rate)
    
    elif noise_type == "step":
        time_start = params.get("time_start", 0.0)
        step_value = params.get("step_value", 0.0)
        error = np.where(time_vector >= time_start, step_value, 0.0)
    
    elif noise_type == "stuck":
        time_start = params.get("time_start", 0.0)
        val = params.get("stuck_value", 0.0) 
        trigger, stuck_value = get_stuck_value(time_vector, time_start, val)
        
    return error, trigger, stuck_value