clear all



%% 1 Power Spectral Density of an Image
clear all

[img] = imread('img04g.tif');

map=gray(256);
colormap(gray(256));
image(img)
axis('image')

X = double(img)/255;

BetterSpecAnal(X);



%% 2 Power Spectral Density of a 2-D AR Process
x = rand(512,512) - 0.5;
x_scaled=255*(x+0.5);
figure(1)
colormap(gray(256));
image(uint8(x_scaled))

x = padarray(x,[1 1]);
y = zeros(514,514);
for i = 2:513
    for j = 2:513
        y(i,j) = 3*x(i,j) + 0.99*y(i-1,j) + 0.99*y(i,j-1) - 0.9801*y(i-1,j-1);
    end
end
y = y(2:513,2:513);
y127 = y+127;
figure(2)
colormap(gray(256));
image(uint8(y127))

S = zeros(100,100);
K = 1; L = 1;
for u = linspace(-pi,pi,100)
    for v = linspace(-pi,pi,100)
        S(K,L) = 1/12 * (abs(3/(1-0.99*exp(-sqrt(-1)*u)-0.99*exp(-sqrt(-1)*v)+0.9801*exp(-sqrt(-1)*u)*exp(-sqrt(-1)*v))))^2;
        L = L+1;
    end
    L = 1;
    K = K+1;
end
S = log( S );
figure(3) 
mesh(linspace(-pi,pi,100),linspace(-pi,pi,100),S)
xlabel('\mu axis')
ylabel('\nu axis')


%%  Use BetterSpecAnal(y), your Matlab function from the previous exercise, to estimate the power spectral density of y. Plot the estimated power spectral density and export the result.
BetterSpecAnal(y);
        