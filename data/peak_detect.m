function [peak, start, pulse_end] = peak_detect(data,threshold)
% peak_detect determinates peak, start and duration indices for pulses in
% data according to threshold, avoinding high-frequency contamination,
% which can be wrong considerally as the pulse peak.
%
%
% INPUTS:
% data (raw signal), threshold (float);
%
%
% OUTPUTS:
% peak, start and duration INDICES

pulse_position = find(data > threshold);

if isempty(pulse_position)==1
    peak = 0;
    start = 0;
    pulse_end = 0;
else
    
    % distinguish pulse_position groups if find(data > threshold)
    j = 1;
    i = 1;
    
    for k = 1:(length(pulse_position)-1)
        
        aux(i) = pulse_position(k+1) - pulse_position(k);
        
        % find pulse groups with distances higher than 4000 points
        if aux(i) < 4000
            
            % creates new pulse group
            pulse{i,j} = data(pulse_position(k));
            pulse_indice{i,j} = k;
            
            % keep adding a new point to actual pulse group until distance
            % is > 4000
            i = i + 1;
            
        else
            % distance higher than 4000. Create a new pulse group j
            
            j = j + 1;
            i = 1;
            pulse{i,j} = data(pulse_position(k));
            pulse_indice{i,j} = k;
            i = i + 1;
        end
    end
    
    clear aux j i
    
    siz = size(pulse);
    
    for j = 1:siz(2)
        
        % calculates local maxima and process for high-frequency TMS noise
        % ignoring
        
        [~, aux] = max(cell2mat(pulse(:,j)));
        
        smooth_amp = medfilt1(cell2mat(pulse(:,j)));
        abs_aux = abs(cell2mat(pulse(:,j))-max(smooth_amp));
        [~,min_aux] = min(abs_aux);
        smooth_max = (pulse_position(pulse_indice{min_aux,j}));
        pmax(j) = data(smooth_max);
        peak(j) = smooth_max;
        
        % start and duration. Amp_aux store data around the first detected
        % peak. Next steps will compare points before and after the peak to
        % check if it is a real-peak or just high-frequecy noise
        
        amp_aux = data((peak(j)-300):(peak(j)+500));
        mean_bef = mean(data((peak(j)-300):(peak(j)-5)));
        sd_bef = std(data((peak(j)-300):(peak(j)-5)));
        mmax = mean_bef + 2*sd_bef;
        mmin = mean_bef - 2*sd_bef;
        
        cont_aux = 0;
        start_aux = 0;
        u = 1;
        
        while (start_aux == 0)
            
            if u > length(amp_aux)
                cont_aux = 1000;
            else
                if (amp_aux(u) >= mmax)
                    cont_aux = cont_aux + 1;
                    if cont_aux == 5
                        start_aux = u - 5;
                        while (data((peak(j) - 300 + start_aux + 1)) > mmax)
                            start_aux = start_aux - 1;
                        end
                    end
                else
                    cont_aux = 0;
                end
            end
            u = u + 1;
        end
        
        % Same ideia for checking pulse_end
        cont_aux = 0;
        end_aux = 0;
        u = length(amp_aux);
        
        while (end_aux == 0)
            u = u - 1;
            if u < 1
                end_aux = 1000;
            else
            end
            
            if ((amp_aux(u) >= mmax) || (amp_aux(u) <= mmin))
                cont_aux = cont_aux + 1;
                if cont_aux >= 5
                    end_aux = u + 5;
                else
                end
            else
                cont_aux = 0;
            end
        end
        
        start(j) = (peak(j) - 300 + start_aux);
        pulse_end(j) = (peak(j) - 300 + end_aux);
        
    end
    
    
end
end