clear all
df = 1/10000; % frequency increment in cycles/sample
f = [0:df:0.5-df/2]; % cycles/sample; 0 to almost 1/2

hsrrc_rx = rcosdesign(0.12,32,4)/3.8144;
w = kaiser(113, 2);
hsrrc_tx = rcosdesign(0.08,28,4).*w';
hsrrc_tx = hsrrc_tx/1.5;
H_hat_tx = freqz(hsrrc_tx,1,2*pi*f);
h_d = conv(hsrrc_rx,hsrrc_tx);
figure(1)
stem(h_d);

err = 0;
    for i = 0:((length(h_d)-1)/4-1)
        err = err + (h_d(i*4+1))^2;
    end
    err = err-max(abs(h_d).^2);
    MER_cur = max(abs(h_d).^2)/err;
    MER_cur = 10*log10(MER_cur);

