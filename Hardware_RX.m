clear;close all;clc;j=1i;
%% Button setting
button = uicontrol; % 產生按鈕
set(button,'String','Stop！','Position',[1300 20 100 60]); % 加入文字「Stop！」
%% Parameter
rx_object = sdrrx('ZedBoard and FMCOMMS2/3/4',...
           'IPAddress','192.168.3.3',...
           'CenterFrequency',5e9,...
           'BasebandSampleRate', 20e6,...
           'ChannelMapping', 1,...
           'SamplesPerFrame', 3000);

Ready_Time=200;
scale=1024;
%% Main
state=1; % 開始狀態
Run_time_number=1;
while(state==1)
    try
    
    tic
    [data_rx_raw, dataLength, lostSample] = step(rx_object);
    if Run_time_number>Ready_Time
        
        % ----- RX Raw -----%
        data_rx=double(data_rx_raw)./scale; % [3000x1]
        RX_real=real(data_rx)';
        RX_imag=imag(data_rx)';
        RX=RX_real+RX_imag*j; % [1x3000]
        drawnow;
        subplot(2,4,1),plot(RX,'.');title('RX-Raw');axis([-1.5 1.5 -1.5 1.5]);axis square;
        
        % ----- Demodulation -----%
        [Threshold,M_n,Threshold_graph,H_est_time,RX_Payload_1_no_Equalizer,RX_Payload_2_no_Equalizer,RX_Payload_1_no_pilot,RX_Payload_2_no_pilot,BER]=OFDM_RX(RX);
        subplot(2,4,1),plot(RX,'.');title('RX-Raw');axis([-1.5 1.5 -1.5 1.5]);axis square;
        subplot(2,4,2),plot(1:length(M_n),M_n,1:length(M_n),Threshold_graph);title('Packet Detection');axis([1,length(M_n),0,1.2]);axis square;
        subplot(2,4,3),plot(abs(H_est_time));title('Channel Estimation');axis([1 64 0 7]);axis square;

        subplot(2,4,4),plot(RX_Payload_1_no_Equalizer,'*');
        hold on
        subplot(2,4,4),plot(RX_Payload_2_no_Equalizer,'*');title('Before Equalizer');axis([-8 8 -8 8]);axis square;
        hold off

        subplot(2,4,5),plot(RX_Payload_1_no_pilot,'*');
        hold on
        subplot(2,4,5),plot(RX_Payload_2_no_pilot,'*');title({'Demodulation';['BER = ',num2str(BER)]});axis([-1.5 1.5 -1.5 1.5]);axis square;
        hold off
        set(gcf,'Units','centimeters','position',[1 2 49 24]);
        
        Run_time_number=Run_time_number+1;
    end % Start
    
    if Run_time_number<=Ready_Time  % Ready
%        disp('Ready');
    end
    Run_time_number=Run_time_number+1;
    
    % ----- Button Behavior -----%
    set(button,'Callback','setstate0'); % 設定按鈕的反應指令
    set(gcf,'Units','centimeters','position',[1 2 49 24]);
    
    catch
        ErrorMessage=lasterr;
        fprintf('Error Message : \n');
        disp(ErrorMessage);
        fprintf(2,'Error occurred & Stop Hardware\n');
%         release(rx_object);
%         state=0;
    end % Error control
end % While

release(rx_object);
close all;
disp('Software Complete');