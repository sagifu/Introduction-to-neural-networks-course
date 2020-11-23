function [n_patterns, ...
    P_error, ...
    mean_steps, ...
    noisePercentage] = ...
    MNISTPatternsDeter (data_dir, n_patterns, n_trials, noisePercentage, showOff)

%% Load data

start_pattern = 1;
noiseProgress = 100/noisePercentage;

[train_images, train_labels, ...
    test_images, test_labels] = MNIST.get_data(data_dir);

if showOff
    n_patterns = 2;
    start_pattern = n_patterns;
    noisePercentage = 20/100;
    n_trials = 1;
end
%% Set parameters

N = length(train_images(:,1,1)) * length(train_images(:,1,1));

max_steps = 5000;

%% Patterns choice

P_error = zeros(1, n_patterns);
mean_steps = zeros(1, n_patterns);

for reps = start_pattern:n_patterns
    
    P = reps;
    
    correctRecons = 0;
    stepsVec = zeros(1,n_trials);
    
    for trial = 1:n_trials
        
        choose = randperm(10,P) - 1;
        
        select_num = zeros(1,P);
        for a = 1:P
            helpSelect = find(train_labels == choose(a));
            select_num(a) = helpSelect(randi(length(helpSelect)));
        end
        
        memory = train_images(:,:,select_num);
        
        memory = preprocess(memory, 'yes');
        
        %% Weights array update
        
        Weights = zeros(N);
        helpWeights = zeros(N);
        
        for a = 1:P
            for i = 1:N
                for j = 1:N
                    helpWeights(i,j) = memory(i,a) * memory(j,a);
                end
                helpWeights(i,i) = 0;
            end
            Weights = Weights + helpWeights;
        end
        
        Weights = Weights / N;
        
        %% Noise affliction
        
        randPatternOrig = memory(:,randi(P));
        randPattern = randPatternOrig;
        randPattern(noiseProgress:noiseProgress:end) = 1;
        
        if showOff
            OrigShow = randPatternOrig;
            OrigShow(OrigShow == 1) = 6;
            OrigShow(OrigShow == -1) = 20;
            h3 = figure('units', 'normalized', 'Position', [0 0.2 0.5 0.5]);
            hold on;
            imagesc(intoImage(OrigShow));
            axis off;
            title('Original pattern', 'FontSize', 18);
            hold off;
            h4 = figure('units', 'normalized', 'Position', [0.5 0.2 0.5 0.5]);
        end
        %% Reconstruction
        
        existPattern = 1;
        steps = 0;
        
        while existPattern
            steps = steps +1;
            a = randi(N);
            randPattern(a) = sign(Weights(a,:)*randPattern);
            
            if showOff
                randShow = randPattern;
                randShow(randShow == 1) = 6;
                randShow(randShow == -1) = 20;
                figure(h4);
                hold on;
                imagesc(intoImage(randShow));
                axis off;
                title({['MNIST determinant ', num2str(noisePercentage*100),'% distortion pattern']; [num2str(steps), ' steps']}, 'FontSize', 18);
                hold off
                if ~isequal(randPattern, randPatternOrig) && ismember(randPattern', memory', 'rows')
                    disp('The algorithm recalled a different pattern!');
                    break;
                end
            end
            
            if isequal(randPattern, randPatternOrig)
                correctRecons = correctRecons + 1;
                if showOff
                    disp('The algorithm recalled the pattern!');
                end
                break;
            end
            
            if max_steps == steps
                if showOff
                    disp('The algorithm recalled a sporious pattern!');
                end
                break;
            end
        end
        
        stepsVec(1, trial) = steps;
        
        
    end
    
    P_error(1,reps) = 1-(correctRecons/n_trials); % percentage of error across trials with "reps" amount of distortion
    mean_steps(1,reps) = mean(stepsVec);                % mean steps across trials
    
    % display progress indicator
    disp([num2str(reps), ' digits']);
end

if ~showOff
    h1 = figure('units','normalized', 'Position', [0 0.2 0.5 0.5]);
    set(h1, 'Name', 'P(error) ~ Patterns - MNIST Determinant', 'NumberTitle', 'off');
    hold on;
    plot([1:n_patterns], P_error);
    xlim = [1 n_patterns];
    ylim = [0 1];
    xlabel('Patterns', 'FontSize', 18);
    ylabel('P(error)', 'FontSize', 18);
    title({'MNIST determinant noise recall error probability'; 'as a function of number of patterns'}, 'FontSize', 18);
    hold off;
    
    h2 = figure('units','normalized', 'Position', [0.5 0.2 0.5 0.5]);
    set(h2, 'Name', 'Mean time steps ~ Patterns - MNIST Determinant', 'NumberTitle', 'off');
    hold on;
    plot([1:n_patterns], mean_steps);
    xlim = [1 n_patterns];
    ylim = [0 max(mean_steps)];
    xlabel('Patterns', 'FontSize', 18);
    ylabel('Mean Time Steps', 'FontSize', 18);
    title({'MNIST determinant noise average time steps until recall'; 'as a function of number of patterns'}, 'FontSize', 18);
    hold off;
end

end