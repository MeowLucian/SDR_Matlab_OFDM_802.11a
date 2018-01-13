clear;close all;clc;j=1i;
Global_Parameters;
%% Button setting
figure('Name','RX','NumberTitle','off');
button = uicontrol; % Generate GUI button
set(button,'String','Stop !','Position',[1475 15 100 60]); % Add "Stop !" text
set(gcf,'Units','centimeters','position',[1 2 49 24]); % Set the postion of GUI
%% Hardware Parameters
rx_object = sdrrx('ZedBoard and FMCOMMS2/3/4',...
           'IPAddress','192.168.3.3',...
           'CenterFrequency',Parameters_struct.CenterFrequency,...
           'BasebandSampleRate', Parameters_struct.Bandwidth,...   % Bandwidth
           'ChannelMapping', 1,...
           'SamplesPerFrame', 3000);

Ready_Time = 0;
scale = 1024;
%% Main
state = 1; % status Start
Run_time_number = 1;
while(state == 1)
    try
    
    [data_rx_raw, dataLength, lostSample] = step(rx_object);
    if Run_time_number > Ready_Time
        
        % ----- RX Raw -----%
        data_rx_scaled = double(data_rx_raw)./scale; % [3000x1]
        RX = data_rx_scaled.'; % [1x3000]
        
        subplot(2,4,1),plot(RX,'.');title('RX-Raw');axis([-1.5 1.5 -1.5 1.5]);axis square;
        subplot(2,4,2),plot(real(RX));title('I');axis([1 3000 -1.5 1.5]);axis square;
        subplot(2,4,3),plot(imag(RX));title('Q');axis([1 3000 -1.5 1.5]);axis square;
        
        [Spectrum_waveform,Welch_Spectrum_frequency] = pwelch(RX,[],[],[],rx_object.BasebandSampleRate,'centered','power');
        subplot(2,4,4),plot(Welch_Spectrum_frequency,pow2db(Spectrum_waveform));
        title('Welch Power Spectral Density');axis([-rx_object.BasebandSampleRate/2 rx_object.BasebandSampleRate/2 -100 -10]);axis square;
        
        drawnow;
        
        % ----- Demodulation -----%
        [M_n,Threshold_graph,H_est_time,RX_Payload_1_no_Equalizer,RX_Payload_2_no_Equalizer,RX_Payload_1_no_pilot,RX_Payload_2_no_pilot,BER] = OFDM_RX(RX,Parameters_struct);
        subplot(2,4,5),plot(1:length(M_n),M_n,1:length(M_n),Threshold_graph);title('Packet Detection');axis([1,length(M_n),0,1.2]);axis square;
        subplot(2,4,6),plot(abs(H_est_time));title('Channel Estimation');axis([1 64 0 7]);axis square;

        subplot(2,4,7),plot([RX_Payload_1_no_Equalizer,RX_Payload_2_no_Equalizer],'*');
        title('Before Equalizer');axis([-8 8 -8 8]);axis square;
        
        subplot(2,4,8),plot([RX_Payload_1_no_pilot,RX_Payload_2_no_pilot],'*');
        title({'Demodulation';['BER = ',num2str(BER)]});axis([-1.5 1.5 -1.5 1.5]);axis square;
        
        set(gcf,'Units','centimeters','position',[1 2 49 24]); % GUI window size
        
        Run_time_number = Run_time_number+1;
    end % Start
    
    if Run_time_number <= Ready_Time  % Ready
        % disp('Ready');
    end
    Run_time_number = Run_time_number+1;
    
    % ----- Button Behavior -----%
    set(button,'Callback','setstate0_RX'); % Set the reaction of pushing button
    
    catch
        ErrorMessage = lasterr;
        fprintf('Error Message : \n');
        disp(ErrorMessage);
        fprintf(2,'Error occurred & Stop Hardware\n');
        
        % ----- Error Handling -----%
        % release(rx_object);
        % state=0;

    end % Error control
end % While

release(rx_object);
close all;
disp('Software Complete');