clear all
df = 1/10000; % frequency increment in cycles/sample
f = [0:df:0.5-df/2]; % cycles/sample; 0 to almost 1/2

hsrrc_rx = rcosdesign(0.12,32,4)/3.5;
w = kaiser(113, 2);
hsrrc_tx = rcosdesign(0.08,28,4).*w';
hsrrc_tx = hsrrc_tx/1.15;

mer = 0;
mmax = 100;
for M = 8
 for bet = 3.12
    n = 0:M;

lpf = 2.*1/4.*sinc(2.*1/4.*(n-M/2));
w2 = kaiser(M+1,bet);
upconv = lpf.*w2';
h1 = conv(upsample(hsrrc_tx,2)/2,upconv);
figure(1)
freqz(h1)
h2 = conv(upsample(h1,2)/2,upconv);
figure(2)
freqz(h2)
h3 = conv(h2/2,upconv);
figure(3)
freqz(h3)
h4 = conv(downsample(h3,2)/2,upconv);
figure(4)
freqz(h4)
h_d = conv(downsample(h4,2),hsrrc_rx);
figure(5)
stem(h_d);

err = 0;
    for i = ceil((length(h_d)-1)/2+1):4:((length(h_d)))
        err = err + (h_d(i))^2;
    end
    err = err-max(abs(h_d).^2);
    MER_cur = max(abs(h_d).^2)/(2*err);
    MER_cur = 10*log10(MER_cur);
    if MER_cur > 40
    if M < mmax
        mer = MER_cur;
        mmax = M;
        bet_use = bet;
    end
    end
 end
end
err = 0;
for i = 3:4:length(h_d)
    err = err + (h_d(i))^2;
end
err = err-max(abs(h_d).^2);
MER_cur = max(abs(h_d).^2)/(err);
MER_cur = 10*log10(MER_cur);

