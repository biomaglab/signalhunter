function [peak, start, pulse_end] = peak_detect(data,threshold)

% peak_detect determinates peak, start and duration indices for pulses in
% data according to threshold. 
% Inputs: data (raw signal); threshold (float);
% Outputs: peak, start and duration INDICES

pulse_position = find(data > threshold);
% pulse = zeros(pulse_position,pulse_position);
pulse = zeros(1);

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
        % (experimental values, test for other data)
        
        if aux(i) < 4000
            pulse(i,j) = data(pulse_position(k));
            pulse_indice(i,j) = k;
            % keep adding a new point to actual pulse group
            i = i + 1;
        else
            % create a new pulse group j
            j = j + 1;
            i = 1;
            pulse(i,j) = data(pulse_position(k));
            pulse_indice(i,j) = k;
            i = i + 1;
        end
    end
    
    clear aux j i 
    
    for j = 1:length(pulse(1,:))
        
        % calculates local maxima and process for high-frequency TMS noise
        % ignore
        [~, aux] = max(pulse(:,j));
        
        % smooth signal around max value and find closest real value
        smooth_amp = smooth(data((pulse_position(pulse_indice(aux))-4):...
            (pulse_position(pulse_indice(aux))+4)));
        abs_aux = abs(data((pulse_position(pulse_indice(aux))-4):...
            (pulse_position(pulse_indice(aux))+4)) - max(smooth_amp));
        [~,min_aux] = min(abs_aux);
        
%         smooth_max = dsearchn(data((pulse_position(pulse_indice(aux))-4)...
%             :pulse_position((pulse_indice(aux)+4)))...
%             ,max(smooth_amp));
        smooth_max = (pulse_position(pulse_indice(aux))-4 + min_aux - 1);
        pmax(j) = data(smooth_max);
        peak(j) = smooth_max;
        
        % start and duration 
        
        
        amp_aux = data((peak(j)-300):(peak(j)+500));
        mean_bef = mean(data((peak(j)-300):(peak(j)-5)));
        sd_bef = std(data((peak(j)-300):(peak(j)-5)));
        mmax = mean_bef + 2*sd_bef;
        mmin = mean_bef - 2*sd_bef;
        
        cont_aux = 0;
        start_aux = 0;
        
         while (start_aux == 0)
            for u = 1:length(amp_aux)
           
            if (amp_aux(u) >= mmax)
                cont_aux = cont_aux + 1;
                if cont_aux >= 5
                    start_aux = u - 5;
                else
                end
            end
            end
         end
         
         cont_aux = 0;
         end_aux = 0;
         
         while (end_aux == 0)
            for u = length(amp_aux):1
           
            if (amp_aux(u) <= mmin)
                cont_aux = cont_aux + 1;
                if cont_aux >= 5
                    end_aux = u - 5;
                else
                end
            end
            end
         end
        
          
%         
%         amp_aux3 = diff(amp_aux2);
%         
%         [~, max_pos] = max(amp_aux3);
%         [~, min_pos] = min(amp_aux3);
%         
%         max_pos = max_pos - 300 - 1;
%         min_pos = min_pos - 300 + 1;
%         
%        peak(j) = max_pos;
%        pulse_end(j) = min_pos+1;
%        
%        diff_test = diff(data((pulse_position(aux)-4):(pulse_position(aux+4))));
%        [~,max_diff] = max(diff_test);
%        
       start(j) = start_aux;
       pulse_end(j) = end_aux;
    
    end
    
end
end

                
        
        
        
        
    