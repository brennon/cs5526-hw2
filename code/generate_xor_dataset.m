function [X, y] = generate_xor_dataset(n, d)
%     % First approach
%     % Matrix of random numbers
%     R = rand(n, d);
%     
%     % Create a matrix X from R where X(i,j) = 1 when R(i,j) >= 0.5
%     % and X(i,j) = 0 when R(i,j) < 0.5
%     X = R >= 0.5;
%     
%     % Create a vector of class labels by summing each row of X and
%     % setting the corresponding row of y to 1 when the sum of the
%     % row of X is 1
%     y = sum(X,2) == 1;
%     y = double(y);
%     y(y == 0) = -1;

    % Second approach
    D = zeros(n,d + 1);
    for i=1:floor(n/2)
        D(i,:) = generate_xor_row(d);
    end
    
    for i=floor(n/2)+1:n
        D(i,:) = generate_not_xor_row(d);
    end
    
    X = D(:,1:end-1);
    y = D(:,end);

%     % Third approach
%     D = [0:2^d-1]';
%     X = rem(floor(D*pow2(-(d-1):0)),2);
%     
%     % Create a vector of class labels by summing each row of X and
%     % setting the corresponding row of y to 1 when the sum of the
%     % row of X is 1
%     y = sum(X,2) == 1;
%     y = double(y);
%     y(y == 0) = -1;
end
