clear all
%{
%% 2 Plotting Color Matching Functions and Illuminants

load('data.mat')
%{
figure()
lambda = 400:10:700;
plot(lambda,[x;y;z])
legend('x_0(\lambda)','y_0(\lambda)','z_0(\lambda)')
%}
A_inv = [0.2430,0.8560,-0.0440;-0.3910,1.1650,0.0870;0.0100,-0.0080,0.5630];
% figure()
lambda = 400:10:700;
% plot(lambda,A_inv * [x;y;z])
% legend('l_0(\lambda)','m_0(\lambda)','s_0(\lambda)')

figure()
plot(lambda,[illum1;illum2])
legend('D65','fluorescent')
%}
%{
%% 3 Chromaticity Diagrams

load('data.mat')

figure()
plot(x./(x+y+z),y./(x+y+z))
hold on

CIE1931 = [0.73467, 0.26533, 0.0; 0.27376, 0.71741, 0.00883; 0.16658, 0.00886, 0.82456; 0.73467, 0.26533, 0.0];
plot(CIE1931(:,1),CIE1931(:,2),'r-')
text(CIE1931(:,1),CIE1931(:,2),'CIE 1931') 
hold on

Rec709RGB = [0.640, 0.330, 0.030; 0.300, 0.600, 0.100; 0.150, 0.060, 0.790; 0.640, 0.330, 0.030];
plot(Rec709RGB(:,1),Rec709RGB(:,2),'g-')
text(Rec709RGB(:,1),Rec709RGB(:,2),'Rec. 709 RGB') 
hold on

plot(0.3127,0.3290,'b*')
text(0.3127,0.3290, 'D65')
hold on

plot(0.3333,0.3333,'r*')
text(0.3333,0.3333, 'EE')
orient tall
hold off
%}
%{
%% 4 Rendering an Image from Illuminant, Reflectance, and Color Matching Functions

load('data.mat')
load('reflect.mat')
% calculating I
[rowR, colR, wl] = size(R);
I = zeros(rowR, colR, 31);
for i = 1:rowR
    for j = 1:colR
        for k = 1:wl
            I(i,j,k) = R(i,j,k) * illum1(k);    
            % I(i,j,k) = R(i,j,k) * illum2(k);  
        end
    end
end
% calculating XYZ
XYZ = zeros(rowR,colR,3);
for i = 1:rowR
    for j = 1:colR
        XYZ(i,j,:) = reshape(I(i,j,:),[1,wl]) * [x;y;z]';
    end
end
% compute M709_D65
Rec709RGB = [0.640, 0.330, 0.030; 0.300, 0.600, 0.100; 0.150, 0.060, 0.790]';
D65 = [0.3127;0.3290;0.3583];
wp = D65 / D65(2);
M709_D65 = Rec709RGB * diag(inv(Rec709RGB) * wp);
% XYZ to RGB
RGB = zeros(rowR,colR,3);
for i = 1:rowR
    for j = 1:colR
        RGB(i,j,:) = inv(M709_D65) * reshape(XYZ(i,j,:),[3,1]);
    end
end
% clip
RGB(RGB < 0) = 0;
RGB(RGB > 1) = 1;
% Gamma correction
RGB_gamma = (RGB.^(1/2.2));
% Display
RGB_gamma = uint8(255*RGB_gamma);
figure()
image((RGB_gamma))
imwrite(RGB_gamma,"4.tif")
%}

%% 5 Color Chromaticity Diagram

[X Y] = meshgrid(0:0.005:1);
Z = 1 - X - Y; % x+y+z = 1

Rec709RGB = [0.640, 0.330, 0.030; 0.300, 0.600, 0.100; 0.150, 0.060, 0.790]';
M = Rec709RGB; % since K = 1
XYZ(:,:,1) = X;
XYZ(:,:,2) = Y;
XYZ(:,:,3) = Z;
% transfer XYZ to RGB
[rowRGB,colRGB] = size(X);
RGB = zeros(rowRGB,colRGB,3);
for i = 1:rowRGB
    for j = 1:colRGB
        RGB(i,j,:) = inv(M) * reshape(XYZ(i,j,:),[3,1]);
    end
end
% clip
RGB(RGB < 0) = 1;
% gamma correction
RGB = uint8(255 * RGB.^(1/2.2));
% display color diagram
figure()
image([0:0.005:1],[0:0.005:1],RGB)
axis('xy')
xlabel('x axis')
ylabel('y axis')
hold on

load('data.mat')
plot(x./(x+y+z),y./(x+y+z))
