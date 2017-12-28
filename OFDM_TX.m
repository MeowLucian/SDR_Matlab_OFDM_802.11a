close all;clear;clc;j=1i;
%% Parameter
N_FFT = 64;
%% Short_preamble
S_k = sqrt(13/6)*[0,0,1+j,0,0,0,-1-j,0,0,0,1+j,0,0,0,-1-j,0,0,0,-1-j,0,0,0,1+j,0,0,0,0,0,0,0,-1-j,0,0,0,-1-j,0,0,0,1+j,0,0,0,1+j,0,0,0,1+j,0,0,0,1+j,0,0]; % [1x53]
virtual_subcarrier = zeros(1,N_FFT-length(S_k)); % [1x11]
Short_preamble_slot_Frequency = [virtual_subcarrier(1:6),S_k,virtual_subcarrier(7:11)]; % [1x64]
Short_preamble_slot_Time = ifft(ifftshift(Short_preamble_slot_Frequency)); % [1x64]
Short_preamble = repmat(Short_preamble_slot_Time(1:16),1,10); % [1x160]
%% Long_preamble
L_k = [1,1,-1,-1,1,1,-1,1,-1,1,1,1,1,1,1,-1,-1,1,1,-1,1,-1,1,1,1,1,0,1,-1,-1,1,1,-1,1,-1,1,-1,-1,-1,-1,-1,1,1,-1,-1,1,-1,1,-1,1,1,1,1]; % [1x53]
virtual_subcarrier = zeros(1,N_FFT-length(L_k)); % [1x11]
Long_preamble_slot_Frequency = [virtual_subcarrier(1:6),L_k,virtual_subcarrier(7:11)]; % [1x64]
Long_preamble_slot_Time = ifft(ifftshift(Long_preamble_slot_Frequency)); % [1x64]
Long_preamble = [Long_preamble_slot_Time(33:64),Long_preamble_slot_Time,Long_preamble_slot_Time]; % [1x160]
%% Payload
M = 4; % QPSK
load('data_Payload_1');
load('data_Payload_2');
data1_slot_Frequency = pskmod(data_Payload_1,M,pi/4);  % [1x48]
data2_slot_Frequency = pskmod(data_Payload_2,M,pi/4);  % [1x48]
pilot = [1,1,1,-1]; % [1x4]
virtual_subcarrier = zeros(1,11); % [1x11]
data11_slot_Frequency = [virtual_subcarrier(1:6),data1_slot_Frequency(1:5),pilot(1),data1_slot_Frequency(6:18),pilot(2),data1_slot_Frequency(19:24),0,data1_slot_Frequency(25:30),pilot(3),data1_slot_Frequency(31:43),pilot(4),data1_slot_Frequency(44:48),virtual_subcarrier(7:11)]; % [1x64]
data22_slot_Frequency = [virtual_subcarrier(1:6),data2_slot_Frequency(1:5),pilot(1),data2_slot_Frequency(6:18),pilot(2),data2_slot_Frequency(19:24),0,data2_slot_Frequency(25:30),pilot(3),data2_slot_Frequency(31:43),pilot(4),data2_slot_Frequency(44:48),virtual_subcarrier(7:11)]; % [1x64]
data1_slot_Time = ifft(ifftshift(data11_slot_Frequency)); % [1x64]
data2_slot_Time = ifft(ifftshift(data22_slot_Frequency)); % [1x64]
data1_TX_payload = [data1_slot_Time(49:64),data1_slot_Time]; % [1x80]
data2_TX_payload = [data2_slot_Time(49:64),data2_slot_Time]; % [1x80]
%% Frame Combination
Frame = [Short_preamble,Long_preamble,data1_TX_payload,data2_TX_payload]; % [1x(160+160+80+80)]=[1x480]
%% Oversampling
OVR = 2;
Frame_OVR_sampling = oversamp(Frame,length(Frame),OVR); % [1x960]
%% Root Raised Cosine filter
rolloff = 0.5;
L = 6;
RRC = rcosdesign(rolloff,L,OVR,'sqrt');
%% TX
TX_signal = conv(Frame_OVR_sampling,RRC); % [1x972]
%% Plot
stem(real(TX_signal));
%% Save
% save TX_signal TX_signal