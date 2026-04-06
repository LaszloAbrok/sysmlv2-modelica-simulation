import matplotlib.pyplot as plt
import fmpy
import numpy as np

fmu_file_name = '../modelica/fmus/DCMotorControlTMR.fmu'

fmpy.dump(fmu_file_name)

# hibák a rendszerben

# szenzor jel hiba
# 3 szenzor modellezése egy saját 3 bemenetű voting gate-tel, ami mediánt vesz
# a helyes méréshez a 3 csatornánk hozzáadjuk a különbőző hibákat
# hibás bemenet akkor kerül elfogadásra ha legalább kettő is hibás
# ez hibás feedbacket eredményez, nem lesz jó a szabályzás 
# az, hogy ez mennyire rossz függ attól, hogy milyen jel van benne
# pl. szinuszos hiba esetén periodikusan vannak olyan szakaszok ahol még egészen meg tudja közelíteni a valóságot

#TODO: szenzor drift

#TODO: motor meghibásodásának modellezése

#TODO: ellenállás változtatása
# más ellenállás érték
# motor tekercseinek ellenállása megnövekszik túlmelegedés, korrózió stb. miatt

# TODO: induktivitás változtatása
# tekercs induktivitásának növekedése
# L csökken, I nő
# pl. akkor ha néhány menet rövidre záródik, mert megsérült a szigetelés

# TODO: load növelése
# terhelés növekedése
# valami megfogja a motort

# TODO: súrlódás
# viszkózus súrlódás damper segítségével
# ez viszont nem annyira pillanatszerű, hanem teljes életciklusra vonatkozó hiba

# injection 1

T = np.arange(0, 10, 0.005)

A = 30.0
Freq = 0.5
Phase = 0.0

injection_1 = A * np.sin(2 * np.pi * Freq * T + Phase)

# plt.figure(figsize=(10, 5))
# plt.title("Injection 1")
# plt.plot(T, injection_1)
# plt.grid(True)
# plt.show()

injection_2 = np.zeros_like(T)
injection_2[T >= 0.5] = 100.0 # stuck at value after a certain time

injection_3 = np.zeros_like(T) # no problem

dtype = [('time', np.float64), ('injection1', np.float64), ('injection2', np.float64), ('injection3', np.float64)]
input_data = np.zeros(len(T), dtype=dtype)

input_data['time'] = T
input_data['injection1'] = injection_1
input_data['injection2'] = injection_2
input_data['injection3'] = injection_3

result = fmpy.simulate_fmu(
    fmu_file_name,
    start_time = 0.0,
    stop_time = 10.0,
    debug_logging=True,
    output_interval=0.005,
    input=input_data,
    output = ['voter.y', 'feedback.u2', 'truthSensor.w']
)


# plots

fig, (ax1, ax2, ax3, ax4) = plt.subplots(4, 1, figsize=(10, 10), sharex=True)

# injected failure on the sensor

ax1.plot(input_data['time'], input_data['injection1'], label='injection 1', color='red', alpha=0.7)
ax1.plot(input_data['time'], input_data['injection2'], label='injection 2', color='orange', alpha=0.7)
ax1.plot(input_data['time'], input_data['injection3'], label='injection 3', color='magenta', alpha=0.7)

ax1.set_ylabel('Injected noise [rad/s]')
ax1.set_title('Noises of the 3 speed sensor (failure injection)')
ax1.legend(loc='upper right')
ax1.grid(True) 

# voter output

ax3.plot(result['time'], result['feedback.u2'], label='PID feedback', color='red', alpha=0.7)
ax3
ax3.set_ylabel('PID feedback [rad/s]')
ax3.set_title('PID feedback input')
ax3.legend(loc='upper right')
ax3.grid(True) 

# real sensor output

ax4.plot(result['time'], result['truthSensor.w'], label='Rotational speed sensor', color='blue', alpha=0.7)
ax4
ax4.set_ylabel('Rotational speed sensor [rad/s]')
ax4.set_title('PID feedback input')
ax4.legend(loc='upper right')
ax4.grid(True)

plt.tight_layout()
plt.show()

# injected noise

