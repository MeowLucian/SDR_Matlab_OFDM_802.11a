global j CenterFrequency Bandwidth Ts
%% Parameters
j=1i;
CenterFrequency=5e9;
Bandwidth=20e6; % 20 MHz
Ts=1/Bandwidth; % 50 ns
%% Load Given data
load('Long_preamble_slot_Frequency'); % [1x64]
load('data_Payload_1'); % [1x48]
load('data_Payload_2'); % [1x48]