function class = classify_point(x, D, kernel, K, alpha)

    % Number of examples in dataset
    n = size(D, 1);

    % Extract X
    X = D(:,1:end-1);
    
    % Map every X to R^(n+1)
    X = [X ones(n,1)];
    
    % Take y as last column of dataset
    y = D(:,end);
    
%     % Create a matrix from X using the kernel
%     K = zeros(n,n);
%     for i=1:n
%         x_i = X(i,:)';
%         for j=1:n
%             x_j = X(j,:)';
%             K(i,j) = kernel(x_i, x_j);
%         end
%     end
    
    kernel_sum = 0;
    for i=1:length(alpha)
        kernel_sum = kernel_sum + alpha(i) * y(i) * kernel(X(i,:)', [x 1]');
    end
    
    class = sign(kernel_sum);
end

