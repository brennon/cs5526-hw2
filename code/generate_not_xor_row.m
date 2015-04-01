function x = generate_not_xor_row(d)
    number_of_ones_choices = [0 2:d];
    number_of_ones_index = (floor(rand() * length(number_of_ones_choices))) + 1;
    number_of_ones = number_of_ones_choices(number_of_ones_index);
    ones_part = ones(1, number_of_ones);
    zeros_part = zeros(1, d - number_of_ones);
    x = [ones_part zeros_part];
    x = x(randperm(length(x)));
    x = [x -1];
end
