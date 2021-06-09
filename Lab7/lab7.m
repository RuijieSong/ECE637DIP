clear all
% Read image
% X = imread('./images/img14bl.tif');
% X = imread('./images/img14gn.tif');
X = imread('./images/img14sp.tif');
Y = imread('./images/img14g.tif');

[RowX, ColX] = size(X);
[RowY, ColY] = size(Y);
NuminRow = floor(RowX/20);
NuminCol = floor(ColX/20);
N = NuminRow*NuminCol;

z = zeros(N,49);
y = zeros(N,1);
for i = 1:NuminRow
    for j = 1:NuminCol
        z((i-1)*NuminRow+j,:) = reshape(X(i*20-3:i*20+3,j*20-3:j*20+3),[1,49]);
        y((i-1)*NuminRow+j) = Y(i*20,j*20);
    end
end

Rzz = z' * z / N;
rzy = z' * y / N;
theta = reshape(inv(Rzz) * rzy,[7,7]);

figure()
imshow(imfilter(X,theta))
