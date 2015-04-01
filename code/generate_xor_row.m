function x = generate_xor_row(d)
    x = zeros(1,d);
    one_index = (floor(rand() * d)) + 1;
    x(one_index) = 1;
    x = [x 1];
end