
% Clear memory and close existing figures
clear
close

% This line reads in a gray scale TIFF image. 
% The matrix img contains a 2-D array of 8-bit gray scale values.

[img] = imread('img04g.tif');

% This line sets the colormap, displays the image, and sets the
% axes so that pixels are square.
% "map" is the corresponding colormap used for the display. 
% A gray scale pixel value is treated as an index into the 
% current colormap so that the pixel at location (i,j)
% has the color [r,g,b] = map(img(i,j),:) .

map=gray(256);
colormap(gray(256));
image(img)
axis('image')

X = double(img)/255;

% Select an NxN region of the image and store it in the variable "z"

i=100;
j=100;

% N = 64;
% N = 128;
N = 256;
z = X(i:(N+i-1), j:(N+j-1));


% Compute the power spectrum for the NxN region
Z = (1/N^2)*abs(fft2(z)).^2;

% Use fftshift to move the zero frequencies to the center of the plot
Z = fftshift(Z);

% Compute the logarithm of the Power Spectrum.
Zabs = log( Z );


% Plot the result using a 3-D mesh plot and label the x and y axises properly. 

x = 2*pi*((0:(N-1)) - N/2)/N;
y = 2*pi*((0:(N-1)) - N/2)/N;
figure 
mesh(x,y,Zabs)
xlabel('\mu axis')
ylabel('\nu axis')



