function [amp, pmin, pmax] = p2p_amplitude(xs, data, fs)
data = squeeze(data);
xs = squeeze(xs);

if size(data,1) > 1 && size(data,2) > 1
    error('Data must have one dimension.');
end
if size(xs,1) > 1 && size(xs,2) > 1
    error('Time vector must have one dimension.');
end

t0 = 15;
tend = 60;

% find mep peak
mepwindow = data(round(t0*fs/1000):round(tend*fs/1000));
L = length(mepwindow);              % Length of signal
t = xs(round(t0*fs/1000)) + (0:L-1)/fs;
[pks, plocs] = findpeaks(mepwindow);
%         mep_peak = t(plocs(1)); % instant of mep peak
pp = pks == max(pks);

% find mep valley
[vls, vlocs] = findpeaks(-mepwindow);
%         mep_valley = t(vlocs(1)); % instant of mep peak
vv = vls == max(vls);

% use this when i need the position of peak and peak intensity separately
if ~isempty(plocs) && ~isempty(vlocs)
    tv_aux = t(vlocs(vv));
    tp_aux = t(plocs(pp));
    v_aux = mepwindow(vlocs(vv));
    p_aux = mepwindow(plocs(pp));
    
    if length(tv_aux)>1 || length(tp_aux)>1
        tv = tv_aux(1);
        tp = tp_aux(1);
        valley = v_aux(1);
        peak = p_aux(1);
        
    else
        tv = tv_aux;
        tp = tp_aux;
        valley = v_aux;
        peak = p_aux;
    end
    
    % finds the closest value on xs to the instant of peak - this avoid
    % erros
    [~, id_v] = min(abs(xs-tv));
    tmin = xs(id_v);
    [~, id_p] = min(abs(xs-tp));
    tmax = xs(id_p);

    
    pmin = [tmin valley];
    pmax = [tmax peak];

    amp = pmax(2) - pmin(2);
    
else
    pmax = [0 0];
    pmin = [0 0];
    amp = 0;
    
end


