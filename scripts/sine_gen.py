import math

SAMPLES   = 512
BIT_WIDTH = 8
FILENAME  = "sine.mem"


MAX_VAL = (2**BIT_WIDTH) - 1
OFFSET  = MAX_VAL / 2
AMPLITUDE = MAX_VAL / 2

with open (FILENAME, "w") as f:
	for i in range(SAMPLES):
		angle = 2 * math.pi * i / SAMPLES
		val = int(OFFSET + AMPLITUDE * math.sin(angle))
		f.write(f"{val:02X}\n")

print(f"File {FILENAME} sussessfully created!")
