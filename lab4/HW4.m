clear all

%% 1 Histogram of an Image

race = imread('./race.tif');
figure(1)
hist(race(:),[0:255]);
xlabel('pixel intensity')
ylabel('number of pixels')
title('Histogram of race')

kids = imread('./kids.tif');
figure(2)
hist(kids(:),[0:255]);
xlabel('pixel intensity')
ylabel('number of pixels')
title('Histogram of kids')

%% 2 Histogram Equalization

kids = imread('./kids.tif');

Y = equalize(kids);

figure
image(Y+1);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);

figure
hist(Y(:),[0:255]);
xlabel('pixel intensity')
ylabel('number of pixels')
title('Histogram of equalized image')

%% 3 Contrast Stretching

kids = imread('./kids.tif');

output = stretch(kids,75,150);

figure
image(output);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);

figure
hist(output(:),[0:255]);
xlabel('pixel intensity')
ylabel('number of pixels')
title('Histogram of stretched image')


%% 4.2

Y = Checkerboard(183);

figure
image(Y);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);
%}

%% 4.3

linear = imread('./linear.tif');
linear = double(linear);

gamma = 2.09
c_image = 255 .* (linear/255).^(1/gamma);

figure
image(c_image);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);


gamma15 = imread('./gamma15.tif');
gamma15 = double(gamma15);

gamma = 2.09
c_image = 255 .* (gamma15./255).^(1.5/gamma);

figure
image(c_image);
axis('image');
graymap = [0:255; 0:255; 0:255]'/255;
colormap(graymap);
