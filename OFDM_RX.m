function [Threshold,M_n,Threshold_graph,H_est_time,RX_Payload_1_no_Equalizer,RX_Payload_2_no_Equalizer,RX_Payload_1_no_pilot,RX_Payload_2_no_pilot,BER]=OFDM_RX(RX)
j=1i;
%% Debug mode
% clear;close all;clc;
% load('RX2');
%% Root Raised Cosine filter
rolloff=0.5;
L=6;
OVR=2;
RRC=rcosdesign(rolloff,L,OVR,'sqrt'); % [1x13]
RX_signal=conv(RX,RRC); % [1x3012]
%% Packet Detection
D=16;
C_n=zeros(1,length(RX)-D+1-32);
P_n=zeros(1,length(RX)-D+1-32);
C_k=zeros(1,32);
P_k=zeros(1,32);

for n=1:length(RX)-D+1-32
    for k=1:32
        C_k(k)=RX(n+k-1)*complex(RX(n+k-1+D));
        P_k(k)=abs(RX(n+k-1+D))^2;
    end
    C_n(n)=sum(C_k);
    P_n(n)=sum(P_k);
end
M_n=(abs(C_n).^2)./(P_n.^2);
%% Packet_select
Threshold=0.75;
loc=find(M_n>Threshold);
temp_1=[loc,0];
temp_2=[0,loc];
temp_3=temp_1-temp_2;
Packet_Front=find(temp_3>300);
Packet_Front_idx=loc(Packet_Front);
Length_over_Threshold=230;

for x=1:length(Packet_Front_idx)-1
    if M_n(Packet_Front_idx(x)+Length_over_Threshold)>Threshold;
        idx=Packet_Front_idx(x)+L+1;
    end % if Loop
end % for Loop
Threshold_graph=Threshold*ones(1,length(M_n));
Threshold_graph(idx-L-1)=1.15;
%% Downsampling
Frame_DWN_sampling=RX_signal(idx:OVR:OVR*480+idx-1); % [1x480] Frame length
%% Coarse CFO Estimation
Ts=50e-9;
z=Frame_DWN_sampling(D*5+1:D*6)*Frame_DWN_sampling(D*6+1:D*7)'; % [1x16]*[16x1]
f_Coarse_est=(-1/(2*pi*D*Ts))*angle(z);
Frame_After_Coarse=Frame_DWN_sampling.*exp(-j*2*pi*f_Coarse_est*Ts*(0:480-1)); % [1x480]
%% Fine CFO Estimation
z=Frame_After_Coarse(D*12+1:D*16)*Frame_After_Coarse(D*16+1:D*20)'; % [1x64]*[64x1]=[1x1]
f_Fine_est=(-1/(2*pi*64*Ts))*angle(z);
Frame_After_Fine=Frame_After_Coarse.*exp(-j*2*pi*f_Fine_est*Ts*(0:480-1)); % [1x160]
%% Symbol Timing Estimation
%% Channel Estimation
Long_preamble_1=Frame_After_Fine(D*12+1:D*16); % [1x64]
Long_preamble_2=Frame_After_Fine(D*16+1:D*20); % [1x64]
Long_preamble_1_After_FFT=fftshift(fft(Long_preamble_1)); % [1x64]
Long_preamble_2_After_FFT=fftshift(fft(Long_preamble_2)); % [1x64]
load('Long_preamble_slot_Frequency'); % [1x64]
H_est=0.5*(Long_preamble_1_After_FFT+Long_preamble_2_After_FFT).*complex(Long_preamble_slot_Frequency); % [1x64]
H_est_time=ifft(ifftshift(H_est)); % [1x64]
%% One tap Equalizer
RX_Payload_1_time=Frame_After_Fine(320+1:400); % [1x80]
RX_Payload_1_no_CP=RX_Payload_1_time(17:end); % [1x64]
RX_Payload_1_Frequency=fftshift(fft(RX_Payload_1_no_CP)); % [1x64]
RX_Payload_1_Frequency_Equalizer=RX_Payload_1_Frequency./H_est; % [1x64]

RX_Payload_2_time=Frame_After_Fine(400+1:480); % [1x80]
RX_Payload_2_no_CP=RX_Payload_2_time(17:end); % [1x64]
RX_Payload_2_Frequency=fftshift(fft(RX_Payload_2_no_CP)); % [1x64]
RX_Payload_2_Frequency_Equalizer=RX_Payload_2_Frequency./H_est; % [1x64]
%% De-Mapping
RX_Payload_1_no_Equalizer=[RX_Payload_1_Frequency(7:11),RX_Payload_1_Frequency(13:25),RX_Payload_1_Frequency(27:32),RX_Payload_1_Frequency(34:39),RX_Payload_1_Frequency(41:53),RX_Payload_1_Frequency(55:59)]; % [1x48]
RX_Payload_1_no_pilot=[RX_Payload_1_Frequency_Equalizer(7:11),RX_Payload_1_Frequency_Equalizer(13:25),RX_Payload_1_Frequency_Equalizer(27:32),RX_Payload_1_Frequency_Equalizer(34:39),RX_Payload_1_Frequency_Equalizer(41:53),RX_Payload_1_Frequency_Equalizer(55:59)]; % [1x48]
RX_Payload_1_Final=pskdemod(RX_Payload_1_no_pilot,4,pi/4); % [1x48]

RX_Payload_2_no_Equalizer=[RX_Payload_2_Frequency(7:11),RX_Payload_2_Frequency(13:25),RX_Payload_2_Frequency(27:32),RX_Payload_2_Frequency(34:39),RX_Payload_2_Frequency(41:53),RX_Payload_2_Frequency(55:59)]; % [1x48]
RX_Payload_2_no_pilot=[RX_Payload_2_Frequency_Equalizer(7:11),RX_Payload_2_Frequency_Equalizer(13:25),RX_Payload_2_Frequency_Equalizer(27:32),RX_Payload_2_Frequency_Equalizer(34:39),RX_Payload_2_Frequency_Equalizer(41:53),RX_Payload_2_Frequency_Equalizer(55:59)]; % [1x48]
RX_Payload_2_Final=pskdemod(RX_Payload_2_no_pilot,4,pi/4); % [1x48]
%% BER calculation
load('data_Payload_1'); % [1x48]
load('data_Payload_2'); % [1x48]
Error_bits=sum([abs(sign(data_Payload_1-RX_Payload_1_Final)),abs(sign(data_Payload_2-RX_Payload_2_Final))]);
BER=Error_bits/(length(data_Payload_1)+length(data_Payload_2));
%% Plot
% subplot(2,4,1),plot(RX,'.');title('RX-Raw');axis([-1.5 1.5 -1.5 1.5]);axis square;
% subplot(2,4,2),plot(1:length(M_n),M_n,1:length(M_n),Threshold_graph);title('Packet Detection');axis([1,length(M_n),0,1.2]);axis square;
% subplot(2,4,3),plot(abs(H_est_time));title('Channel Estimation');axis([1 64 0 7]);axis square;
% 
% subplot(2,4,4),plot(RX_Payload_1_no_Equalizer,'*');
% hold on
% subplot(2,4,4),plot(RX_Payload_2_no_Equalizer,'*');title('Before Equalizer');axis([-8 8 -8 8]);axis square;
% hold off
% 
% subplot(2,4,5),plot(RX_Payload_1_no_pilot,'*');
% hold on
% subplot(2,4,5),plot(RX_Payload_2_no_pilot,'*');title({'Demodulation';['BER = ',num2str(BER)]});axis([-1.5 1.5 -1.5 1.5]);axis square;
% hold off
% set(gcf,'Units','centimeters','position',[1 2 49 24]);
end