# SDR_Matlab_OFDM_802.11a

This example is based on IEEE 802.11a OFDM protocol.

Using Software Designed Radio to transmit OFDM signals at 5 GHz.

Transmitter and Receiver hardware : Zedboard + AD9361

![Hardware](https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/Hardware.jpg)

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
<img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/TX%20System%20Model.png" width="500">

> * Short Preamble
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/TX%20System%20Model_Short%20Preamble.png" width="800">

> * Long Preamble
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/TX%20System%20Model_Long%20Preamble.png" width="800">

> * Payload
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/TX%20System%20Model_Payload.png" width="600">

> * TX signal
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/TX%20System%20Model_Final.png" width="700">

## TX RX Hardware Parameters
| Center Frequency     | 5 GHz                |
|:--------------------:|:--------------------:|
| Baseband Sample Rate | 20 MHz               |
| Ts                   | 50 ns                |
| Samples Per Frame    | 3000                 |
| TX IP address        | 192.168.3.2          |
| RX IP address        | 192.168.30.3         |

## RX System Model
<img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/RX%20System%20Model.png" width="300">

> * "Delay and Correlate" algorithm for Packet Detection
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/RX%20System%20Model_Delay%20and%20Correlate%20algorithm.png" width="500">

> * Packet Detection (normal case)
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/RX%20System%20Model_Packet%20Detection.png" width="600">

> * Packet Detection (problem case & deselect the imperfect packet)
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/RX%20System%20Model_Packet%20Detection(problem).png" width="600">

> * Coarse CFO Estimation & Compensation
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/RX%20System%20Model_Coarse%20CFO%20Estimation.png" width="600">

> * Fine CFO Estimation & Compensation
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/RX%20System%20Model_Fine%20CFO%20Estimation.png" width="600">

> * Channel Estimation & Equalizer
> <img src="https://raw.githubusercontent.com/MeowLucian/SDR_Matlab_OFDM_802.11a/master/Picture/RX%20System%20Model_Channel%20Estimation%20%26%20Equalizer.png" width="600">
