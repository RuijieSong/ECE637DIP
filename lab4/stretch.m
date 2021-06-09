function output = stretch(input, T1, T2)

[r,c] = size(input);
output = zeros(r,c);
input = double(input);

for i = 1:r
    for j = 1:c
        if input(i,j) > T2
            output(i,j) = 255;
        elseif (T1 <= input(i,j)) && (input(i,j) <= T2)
            output(i,j) = (input(i,j)-T1) / (T2-T1) * 254;
        end
    end
end

output = uint8(output);

end

