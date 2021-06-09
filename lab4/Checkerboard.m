function Y = Checkerboard(x)

grey_stripe = zeros(16,256);

grey_stripe(:,:) = x;
cb_pattern = [255,255,0,0;255,255,0,0;0,0,255,255;0,0,255,255];
checkerboard = repmat(cb_pattern, 4, 64);
temp = [checkerboard;grey_stripe];
Y = repmat(temp,8, 1);

end

