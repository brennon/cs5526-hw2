function [alpha, K] = svm_dual(D, kernel, C, epsilon)
    
    % Number of training examples
    n = size(D, 1);

    % Extract X
    X = D(:,1:end-1);
    
    % Map every X to R^(n+1)
    X = [X ones(n,1)];
    
    % Take y as last column of dataset
    y = D(:,end);
    
    % Create a matrix from X using the kernel
    K = zeros(n,n);
    for i=1:n
        x_i = X(i,:)';
        for j=1:n
            x_j = X(j,:)';
            K(i,j) = kernel(x_i, x_j);
        end
    end
    
    eta = zeros(1, n);
    for k=1:n
        eta(k) = 1 / K(k, k);
    end
    
    alpha = zeros(n,1);
    
    while true
        alpha_last = alpha;
        
        for k=1:n
            lagrange_sum = (alpha .* y)' * K(:,k);
%             lagrange_sum = 0;
            
%             for i=1:n
%                 lagrange_sum = lagrange_sum + (alpha(i) * y(i) * K(i,k));
%             end
            
            alpha(k) = alpha(k) + eta(k) * (1 - y(k) * lagrange_sum);
            if alpha(k) < 0
                alpha(k) = 0;
            end
            if alpha(k) > C
                alpha(k) = C;
            end
        end
        
        alpha_next = alpha;
        if norm(alpha_next - alpha_last) <= epsilon
            break;
        end
    end
end