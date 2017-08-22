clear;close all;clc;j=1i;
%% Hardware Parameter
Mode='transmitRepeat'; % Select Mode

tx_object = sdrtx('ZedBoard and FMCOMMS2/3/4', ...
           'IPAddress',            '192.168.3.2', ...
           'CenterFrequency',      5e9, ...
           'BasebandSampleRate',   20e6, ...  % Bandwidth
           'Gain',                 0, ...
           'ChannelMapping',       1);
%          'EnableBurstMode',1,...

%% Button setting
figure('Name','TX','NumberTitle','off');
AuthorDisplay=uicontrol('Style', 'text', 'Position',[20,150,230,35],'String', 'Stop Transmission','FontSize',20,'HorizontalAlignment','left','BackgroundColor',[0.937 0.867 0.867]);
button = uicontrol; % Generate GUI button
set(button,'String','Stop !','Position',[80 50 100 60]); % Add "Stop !" text
set(gcf,'Units','centimeters','position',[3 3 7 6]); % Set the postion of GUI
%% TX Load
load('TX_signal'); % [1x972]
TX_real=real(TX_signal)'; % [972x1]
TX_imag=imag(TX_signal)'; % [972x1]
TX=TX_real+TX_imag*j; % [972x1]
% transmitRepeat Mode
TTX=repmat(TX,5,1); % Transmit Data must be >= 4096
state=1;
%% Main
switch Mode
    case 'step'
        while(state==1)
           step(tx_object,TTX);
           % ----- Button Behavior -----%
           set(button,'Callback','setstate0_TX'); % Set the reaction of pushing button
           drawnow;
        end
        release(tx_object);

    case 'transmitRepeat'
        transmitRepeat(tx_object, TTX);
        % ----- Button Behavior -----%
        set(button,'Callback','setstate0_TX'); % Set the reaction of pushing button
end