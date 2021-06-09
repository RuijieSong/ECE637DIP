function fid=fidelity(f,b)
% a    
f = 255*(f/255).^2.2;
b = 255*(b/255).^2.2;

h = zeros(7);
theta_sq = 2;
for i = -3:3
    for j = -3:3
        h(i+4,j+4) = exp(-(i^2+j^2)/(2*theta_sq));
    end
end
h = h/sum(h(:));
f = imfilter(f,h);
b = imfilter(b,h);
% c
f = 255*(f/255).^(1/3);
b = 255*(b/255).^(1/3);

[rowf,colf] = size(f);
square = (f-b).^2;
fid = sqrt(1/(rowf*colf) * sum(square(:)));
end