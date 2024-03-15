clear all
df = 1/10000; % frequency increment in cycles/sample
f = [0:df:0.5-df/2]; % cycles/sample; 0 to almost 1/2

hsrrc_rx = rcosdesign(0.12,32,4)/3.8144;
w = kaiser(113, 2);
hsrrc_tx = rcosdesign(0.08,28,4).*w';
hsrrc_tx = hsrrc_tx/1.5;

mer = 0;
mmax = 100;
for M = 2
 for bet = 6.6
    n = 0:M;

lpf = 2.*1/4.*sinc(2.*1/4.*(n-M/2));
w2 = kaiser(M+1,bet);
upconv = lpf.*w2';
h1 = conv(hsrrc_tx,upconv);
h2 = conv(upsample(h1,2),upconv);
h3 = conv(h2,upconv);
h4 = conv(downsample(h3,2),upconv);
h_d = conv(h4,hsrrc_rx);
figure(1)
stem(h_d);

err = 0;
    for i = ((length(h_d)-1)/2+1):4:((length(h_d)))
        err = err + (h_d(i))^2;
    end
    err = err-max(abs(h_d).^2);
    MER_cur = max(abs(h_d).^2)/(2*err);
    MER_cur = 10*log10(MER_cur)
    if MER_cur > 39
    if M < mmax
        mer = MER_cur;
        mmax = M;
        bet_use = bet;
    end
    end
 end
end
