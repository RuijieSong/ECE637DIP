function BetterSpecAnal(x)

% initialize the e 25 non-overlapping image windows of size 64 ¡Á 64
windows = zeros(64,64,25); 

% find the center of x
[r,c] = size(x);
r = r/2;
c = c/2;
N = 64;

% obtain the 64*64 windows
k = 1;
for i = linspace(-2,2,5)
    for j = linspace(-2,2,5)
        windows(:,:,k) = x(((r+i*N)-(N/2-1)):((r+i*N)+N/2),((c+j*N)-(N/2-1)):((c+j*N)+N/2));
        k = k + 1;
    end
end

% create the 2-D Hamming window
W=hamming(64)*hamming(64)';

% Multiply each 64 ¡Á 64 window by a 2-D separable Hamming window
for k = 1:1:25
    windows(:,:,k) = windows(:,:,k) .* W;
end

% Compute the power spectrum for the NxN region
windows = (1/N^2)*abs(fft2(windows)).^2;

% Use fftshift to move the zero frequencies to the center of the plot
windows = fftshift(windows);

% Average this power spectral density across the 25 windows
A_windows = mean(windows,3);

% Display a mesh plot of the log of the estimated power spectral density
psd = log( A_windows );
x = 2*pi*((0:(N-1)) - N/2)/N;
y = 2*pi*((0:(N-1)) - N/2)/N;
figure 
mesh(x,y,psd)
xlabel('\mu axis')
ylabel('\nu axis')

end

