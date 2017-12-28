function [out] = oversamp(indata, nsymb, sample) 
out = zeros(1,nsymb*sample);
out(1:sample:1+sample*(nsymb-1)) = indata;