% This script performs simulations of a linear network for the STDMA case study

% Copyright 2020 Nils Morozs, University of York (nils.morozs@york.ac.uk)
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
% associated documentation files (the "Software"), to deal in the Software without restriction,
% including without limitation the rights to use, copy, modify, merge, publish, distribute,
% sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial
% portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
% NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
% OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
% CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

% This work was supported by the UK Engineering and Physical Sciences Research Council (EPSRC)
% through the USMART Project under Grant EP/P017975/1.

% Set the fixed system parameters
num_nodes = 11;
tx_power = 170; % around 10 dB SNR for the intended transmissions
intf_snr = 0; % 0 dB threshold to be detectable as an interferer
data_pkt_dur = 0.5; % 500 ms long packets

% Create many eralizations of the linear network and parse STDMA parameters about them
num_realizations = 1000;
slot_lengths = NaN(1, num_realizations);
frame_lengths = NaN(1, num_realizations);
intf_hop_dist = NaN(1, num_realizations);
for r = 1:num_realizations
    
    % Create a network topology
    [intf_map, delays, spreads] = init_topology(num_nodes, tx_power, intf_snr, r);
    
    % Derive an STDMA schedule for it
    [stdma_sched, slot_length] = derive_stdma_schedule(intf_map, delays, spreads, data_pkt_dur);
    
    % Store the metrics about this STDMA schedule
    slot_lengths(r) = slot_length;
    frame_lengths(r) = size(stdma_sched, 2);
    
end

% Save the results to file
save(['data/res-' num2str(tx_power) 'dB.mat']);

