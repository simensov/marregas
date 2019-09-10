#!/usr/bin/env python
'''
Code for assignment 2 in TMR4240, 2019
Simen Sem Oevereng
'''

import numpy as np 
import math
import matplotlib.pyplot as plt
import time
import random
import matplotlib.animation as animation

# Constants given
H_significant = 2.5
T_peak        = 9.0
omega_peak    = 2 * math.pi / T_peak # [Hz]
omega_peak	  = 2 * math.pi * omega_peak # [rad/s]
omega_low     = 0.2
omega_high    = 3 * omega_peak

# Other constants
g_accel = 9.81
PLT_NUM = 150
dw      = (omega_high - omega_low) / PLT_NUM
w_range = np.linspace(omega_low,omega_high,PLT_NUM) # 150 instances of frequencies between lower and upper given
horizontal_range = 5000
x_range = np.linspace(0,horizontal_range,1001) # 5000 meters horizontally

# ITTC spectra

class Spectra():

    def __init__(self,H_s,wp,g):
        self.H_sign  = H_s
        self.w_peak  = wp
        self.gravity = g
    
    def PM(self,w):
        '''
        Returns S-value of a standard Pierson-Moskowitz spectrum
        '''
        A = 0.0081 * self.gravity**2
        B = 5.0 / 4 * self.w_peak**4

        return A / w**5 * math.exp(-B / w_peak**4)

    def ITTC(self,w):
        '''
        Returns S-value of the ITTC spectra for initialized peak frequency, for a certain frequenct component w
        TODO: This should be a class itself which inherits from Spectra, so that A and B cpuld be member variables.
        '''
        A = 0.31 * self.H_sign**2 * self.w_peak**4
        B = 1.25 * self.w_peak**4

        return A / w**5 * math.exp(-B / w**4)

    def ITTC_spectra_moment(self,lower_bound,upper_bound):
        '''
        Calculates the spectra moment / zeroth moment / variance of the ITTC spectra by pre-calculated integration
        '''
        A = 0.31 * self.H_sign**2 * self.w_peak**4
        B = 1.25 * self.w_peak**4

        return A / (4*B) * (math.exp(-B / upper_bound**4) - math.exp(-B / lower_bound**4))

    def ITTC_elevation(self,t):
        '''
        Returns a list of surface elevation at a given time.
        Using surface = sum_q amplitude_wq * cos(wq * t - kq * x + phi_q) where:
             phi is uniformly distributed between 0 and 2pi, chosen randomly for each wave component
             amplitude is found from sqrt(2 * Spectra(w) * dw)
             k_w is the wave number for a certain wave component, in deep water it is found from wave dispersion w^2 = kg

        '''
        amplitudes = []
        phis = []
        ks = []
        for w in w_range:
            amplitudes.append(math.sqrt(2 * spectra.ITTC(float(w)) * dw))
            phis.append(random.uniform(0,2 * math.pi))
            ks.append(float(w)**2 / g_accel)

        wave_components_at_t = [0]*len(x_range) # empty list representing all x-coordinates, to be sum of all wave components

        for i in range(len(x_range)):
            zeta_temp = [0]*len(amplitudes) # temporary elevation

            for q in range(len(amplitudes)):
                zeta_temp[q] = amplitudes[q] * math.cos(float(w_range[q]) * t - ks[q] * x_range[i] + phis[q]) # wave elevation at x_i for all wave components

            wave_components_at_t[i] = sum(zeta_temp) # one regular wave for current amplitude at a certain x coordinate

        return wave_components_at_t

    def ITTC_surface_elevation_animation(self):
        '''
        Plots a realization of the surface elevation over time for a long-crested sea using the given ITTC spectra.
        Status on this function: I am struggling with slowing down the speed of the animation. I am changing to MATLAB for the task that requires the simulation since I am more used to it there
        '''

        fig   = plt.figure(figsize=(16, 9), facecolor='w')
        ax    = fig.add_subplot(1, 1, 1)
        plt.rcParams['font.size'] = 15

        lns = []

        # Two list of lists with solutions of each time step
        dt = 0.05
        time_instances = np.linspace(0,30,int(1/dt))
        sol = [self.ITTC_elevation(t) for t in time_instances] # list of sea elevation at each time instance

        # sol and time_instances is now of equal length, sol having a list of wave elevation for each instance of time_instances

        for i in range(len(time_instances)):
            ln, = ax.plot(x_range,sol[i], color='b', lw=2)
            tm = ax.text(-1, 0.9, 'time = %.1fs' % time_instances[i])
            lns.append([ln, tm])

        # ax.set_aspect('equal', 'datalim')
        ax.set_ylim(-5,5)
        ax.set_xlim(0,horizontal_range)
        ax.grid()

        ani = animation.ArtistAnimation(fig, lns, interval=int(dt*100),blit=True) 
        ani.save('surface_elevation_simulation_too_fast.mp4', fps=12)
        
        return True

    def JONSWAP(self,w):
        '''
        Plots the JONSWAP spectra, using parameters recommended by Faltinsen (1993)
        Validity area: { 1.25 / sqrt(H_sign) < w_peak < 1.75 / sqrt(H_sign) }
        '''
        alpha = 0.2 * self.H_sign**2 * self.w_peak**4 / self.gravity**2
        gamma = 3.3
        sigma = 0.07 if w <= self.w_peak else 0.09

        return alpha * self.gravity**2 / w**5 * math.exp(-5.0 / 4 * (self.w_peak / w)**4) * gamma**(math.exp(-0.5 * ((w - self.w_peak) / (sigma*self.w_peak))**2 ))


def plotITTC(ax,spectra,lower_bound,upper_bound):
    # Plots ITTC with PLT_NUM values in given interval in assignment

    
    plot_range = np.linspace(lower_bound,upper_bound,PLT_NUM)
    spectra_range = [spectra.ITTC(w) for w in plot_range]
    ax.plot(plot_range,spectra_range, linestyle = '--', marker = 'x', color = 'cornflowerblue')

    return plot_range, spectra_range


# Assignment 1
spectra = Spectra(H_significant, omega_peak, g_accel)
fig, ax = plt.subplots()

plt.rc('font', family='serif')

# a) - ITTC
ax.text(0.42, 0.02, "Peak frequency at {:.2f}".format(omega_peak), horizontalalignment='center', verticalalignment='center', transform=ax.transAxes)
ax.set_title("ITTC spectra between wave frequencies {:.2f} and {:.3f} [rad/s]".format(omega_low,omega_high), fontsize=11,fontweight='bold')
ax.set_xlabel("Wave frequency [rad/s]", fontsize=11,fontweight='bold')
ax.set_ylabel("S [m^2/s]", fontsize=11,fontweight='bold')
w_range, S_range = plotITTC(ax,spectra,omega_low,omega_high)

fig.savefig("ITTC_spectra.pdf", bbox_inches='tight')

# b) - RMS / std deviation of sea surface from plotted data
# Using the relation m0 = integral_wlower^wupper(S(w) * dw) with trapezoidal integration

m0 = spectra.ITTC_spectra_moment(omega_low,omega_high)
print(m0)
print("Std deviation from dataplots: ", math.sqrt(m0))

# c) Using given H_s instead
# Using the relationship Hm0 = 4 * sqrt(m0), where m0 is the spectral moment / the variance, standard deviation is found from sqrt(m0)
Hm0 = 4 * math.sqrt(m0)

print("Significant wave height from dataplots:", Hm0)

# d) Plot sea elevation
# spectra.ITTC_surface_elevation_animation() # This functions creates an animation which is way to fast, and I haven't managed to slow it down. Done in MATLAB instead

# Show all
plt.show()