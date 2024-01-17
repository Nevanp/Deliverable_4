%% Receiver circuit
f_s = 1;
len = 21;
M = len - 1;
n_sps = 4*f_s;
span = M/n_sps;
beta_rx = 0.25;
fc = 1/(2*n_sps);
%% Transmitter circuit
fs = 0.2;

beta_tx = fs/fc-1;
a = 0;
while (a < 40)
hsrrc_tx = rcosdesign(0, span, n_sps);
b = abs(freqz(hrrc_tx));

end
hsrrc_rx = rcosdesign(beta_rx, span, n_sps);



