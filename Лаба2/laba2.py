import numpy as np
import matplotlib.pyplot as plt
import math

f = 1800e6  #Гц
Tx_BS = 46
sector_BS = 3
Tx_UE = 24
AntGain_BS = 21
FeederLoss = 2.9
Penetration = 15
IM = 1
BW_UL = 10e6
BW_DL = 20e6
Noise_BS = 2.4
Noise_UE = 6
SINR_DL = 2
SINR_UL = 4
MIMO = 3  # дБ

#1 задание
ThermalNoise_UL = -174 + 10 * np.log10(BW_UL)
RxSens_BS = Noise_BS + ThermalNoise_UL + SINR_UL
MAPL_UL = Tx_UE - FeederLoss + AntGain_BS + MIMO - IM - Penetration - RxSens_BS
print("MAPL_UL = ", MAPL_UL, "дБ")

ThermalNoise_DL = -174 + 10 * np.log10(BW_DL)
RxSens_UE = Noise_UE + ThermalNoise_DL + SINR_DL
MAPL_DL = Tx_BS - FeederLoss + AntGain_BS + MIMO - IM - Penetration - RxSens_UE
print("MAPL_DL = ", MAPL_DL, "дБ")

#2 задание
d = np.linspace(0.01, 10, 5000)  # км

# COST231 Hata
a = 46.3
bс = 33.9
hBS = 30
hMS = 1.5
a_hUE = (1.1 * np.log10(f / 1e6) - 0.7) * hMS - (1.56 * np.log10(f / 1e6) - 0.8)
Lclutter = 0
s = 44.9 - 6.55 * np.log10(hBS)
PL_COST231 = a + bс * np.log10(f / 1e6) - 13.82 * np.log10(hBS) - a_hUE + s * np.log10(d) + Lclutter

# UMiNLOS
PL_UMiNLOS = 26 * np.log10(f / 1e9) + 22.7 + 36.7 * np.log10(d * 1000)

# Walfish–Ikegami
#прямая видимость у БС
PL_WI_LOS = 42.6 + 26 * np.log10(d) + 20 * np.log10(f / 1e6)
#отстуствия прямой видимость БС
b = 50  #расстояние между зданиями
phi = 45   #угол
w = 20  #ширина улицы
delta_h = 20 - 1.5 #разность между высотой зданий и абонентом
L0 = 32.44 + 20*np.log10(f/1e6) + 20*np.log10(d)

if hBS > delta_h:
    L11 = -18 * np.log10(1 + (hBS - delta_h))
else:
    L11 = 0

if hBS > delta_h:
     ka = 54
elif d > 0.5:
    ka = 54 - 0.8 * (hBS - delta_h)
else:
    ka = 54 - 0.8 * (hBS - delta_h) * (d / 0.5)

if hBS > delta_h:
    kd = 18
else:
     kd = 18 - 15 * ((hBS - delta_h) / delta_h)
    
kf = -4 + 0.7 * (f/1e6 / 925 - 1)

L1 = L11 + ka + kd* np.log10(d) + kf*np.log10(f/1e9) - 9*np.log10(b)

if 0 <= phi < 35:
    L2_term = -10 + 0.354 * phi
elif 35 <= phi < 55:
    L2_term = 2.5 + 0.075 * (phi - 35)
elif 55 <= phi < 90:
    L2_term = 4.0 - 0.114 * (phi - 55)
else:
    L2_term = 4.0

L2 = -16.9 - 10 * np.log10(w) + 10 * np.log10(f/1e9) + 20 * np.log10(delta_h) + L2_term

PL_WI_NLOS = L0 + L1 + L2
#PL_WI_NLOS = np.where(L1 + L2 > 0, L0 + L1 + L2, L0)

plt.figure(figsize=(9, 6))
plt.plot(d, PL_COST231, 'r', label='COST231 Hata', linewidth=2)
plt.plot(d, PL_UMiNLOS, 'b', label='UMi NLOS', linewidth=2)
plt.plot(d, PL_WI_NLOS, 'g', label='Walfish–Ikegami без прямой видимости', linewidth=2)
plt.plot(d, PL_WI_LOS, 'black', label='Walfish–Ikegami прямая видимость', linewidth=2)
plt.axhline(MAPL_UL, color='r', linestyle='--', linewidth=1.2, label='MAPL UL = ' + str(MAPL_UL) + ' дБ')
plt.axhline(MAPL_DL, color='b', linestyle='--', linewidth=1.5, label='MAPL DL = ' + str(MAPL_DL) + ' дБ')
plt.xlabel('Расстояние, км')
plt.ylabel('Path Loss, дБ')
plt.title('Зависимость Path Loss от расстояния для разных моделей')
plt.legend()
plt.grid(True)
plt.show()

#3 задание

def find_distance(PL_model, d, MAPL_value):
    if MAPL_value < np.min(PL_model) or MAPL_value > np.max(PL_model):
        return np.nan
    return np.interp(MAPL_value, PL_model, d)   #интерполяция

#радиусы
d_UL_COST231 = find_distance(PL_COST231, d, MAPL_UL)  
d_DL_COST231 = find_distance(PL_COST231, d, MAPL_DL) 

d_UL_UMI = find_distance(PL_UMiNLOS, d, MAPL_UL)  
d_DL_UMI = find_distance(PL_UMiNLOS, d, MAPL_DL) 

R_COST231 = min(d_UL_COST231, d_DL_COST231)
R_UMI = min(d_UL_UMI, d_DL_UMI)

#площади покрытия БС
S_COST231 = 1.95 * R_COST231**2
S_UMI = 1.95 * R_UMI**2

S_1 = 100  # км^2
S_2 = 4    #км^2
N_BS_COST231 = math.ceil(S_1 / S_COST231)
N_BS_UMI = math.ceil(S_2 / S_UMI)

print("\nОграничивающий радиус соты COST231 = ", R_COST231, "км")
print("Ограничивающий радиус соты UMiNLOS = ", R_UMI, "км")
print("Площадь одной БС COST231 = ", S_COST231, "км²")
print("Площадь одной БС UMiNLOS = ", S_UMI, "км²")
print("Необходимое количество БС COST231 = ", N_BS_COST231)
print("Необходимое количество БС UMiNLOS = ", N_BS_UMI)


#Дополнительное задание

#Зависимость радиуса от температуры
k = 1.380649e-23
temps = np.arange(-20, 61, 5)
T_K = temps + 273.15
R_UL_T, R_DL_T = [], []

for T in T_K:
    thermal_UL = 10*np.log10(k * T * BW_UL) + 30  
    thermal_DL = 10*np.log10(k * T * BW_DL) + 30
    
    RxSens_UL = Noise_BS + thermal_UL + SINR_UL
    RxSens_DL = Noise_UE + thermal_DL + SINR_DL
    
    MAPL_UL = Tx_UE - FeederLoss + AntGain_BS + MIMO - IM - Penetration - RxSens_UL
    MAPL_DL = Tx_BS - FeederLoss + AntGain_BS + MIMO - IM - Penetration - RxSens_DL
    
    d_test = np.linspace(0.01, 20, 20000)
    PL = a + b * np.log10(f / 1e6) - 13.82 * np.log10(hBS) - a_hUE + s * np.log10(d_test) + Lclutter

    #ищем первое расстояние, при котором потери сигнала ≥ максимально допустимым
    r_UL = PL >= MAPL_UL

    if r_UL.any():      #если пересечение найдено
        idx = r_UL.argmax()     #индекс первого True
        radius = d_test[idx]
    else:
        radius = np.nan
    R_UL_T.append(radius)

    r_DL = PL >= MAPL_DL
    
    if r_DL.any():
        idx = r_DL.argmax()
        radius = d_test[idx]
    else:
        radius = np.nan
    R_DL_T.append(radius)

plt.figure(figsize=(8,5))
plt.plot(temps, R_UL_T, 'r', label='UL')
plt.plot(temps, R_DL_T, 'b', label='DL')
plt.xlabel('Температура, °C')
plt.ylabel('Радиус соты, км')
plt.title('Зависимость радиуса соты от температуры')
plt.legend()
plt.grid(True)
plt.show()

#Зависимость радиуса от ширины полосы
bandwidths = np.linspace(1e6, 30e6, 50)
R_UL_BW, R_DL_BW = [], []

for BW in bandwidths:
    thermal = -174 + 10*np.log10(BW)

    RxSens_UL = Noise_BS + thermal + SINR_UL
    RxSens_DL = Noise_UE + thermal + SINR_DL
    
    MAPL_UL = Tx_UE - FeederLoss + AntGain_BS + MIMO - IM - Penetration - RxSens_UL
    MAPL_DL = Tx_BS - FeederLoss + AntGain_BS + MIMO - IM - Penetration - RxSens_DL
    
    d_test = np.linspace(0.01, 20, 20000)
    PL = a + b * np.log10(f / 1e6) - 13.82 * np.log10(hBS) - a_hUE + s * np.log10(d_test) + Lclutter


    r_UL = PL >= MAPL_UL

    if r_UL.any():      
        idx = r_UL.argmax()    
        radius = d_test[idx]
    else:
        radius = np.nan
    R_UL_BW.append(radius)

    r_DL = PL >= MAPL_DL
    
    if r_DL.any():
        idx = r_DL.argmax()
        radius = d_test[idx]
    else:
        radius = np.nan
    R_DL_BW.append(radius)

plt.figure(figsize=(8,5))
plt.plot(bandwidths/1e6, R_UL_BW, 'r', label='UL')
plt.plot(bandwidths/1e6, R_DL_BW, 'b', label='DL')
plt.xlabel('Ширина полосы, МГц')
plt.ylabel('Радиус соты, км')
plt.title('Зависимость радиуса соты от ширины полосы')
plt.legend()
plt.grid(True)
plt.show()