function K = gaussian_kernel_matrix(X, sigma)
    inputs = size(X, 1)
    K = zeros(inputs, inputs)
    for i=1:inputs
        x_i = X(i, :)'
        for j=1:inputs
            x_j = X(j, :)'
            K(i, j) = gaussian_kernel(x_i, x_j, sigma)
        end
    end
end
