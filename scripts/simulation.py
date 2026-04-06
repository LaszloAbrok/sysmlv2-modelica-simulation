import fmpy
import matplotlib.pyplot as plt


fmu_file_name = '../modelica/fmus/DCMotorControlBase.fmu'

fmpy.dump(fmu_file_name)

result = fmpy.simulate_fmu(
    fmu_file_name,
    start_time = 0.0,
    stop_time = 10.0,
    debug_logging=True,
    output_interval=0.005,
    output = ['reference.y', 'sensor.w']
)

plt.figure(figsize=(10, 5))

plt.plot(result['time'], result['reference.y'], label='Target velocity (reference.y)', linestyle='--', color='blue')
plt.plot(result['time'], result['sensor.w'], label='Measured velocity (sensor.w)', color='red')

plt.xlabel('Time [s]')
plt.ylabel('Angular velocity [rad/s]')
plt.title('DC Motor base simulation')
plt.legend()
plt.grid(True)

plt.show()