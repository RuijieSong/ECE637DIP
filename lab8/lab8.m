clear all
%{
%% 3.1
% 1
house = imread('house.tif');
[rowh,colh] = size(house);
T = 127; % threshold
binary = zeros(rowh,colh);
for i = 1:rowh
    for j = 1:colh
        if house(i,j) > T
            binary(i,j) = 255;
        else
            binary(i,j) = 0;
        end
    end
end

figure()
imshow(binary)

% 2
house = double(house);
square = (binary-house).^2;
RMSE = sqrt(1/(rowh*colh) * sum(square(:)));
% 3
fid = fidelity(house,binary);
%}
%{
%% 4.2
% 1
house = imread('house.tif');
house = double(house);
% 2
ls_version = 255*(house/255).^2.2;
% 3
I2 = [1,2;3,0];
I4 = [4*I2+1,4*I2+2;4*I2+3,4*I2];
I8 = [4*I4+1,4*I4+2;4*I4+3,4*I4];
% 4
T1 = 255 * (I2+0.5) / (2*2);
T2 = 255 * (I4+0.5) / (4*4);
T3 = 255 * (I8+0.5) / (8*8);

[rowh,colh] = size(house);
b1 = zeros(rowh,colh);
b2 = zeros(rowh,colh);
b3 = zeros(rowh,colh);
% 2x2
for i = 1:rowh
    for j = 1:colh
        if ls_version(i,j) > T1(mod(i-1,2)+1,mod(j-1,2)+1)
            b1(i,j) = 255;
        end
    end
end
% 4x4
for i = 1:rowh
    for j = 1:colh
        if ls_version(i,j) > T2(mod(i-1,4)+1,mod(j-1,4)+1)
            b2(i,j) = 255;
        end
    end
end
% 8x8
for i = 1:rowh
    for j = 1:colh
        if ls_version(i,j) > T3(mod(i-1,8)+1,mod(j-1,8)+1)
            b3(i,j) = 255;
        end
    end
end
% 5
figure()
imwrite(b1,'421.tiff')
imshow(b1)
truesize

figure()
imwrite(b2,'422.tiff')
imshow(b2)
truesize

figure()
imwrite(b3,'423.tiff')
imshow(b3)
truesize
% 6
square1 = (b1-house).^2;
RMSE1 = sqrt(1/(rowh*colh) * sum(square1(:)));
fid1 = fidelity(house,b1);

square2 = (b2-house).^2;
RMSE2 = sqrt(1/(rowh*colh) * sum(square2(:)));
fid2 = fidelity(house,b2);

square3 = (b3-house).^2;
RMSE3 = sqrt(1/(rowh*colh) * sum(square3(:)));
fid3 = fidelity(house,b3);
%}

%% 5.1
% 1
house = imread('house.tif');
house = double(house);
ls_version = 255*(house/255).^2.2;
[rowh,colh] = size(house);
output = zeros(rowh,colh);
% 2,3,4,5
T = 127; % threshold
for i = 1:rowh-1
    for j = 2:colh-1
        if ls_version(i,j) > T
            output(i,j) = 255;
            error = ls_version(i,j) - output(i,j);
        else
            output(i,j) = 0;
            error = ls_version(i,j) - output(i,j);
        end
        ls_version(i,j+1) = 7/16*error + ls_version(i,j+1);
        ls_version(i+1,j-1) = 3/16*error + ls_version(i+1,j-1);
        ls_version(i+1,j) = 5/16*error + ls_version(i+1,j);
        ls_version(i+1,j+1) = 1/16*error + ls_version(i+1,j+1);
    end
end
figure()
imshow(output)
truesize
imwrite(output,'5.tiff')

square = (output-house).^2;
RMSE = sqrt(1/(rowh*colh) * sum(square(:)));
fid = fidelity(house,output);