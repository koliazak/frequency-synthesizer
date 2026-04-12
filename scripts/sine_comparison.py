import numpy as np
import matplotlib.pyplot as plt


fpga_sine = (np.loadtxt("sine_out.txt"))

t = np.linspace(0, 2*2*np.pi, len(fpga_sine))
ideal_sine =  (np.sin(t) + 1) * 127.5

plt.figure(figsize=(10,5))

plt.plot(ideal_sine, label="Ideal sine (Analogue)", linewidth=2, zorder=1)

plt.step(range(len(fpga_sine)), fpga_sine, label="Sine from DDS", linewidth=2, zorder=2)

plt.title("Comparison of ideal and generated 1kHz sine")
plt.xlabel("Sample")
plt.ylabel("Amplitude (0 - 255)")
plt.legend()
plt.grid(True)
plt.savefig("Sine-Comparison.png")
plt.show()