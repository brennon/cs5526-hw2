feature_counts = 2:32;
accuracies = zeros(length(feature_counts),1);

run_feature_test = true;
run_support_vector_stats = true;
run_non_support_vector_removal = true;
run_support_vector_removal = true;

if run_feature_test
    fprintf('Running feature-length tests\n');
    for f=1:length(feature_counts)
        features = feature_counts(f);
        examples = 500;

        % Generate the dataset.
        [X, y] = generate_xor_dataset(examples, features);
        D = [X y];

        % Configure a function handle for the kernel function.
        sigma = 1;
        kernel = gaussian_kernel(sigma);

        % Subset dataset into training and testing sets.
        indices = crossvalind('HoldOut', examples, 0.667);
        Training = D(indices,:);
        Testing = D(~indices,:);
        fprintf('\tCross-validating classifier for %d features, %d training examples, %d testing examples...\n', features, size(Testing,1), size(Training,1));

        % Train classifier.
        epsilon = 0.00001;
        c = 10;
        [alpha, K] = svm_dual(Training, kernel, c, epsilon);

        correct = 0;
        incorrect = 0;
        total = 0;

        % Classify each point in testing set.
        for j=1:size(Testing,1)
            if classify_point(Testing(j,1:end-1), Training, kernel, K, alpha) == Testing(j,end)
                correct = correct + 1;
            else
                incorrect = incorrect + 1;
            end

            total = total + 1;
        end

        accuracies(f) = correct / total;

        fprintf('\t\tAccuracy: %.2f%%\n', accuracies(f));
    end
    
    figure;
    fprintf('\tPlotting results\n');
    plot(feature_counts, accuracies);
    title('Feature Count vs. Classifier Accuracy');
    xlabel('Feature Count');
    ylabel('Classifier Accuracy');
    axis([2 32 0 1]);

    fprintf('\n\tCombined mean accuracy over all feature counts: %.2f%%\n\n', mean(accuracies));
end

if run_support_vector_stats
    features = 8;
    examples = 500;

    % Generate the dataset.
    [X, y] = generate_xor_dataset(examples, features);
    D = [X y];
    
    % Configure a function handle for the kernel function.
    sigma = 1;
    kernel = gaussian_kernel(sigma);
    
    % Subset dataset into training and testing sets.
    indices = crossvalind('HoldOut', examples, 0.667);
    Training = D(indices,:);
    Testing = D(~indices,:);

    % Train classifier.
    epsilon = 0.00001;
    c = 10;
    [alpha, K] = svm_dual(Training, kernel, c, epsilon);
    
    support_vector_indices = alpha > 0;
    support_vectors = Training(support_vector_indices,:);
    
    % Bar chart of number of support vectors by 'number of ones' in the
    % support vector
    support_vector_types = sum(support_vectors(:,1:end-1),2);
    unique_vector_types = sort(unique(support_vector_types));
    unique_bars = zeros(length(unique_vector_types), 2);
    for u=1:length(unique_vector_types)
        unique_bars(u,1) = unique_vector_types(u);
        unique_bars(u,2) = sum(support_vector_types == unique_vector_types(u));
    end
    figure;
    fprintf('Plotting results\n\n');
    bar(unique_bars(:,1),unique_bars(:,2));
    title('Number of support vectors by the number of 1s in the support vector');
    xlabel('Number of 1s in support vector');
    ylabel('Number of support vectors');
end

if run_non_support_vector_removal
    fprintf('Running non-support vector removal tests\n');
    features = 10;
    examples = 500;
    removals = 1:examples;

    % Generate the dataset.    
    [X, y] = generate_xor_dataset(examples, features);
    D = [X y];
    fprintf('\tDataset generated with %d examples and %d features\n', examples, features);
    
    % Configure a function handle for the kernel function.
    sigma = 1;
    kernel = gaussian_kernel(sigma);
    
    nsv_removal_accuracies = [];
    for r=removals
    
        % Subset dataset into training and testing sets.
        indices = crossvalind('HoldOut', size(D,1), 0.667);
        Training = D(indices,:);
        Testing = D(~indices,:);

        % Train classifier.
        epsilon = 0.00001;
        c = 10;
        [alpha, K] = svm_dual(Training, kernel, c, epsilon);

        support_vector_indices = alpha > 0;
        support_vectors = Training(support_vector_indices,:);
        non_support_vectors = Training(~support_vector_indices,:);

        correct = 0;
        incorrect = 0;
        total = 0;

        % Classify each point in testing set.
        for j=1:size(Testing,1)
            if classify_point(Testing(j,1:end-1), Training, kernel, K, alpha) == Testing(j,end)
                correct = correct + 1;
            else
                incorrect = incorrect + 1;
            end

            total = total + 1;
        end
        
        fprintf('\tNon-support vectors removed: %d, Accuracy: %.2f%%\n', r, correct / total);
        
        nsv_removal_accuracies = [nsv_removal_accuracies; correct / total];
        
        % Pick a non-support vector and remove it from the dataset.
        try
            removal_index = randsample(find(~support_vector_indices == 1), 1);
            D(removal_index,:) = [];
        catch
            break;
        end
    end
    
    % Plot results.
    fprintf('\tPlotting results\n\n');
    nsv_removal_accuracies(find(nsv_removal_accuracies == 0)) = [];
    
    figure;
    plot(1:length(nsv_removal_accuracies),nsv_removal_accuracies);
    axis([1 length(nsv_removal_accuracies) 0 1]);    
    title('Accuracy vs. Number of Removed Non-Support Vectors');
    xlabel('Number of Non-Support Vectors Removed');
    ylabel('Classifier Accuracy');
end

if run_support_vector_removal
    fprintf('Running support vector removal tests\n');
    features = 10;
    examples = 500;
    removals = 1:examples;

    % Generate the dataset.
    [X, y] = generate_xor_dataset(examples, features);
    D = [X y];
    fprintf('\tDataset generated with %d examples and %d features\n', examples, features);
    
    % Configure a function handle for the kernel function.
    sigma = 1;
    kernel = gaussian_kernel(sigma);
    
    sv_removal_accuracies = [];
    for r=removals
    
        % Subset dataset into training and testing sets.
        indices = crossvalind('HoldOut', size(D,1), 0.667);
        Training = D(indices,:);
        Testing = D(~indices,:);

        % Train classifier.
        epsilon = 0.00001;
        c = 10;
        [alpha, K] = svm_dual(Training, kernel, c, epsilon);

        support_vector_indices = alpha > 0;
        support_vectors = Training(support_vector_indices,:);
        non_support_vectors = Training(~support_vector_indices,:);

        correct = 0;
        incorrect = 0;
        total = 0;

        % Classify each point in testing set.
        for j=1:size(Testing,1)
            if classify_point(Testing(j,1:end-1), Training, kernel, K, alpha) == Testing(j,end)
                correct = correct + 1;
            else
                incorrect = incorrect + 1;
            end

            total = total + 1;
        end
        
        fprintf('\tNon-support vectors removed: %d, Accuracy: %.2f%%\n', r, correct / total);
        
        sv_removal_accuracies = [sv_removal_accuracies; correct / total];
        
        % Pick a support vector and remove it from the dataset.
        try
            removal_index = randsample(find(support_vector_indices == 1), 1);
            D(removal_index,:) = [];
        catch
            break;
        end
    end
    
    % Plot results.
    fprintf('\tPlotting results\n\n');
    sv_removal_accuracies(find(sv_removal_accuracies == 0)) = [];
    
    figure;
    plot(1:length(sv_removal_accuracies),sv_removal_accuracies);
    axis([1 length(sv_removal_accuracies) 0 1]);    
    title('Accuracy vs. Number of Removed Support Vectors');
    xlabel('Number of Support Vectors Removed');
    ylabel('Classifier Accuracy');
end