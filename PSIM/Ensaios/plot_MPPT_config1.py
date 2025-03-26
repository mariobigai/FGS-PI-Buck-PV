import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

plt.rcParams.update({'font.size': 14})

df = pd.read_csv("ensaio1_config1.txt", sep="\s+")

time = df['Time']
vpv_PI = df['Vin']
vpv_FGS_PI = df['Vin2']
vref_PI = df['Vref']
vref_FGS_PI = df['Vref2']
kp_fuzzy = df['kp_fuzzy']
ki_fuzzy = df['ki_fuzzy']
pmax = df['Pmax']
ipv_PI = df['ipv']
ipv_FGS_PI = df['ipv2']

time = time[0:-1:10]
vpv_PI = vpv_PI[0:-1:10]
vpv_FGS_PI = vpv_FGS_PI[0:-1:10]
vref_PI = vref_PI[0:-1:10]
vref_FGS_PI = vref_FGS_PI[0:-1:10]
kp_fuzzy = kp_fuzzy[0:-1:10]
ki_fuzzy = ki_fuzzy[0:-1:10]
kp_0 = 0.0055*np.ones_like(kp_fuzzy)
ki_0 = 3.23*np.ones_like(ki_fuzzy)
pmax = pmax[0:-1:10]
ipv_PI = ipv_PI[0:-1:10]
ipv_FGS_PI = ipv_FGS_PI[0:-1:10]
ppv_PI = ipv_PI*vpv_PI
ppv_FGS_PI = ipv_FGS_PI*vpv_FGS_PI

x_lim = [1.99, 2.49]

# fig1, f1_axes = plt.subplots(ncols=1, nrows=3, figsize=(15,10))
# f1_axes[0].set_xlim(x_lim)
# f1_axes[0].set_ylim([24.4, 25.3])
# f1_axes[0].grid(True); f1_axes[1].grid(True); f1_axes[2].grid(True)
# f1_axes[0].plot(time, vpv_PI, linewidth=1.5, label="$v_{pv}$ (PI)", color='r')
# f1_axes[0].plot(time, vref_PI, linewidth=1.5, label="$v_{ref}$", color='b', linestyle='dashed')
# f1_axes[0].set_ylabel("Tensão $v_{pv}$ (V)")
# f1_axes[0].legend()
# f1_axes[1].set_xlim(x_lim)
# f1_axes[1].plot(time, kp_0, linewidth=1.5, label="$kp$ (PI)", color='r')
# f1_axes[1].set_ylabel("$kp$")
# f1_axes[1].legend()
# f1_axes[2].set_xlim(x_lim)
# f1_axes[2].plot(time, ki_0, linewidth=1.5, label="$ki$ (PI)", color='r')
# f1_axes[2].set_xlabel("Tempo (s)")
# f1_axes[2].set_ylabel("$ki$")
# f1_axes[2].legend()


fig2, f2_axes = plt.subplots(ncols=1, nrows=1, figsize=(15,10))
f2_axes.set_xlim(x_lim)
f2_axes.set_ylim([31, 33])
f2_axes.grid(True)
f2_axes.plot(time, ppv_PI, linewidth=1.5, label="$p_{pv}$ (PI)", color='r')
f2_axes.plot(time, ppv_FGS_PI, linewidth=1.5, label="$p_{pv}$ (FGS-PI)", color='g')
f2_axes.plot(time, pmax, linewidth=1.5, label="$P_{máx}$", color='b', linestyle='dashed')
f2_axes.set_xlabel("Tempo (s)")
f2_axes.set_ylabel("Potência $p_{pv}$ (W)")
f2_axes.legend()

# fig3, f3_axes = plt.subplots(ncols=1, nrows=3, figsize=(15,10))
# f3_axes[0].set_xlim(x_lim)
# f3_axes[0].set_ylim([24.3, 25.3])
# f3_axes[0].grid(True); f3_axes[1].grid(True); f3_axes[2].grid(True)
# f3_axes[0].plot(time, vpv_FGS_PI, linewidth=1.5, label="$v_{pv}$ (FGS-PI)", color='g')
# f3_axes[0].plot(time, vref_FGS_PI, linewidth=1.5, label="$v_{ref}$", color='b', linestyle='dashed')
# f3_axes[0].set_ylabel("Tensão $v_{pv}$ (V)")
# f3_axes[0].legend()
# f3_axes[1].set_xlim(x_lim)
# f3_axes[1].plot(time, kp_fuzzy, linewidth=1.5, label="$kp$ (FGS-PI)", color='g')
# f3_axes[1].set_ylabel("$kp$")
# f3_axes[1].legend()
# f3_axes[2].set_xlim(x_lim)
# f3_axes[2].plot(time, ki_fuzzy, linewidth=1.5, label="$ki$ (FGS-PI)", color='g')
# f3_axes[2].set_xlabel("Tempo (s)")
# f3_axes[2].set_ylabel("$ki$")
# f3_axes[2].legend()

plt.show()