clear;close all;clc;j=1i;
Global_Parameters;
%% Hardware Parameters
Mode='transmitRepeat'; % Select Mode
tx_object = sdrtx('ZedBoard and FMCOMMS2/3/4', ...
           'IPAddress',            '192.168.3.2', ...
           'CenterFrequency',      Parameters_struct.CenterFrequency, ...
           'BasebandSampleRate',   Parameters_struct.Bandwidth, ...  % Bandwidth
           'Gain',                 -10, ...
           'ChannelMapping',       1);
%          'EnableBurstMode',1,...

%% Button Setting
figure('Name','TX','NumberTitle','off');
TransmittingDisplay = uicontrol('Style', 'text', 'Position',[55,150,155,35],'String', 'Transmitting','FontSize',20,'HorizontalAlignment','left','BackgroundColor',[0.937 0.867 0.867]);
button = uicontrol; % Generate GUI button
set(button,'String','Stop !','Position',[80 50 100 60]); % Add "Stop !" text
set(gcf,'Units','centimeters','position',[3 3 7 6]); % Set the postion of GUI
%% TX Load
load('TX_signal'); % [1x972]
% transmitRepeat Mode
TX_Hardware = repmat(TX_signal.',5,1); % Transmit Data must be >= 4096 % [4860x1]
state = 1;
%% Main
switch Mode
    case 'step'
        while(state == 1)
           step(tx_object,TX_Hardware);
           % ----- Button Behavior -----%
           set(button,'Callback','setstate0_TX'); % Set the reaction of pushing button
           drawnow;
        end
        release(tx_object);

    case 'transmitRepeat'
        transmitRepeat(tx_object,TX_Hardware);
        % ----- Button Behavior -----%
        set(button,'Callback','setstate0_TX'); % Set the reaction of pushing button
end