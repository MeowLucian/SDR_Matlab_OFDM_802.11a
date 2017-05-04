# SDR_Matlab_OFDM_802.11a

This example is based on IEEE 802.11a OFDM protocol.

Using Software Designed Radio to transmit OFDM signals at 5 GHz.

Transmitter and Receiver hardware : Zedboard + AD9361

# Code Structure :

## Hardware_TX.m
> TX_signal.mat

> OFDM_TX.m
* data_Payload_1.mat
* data_Payload_2.mat
* oversamp.m

## Hardware_RX.m
> OFDM_RX.m
* Long_preamble_slot_Frequency.mat
* setstate0.m

## RX_test
* RX.mat
* RX2.mat

# Program GUI :

![Program GUI](https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/GUI.png)
Video : https://www.youtube.com/watch?v=RAbS05toM0M
![Program GUI gif](https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/GUI_gif.gif)

# System Model :

## TX System Model
<img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/TX%20System%20Model_01.png" width="500">

> * Short Preamble
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/TX%20System%20Model_02.png" width="800">

> * Long Preamble
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/TX%20System%20Model_03.png" width="800">

> * Payload
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/TX%20System%20Model_04.png" width="600">

> * TX signal
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/TX%20System%20Model_05.png" width="700">
