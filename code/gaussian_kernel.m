function f = gaussian_kernel(sigma)

function r = gaussian_kernel_function(x1, x2)
%     fprintf('Dimensions of x1: %d rows, %d columns\n', size(x1));
%     fprintf('Dimensions of x2: %d rows, %d columns\n', size(x2));
%     r1 = exp(-((norm(x1-x2)^2)/(2 * sigma^2)));
    r2 = exp(-(((x1-x2)' * (x1-x2))/(2 * sigma^2)));
%     abs(r1 - r2)
    r = r2;
end

f = @gaussian_kernel_function;

end
