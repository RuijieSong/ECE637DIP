clear all
%{
%% 3 FIR Low Pass Filter
u = linspace(-pi,pi);
v = linspace(-pi,pi);
H = zeros(100,100);
for a = 1:100
    for b = 1:100
        H(a,b) = 1/81 * exp(1i*v(b)*4) .* (1-(exp(-1i*v(b))).^9)./(1-exp(-1i*v(b))) .* ...
                 exp(1i*u(a)*4) .* (1-(exp(-1i*u(a))).^9)./(1-exp(-1i*u(a)));
    end
end
H = abs(H);

figure(1)
surf(u,v,H)
xlabel('u')
ylabel('v')
zlabel('H')
title('The magnitude of the frequency response of H')

%% 4 FIR Sharpening Filter
u = linspace(-pi,pi);
v = linspace(-pi,pi);
Rho = 1.5;
H = zeros(100,100);
for a = 1:100
    for b = 1:100
        H(a,b) = 1/25 * exp(1i*v(b)*2) .* (1-(exp(-1i*v(b))).^5)./(1-exp(-1i*v(b))) .* ...
                 exp(1i*u(a)*2) .* (1-(exp(-1i*u(a))).^5)./(1-exp(-1i*u(a)));
    end
end
G = 1 + Rho*(1-H);
H = abs(H);
G = abs(G);

figure(2)
surf(u,v,H)
xlabel('u')
ylabel('v')
zlabel('H')
title('The magnitude of the frequency response of H')

figure(3)
surf(u,v,G)
xlabel('u')
ylabel('v')
zlabel('G')
title('The magnitude of the frequency response of G')
%}
%% 5 IIR Filter
u = linspace(-pi,pi);
v = linspace(-pi,pi);
H = zeros(100,100);
for a = 1:100
    for b = 1:100
        H(a,b) = 0.01/(1+0.81*exp(-1i*v(b))*exp(-1i*u(a))-(0.9*exp(-1i*u(a))+0.9*exp(-1i*v(b))));
    end
end
H = abs(H);

figure(4)
surf(u,v,H)
xlabel('u')
ylabel('v')
zlabel('H')
title('The magnitude of the frequency response of H')

x = zeros(256,256);
y = zeros(256,256);
x(127,127) = 1;
for m = 1:1:256
    for n = 1:1:256
        y(m,n) = 0.01*x(m,n);
        if m > 1
            y(m,n) = y(m,n) + 0.9*y(m-1,n);
        end
        if n > 1
            y(m,n) = y(m,n) + 0.9*y(m,n-1);
        end
        if m > 1 && n > 1
            y(m,n) = y(m,n) - 0.81*y(m-1,n-1);
        end
    end
end

for m = 1:1:256
    for n = 1:1:256
        if y(m,n) < 0
            y(m,n) = 0;
        end
        if y(m,n) > 255
            y(m,n) = 255;
        end
    end
end

imwrite(uint8(255*100*y),'h_out.tif')