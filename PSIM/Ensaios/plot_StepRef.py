import matplotlib
import pandas as pd
import matplotlib.pyplot as plt

import numpy as np

plt.rcParams.update({'font.size': 14})

df = pd.read_csv("ensaio_StepRef.txt", sep="\s+")

time = df['Time']
vpv_PI = df['Vin']
vpv_FGS_PI = df['Vin2']
vref = df['Vref']
kp_fuzzy = df['kp_fuzzy']
ki_fuzzy = df['ki_fuzzy']

time = time[0:-1:10]
vpv_PI = vpv_PI[0:-1:10]
vpv_FGS_PI = vpv_FGS_PI[0:-1:10]
vref = vref[0:-1:10]
kp_fuzzy = kp_fuzzy[0:-1:10]
ki_fuzzy = ki_fuzzy[0:-1:10]
kp_0 = 0.0055*np.ones_like(kp_fuzzy)
ki_0 = 3.23*np.ones_like(ki_fuzzy)

fig1, f1_axes = plt.subplots(ncols=1, nrows=3, figsize=(15,10))
f1_axes[0].set_xlim([0.09, 0.25])
f1_axes[0].set_ylim([22, 27])
f1_axes[0].grid(True); f1_axes[1].grid(True); f1_axes[2].grid(True)
f1_axes[0].plot(time, vpv_PI, linewidth=1.5, label="$v_{pv}$ (PI)", color='r')
f1_axes[0].plot(time, vpv_FGS_PI, linewidth=1.5, label="$v_{pv}$ (FGS-PI)", color='g')
f1_axes[0].plot(time, vref, linewidth=1.5, label="$v_{ref}$", color='b', linestyle='dashed')
# f1_axes[0].set_xlabel("Tempo (s)")
f1_axes[0].set_ylabel("Tensão $v_{pv}$ (V)")
f1_axes[0].legend()
f1_axes[1].set_xlim([0.09, 0.25])
# f1_axes[1].set_ylim([-0.001, 0.006])
f1_axes[1].plot(time, kp_0, linewidth=1.5, label="$kp$ (PI)", color='r')
f1_axes[1].plot(time, kp_fuzzy, linewidth=1.5, label="$kp$ (FGS-PI)", color='g')
# f1_axes[1].set_xlabel("Tempo (s)")
f1_axes[1].set_ylabel("$kp$")
f1_axes[1].legend()
f1_axes[2].set_xlim([0.09, 0.25])
f1_axes[2].set_ylim([3, 9])
f1_axes[2].plot(time, ki_0, linewidth=1.5, label="$ki$ (PI)", color='r')
f1_axes[2].plot(time, ki_fuzzy, linewidth=1.5, label="$ki$ (FGS-PI)", color='g')
f1_axes[2].set_xlabel("Tempo (s)")
f1_axes[2].set_ylabel("$ki$")
f1_axes[2].legend()
plt.show()