function [n_distort, ...
    P_error, ...
    mean_steps] = ...
    distortionPercentage(N, P, n_distort, n_trials, showOff)

%% Set parameters

start_distort = 1;

max_steps = 5000;   % maximum search steps

if showOff
    P = 8;
    n_distort = 15;
    start_distort = n_distort;
    n_trials = 1;
end

%% Distort~Reconstruct loops

P_error = zeros(1,n_distort);       % a vector for succees rate
mean_steps = zeros(1,n_distort);    % a vector for mean search steps for each distortion

for reps = start_distort:n_distort              % for each distortion percentage
    
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
        distortPerce = (reps/100);                      % update distortion percentage
        noise = randperm(N,round(N*distortPerce));      % choose random neurons to be distorted
        randPattern(noise) = randPattern(noise) * -1;   % distort
        
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
                title({'Randomly distorted pattern'; [num2str(steps), ' steps']}, 'FontSize', 18);
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
    
    stepsVec(stepsVec == max_steps) = [];
    P_error(1,reps) = 1-(correctRecons/n_trials); % percentage of error across trials with "reps" amount of distortion
    mean_steps(1,reps) = mean(stepsVec);                % mean steps across trials
    
    % display progress indicator
    disp([num2str(reps), '% distortion']);
end

if ~showOff
    h1 = figure('units', 'normalized', 'Position', [0 0.2 0.5 0.5]);
    set(h1, 'Name', 'P_error ~ Distortion', 'NumberTitle', 'off');
    hold on;
    plot([1:n_distort], P_error);
    xlim = [1 n_distort];
    ylim = [0 1];
    xlabel('Percentage of distortion', 'FontSize', 18);
    ylabel('P(error)', 'FontSize', 18);
    title({'Recall error probability'; 'as a function of percentage of distortion'}, 'FontSize', 18);
    hold off;
    
    h2 = figure('units', 'normalized', 'Position', [0.5 0.2 0.5 0.5]);
    set(h2, 'Name', 'Mean time steps ~ Distortion', 'NumberTitle', 'off');
    hold on;
    plot([1:n_distort], mean_steps);
    xlim = [1 n_distort];
    ylim = [0 max(mean_steps)];
    xlabel('Percentage of distortion', 'FontSize', 18);
    ylabel('Mean Time Steps', 'FontSize', 18);
    title({'Average time steps until recall'; 'as a function of percentage of distortion'}, 'FontSize', 18);
    hold off;
end

end


