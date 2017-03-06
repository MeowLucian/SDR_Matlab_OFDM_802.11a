clear;close all;clc;j=1i;
%% Hardware Parameter
Mode='transmitRepeat'; % Select Mode

tx_object = sdrtx('ZedBoard and FMCOMMS2/3/4', ...
           'IPAddress',            '192.168.3.2', ...
           'CenterFrequency',      2.4e9, ...
           'BasebandSampleRate',   20e6, ...
           'ChannelMapping', 1);
%            'Gain',-10,...           
%          'EnableBurstMode',1,...

%% TX Load
load('TX_signal'); % [1x972]
TX_real=real(TX_signal)'; % [972x1]
TX_imag=imag(TX_signal)'; % [972x1]
TX=TX_real+TX_imag*j; % [972x1]
% transmitRepeat Mode
TTX=[TX;TX;TX;TX;TX]; % Transmit Data must be >= 4096
%% Main
switch Mode
    case 'step'
        while 1>0
           step(tx_object,TX);
        end
        release(tx_object);

    case 'transmitRepeat'
        transmitRepeat(tx_object, TTX);
end