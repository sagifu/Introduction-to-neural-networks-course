function [n_patterns, ...
    P_error, ...
    mean_steps, ...
    noisePercentage] = ...
    determinantNoise(N, n_patterns, start_pattern, n_trials, noisePercentage, showOff)

%% Set parameters

max_steps = 5000;   % maximum search steps

noiseProgress = 100/noisePercentage;        % adjust distortion gaps

if showOff
    n_patterns = 10;
    start_pattern = n_patterns;
    n_trials = 1;
end
%% Distort ~ Reconstruct loops

P_error = zeros(1,n_patterns);       % a vector for succees rate
mean_steps = zeros(1,n_patterns);    % a vector for mean search steps for each distortion

for reps = start_pattern:n_patterns              % for each number of patterns
    
    P = reps;      % number of patterns
    
    correctRecons = 0;              % sum the correct reconstructions
    stepsVec = zeros(1,n_trials);   % saves number of steps for each trial
    
    for trial = 1:n_trials          % trials loop
        %% Set memory of random data patterns
        
        memory = round(rand(N,P)); % row indicates the neuron, column indicates the pattern
        memory(memory == 0) = -1;  % change from binary encoding to sign encoding
        
        %% Weights array update
        
        Weights = zeros(N);         % final weights array
        helpWeights = zeros(N);     % assisstant weights array
        
        for a = 1:P                 % for each pattern
            for i = 1:N             % for each neuron of it
                for j = 1:N         % multiply by all other neurons in the pattern
                    helpWeights(i,j) = memory(i,a) * memory(j,a);
                end
                helpWeights(i,i) = 0;           % the neuron does not effect itself
            end
            Weights = Weights + helpWeights;    % sum the weights across neurons
        end
        
        Weights = Weights / N;      % divide by number of neurons, according to activation equation
        
        
        %% Noise affliction
        
        randPatternOrig = memory(:,randi(P));           % choose a random pattern
        randPattern = randPatternOrig;                  % copy it
        randPattern(noiseProgress:noiseProgress:end) = 1;   % distort by determinant noise
        
        if showOff
            OrigShow = randPatternOrig;
            OrigShow(OrigShow == 1) = 6;
            OrigShow(OrigShow == -1) = 20;
            h3 = figure('units', 'normalized', 'Position', [0 0.2 0.5 0.5]);
            hold on;
            imagesc(intoImage(OrigShow));
            title('Original pattern', 'FontSize', 18);
            hold off;
            h4 = figure('units', 'normalized', 'Position', [0.5 0.2 0.5 0.5]);
        end
        %% Reconstruction
        
        existPattern = 1;       % boolean variable
        steps = 0;              % steps indicator
        
        while existPattern
            steps = steps +1;           % add step count
            a = randi(N);               % choose a random neuron
            randPattern(a) = sign(Weights(a,:)*randPattern);    % change its sign according to dynamics equation
            
            if showOff
                randShow = randPattern;
                randShow(randShow == 1) = 6;
                randShow(randShow == -1) = 20;
                figure(h4);
                hold on;
                imagesc(intoImage(randShow));
                title({'Determinant distorted pattern'; [num2str(steps), ' steps']}, 'FontSize', 18);
                hold off
                if ~isequal(randPattern, randPatternOrig) && ismember(randPattern', memory', 'rows')
                    disp('The algorithm recalled a different pattern!');
                    break;
                end
            end
            
            if isequal(randPattern, randPatternOrig)    % if the pattern has reached its target
                correctRecons = correctRecons + 1;      % count it and stop searching
                if showOff
                    disp('The algorithm recalled the pattern!');
                end
                break;
            end
            
            if max_steps == steps  % after reaching maximum steps of search, stop searching
                if showOff
                    disp('The algorithm recalled a sporious pattern!');
                end
                break;
            end
        end
        
        stepsVec(1,trial) = steps;  % save number of steps for this trial
    end
    
    P_error(1,reps) = 1-(correctRecons/n_trials);       % percentage of error across trials with "reps" amount of distortion
    mean_steps(1,reps) = mean(stepsVec);                % mean steps across trials
    
    % display progress indicator
    disp([num2str(reps), ' patterns']);
end

if ~showOff
    h1 = figure('units', 'normalized', 'Position', [0 0.2 0.5 0.5]);
    set(h1, 'Name', 'P_error ~ Patterns - Determinant noise', 'NumberTitle', 'off');
    hold on;
    plot([1:n_patterns], P_error);
    xlim = [1 n_patterns];
    ylim = [0 1];
    xlabel('Patterns', 'FontSize', 18);
    ylabel('P(error)', 'FontSize', 18);
    title({'Recall error probability'; 'as a function of number of patterns'}, 'FontSize', 18);
    hold off;
    
    h2 = figure('units', 'normalized', 'Position', [0.5 0.2 0.5 0.5]);
    set(h2, 'Name', 'Mean time steps ~ Patterns - Determinant noise', 'NumberTitle', 'off');
    hold on;
    plot([1:n_patterns], mean_steps);
    xlim = [1 n_patterns];
    ylim = [0 max(mean_steps)];
    xlabel('Patterns', 'FontSize', 18);
    ylabel('Mean Time Steps', 'FontSize', 18);
    title({'Average time steps until recall'; 'as a function of number of patterns'}, 'FontSize', 18);
    hold off;
end

end