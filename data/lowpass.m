function [x]=lowpass(x,f_cutoff,f_aquis)
%filtre passe bas
rate = f_aquis;% frq d'acquisition

[B_filt, A_filt] = butter(3, (2 * f_cutoff / rate));
x = filtfilt(B_filt, A_filt, x);