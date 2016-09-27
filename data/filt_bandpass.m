%MCG_ANALYSIS: Apply frequency filters to magnetic cardiography signal from
% atomic magnetometers of QuSpin and plot raw and filtered signals and
% frequency spectrum and periodogram from fast fourier transform.
% Author: Victor Hugo Souza
% E-mail: victorhos@hotmail.com
% Date: 2016-08-30
%
% Input:
% data: 2 column array - first colmun for time and second column for signal
% freq_cut: [high low] - high cutoff and low cutoff frequency (Hz)
% fsamp: constant sampling frequency (Hz)
%
% Output:
% t: single column array of time values
% notchz: frequency filtered single column array of signal values
%
% Example:
%
% dataz1 = load('QMAG1_0_z.lvm', '-ascii');
% [t, notchz] = mcg_analysis(dataz1, [8 80], 200)

function filtdata = filt_bandpass(data, freq_cut, fsamp)

% frequency filter
[bb,ab] = butter(2, [freq_cut(1) freq_cut(2)]*2/fsamp, 'bandpass'); % Filter coefficients band
% [bs,as] = butter(2, [59 61]*2/fsamp, 'stop'); % Filter coefficients notch

filtdata = filtfilt(bb, ab, data);
% filtdata = filtfilt(bs, as, bandz);

end

