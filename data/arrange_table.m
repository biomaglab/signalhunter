
% -------------------------------------------------------------------------
% Signal Hunter - electrophysiological signal analysis  
% Copyright (C) 2013, 2013-2016  University of Sao Paulo
% 
% Homepage:  http://df.ffclrp.usp.br/biomaglab
% Contact:   biomaglab@gmail.com
% License:   GNU - GPL 3 (LICENSE.txt)
% 
% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or any later
% version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
% 
% The full GNU General Public License can be accessed at file LICENSE.txt
% or at <http://www.gnu.org/licenses/>.
% 
% -------------------------------------------------------------------------
% 
% Author: Victor Hugo Souza
% Date: 13.11.2016


function [data_arr, idlabel] = arrange_table(data)
%ARRANGE_TABLE Find signal peak to peak amplitude, instant and intensity of
%greatest intensity peak and valley
% 
% INPUT:
% 
% data: {m, n}(end,q,r) cell array (m is number of frames, n is number of
% instants, end is the last row of values in potential q and muscle r
% 
% OUTPUT:
%
% data_arr: 1 x numel(data) row cell array of values in data
% tlabel: 1 x numel(data) row cell array with increasing strings label
%

n_frames = size(data, 1);
n_instants = size(data, 2);

data_arr = cell(n_frames, n_instants);

npots = zeros(n_frames, n_instants);
nmuscles = zeros(n_frames, n_instants);

for id_cond = 1:n_frames
    for ci = 1:n_instants
        npots(id_cond,ci) = size(data{id_cond,ci},2);
        nmuscles(id_cond,ci) = size(data{id_cond,ci},3);
    end
end

id_data = mean(mean(npots));
nmuscles_max = max(max(nmuscles));

for id_cond = 1:n_frames
    for ci = 1:n_instants 
        for ri = 1:nmuscles_max
            
            if id_data > 1
                
                for np = 1:npots(id_cond, ci)
                    
                    data_arr{id_cond,ci,ri,np} = data{id_cond,ci}(end,np,ri);
                    [row, col] = find(cellfun(@isempty, data_arr(:,:,ri,np)));
                    
                    for id = 1:size(row,1)
                        data_arr{row(id),col(id),ri,np} = 0;
                    end
                                            
                end
                
            elseif id_data == 1
                data_arr{id_cond,ci,ri} = data{id_cond,ci}(end,:,ri);
                
            end
        end
    end
end


ntot = numel(data_arr);

if id_data > 1
    data_arr = reshape(permute(data_arr, [4,3,2,1]), [ntot,1]);
    
elseif id_data == 1
    data_arr = reshape(permute(data_arr, [3,2,1]), [ntot,1]);
    
end

npots_max = max(max(npots));
idlabel = cell(npots_max,1);

for idi = 1:npots_max    
    idlabel{idi,1} = ['id' num2str(idi)];

end

idlabel = repmat(idlabel, [nmuscles_max*n_instants*n_frames, 1]);