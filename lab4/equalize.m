function Y = equalize(X)

L = 256;

IM = hist(X(:),[0:L-1]);

for i = 0:L-1
    Fx(i+1) = sum(IM(1:(i+1))) / sum(IM); % calculating Fx
end

plot(Fx)
xlabel('value of Xs')
ylabel('Ys')
title('plot of Fx(i)') 

Ymax = max(Fx);
Ymin = min(Fx);

Y = (L-1) * (Fx(X)-Ymin) / (Ymax-Ymin);
Y = uint8(Y);

end
