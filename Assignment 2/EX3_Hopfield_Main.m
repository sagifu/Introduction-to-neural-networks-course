clear; close all; clc;

%% PAY ATTENTION
% In order for the algorithm to work properly (with the MNIST functions)
% the current folder MUST be the location of all the functions and Data
% file, otherwise it won't work.

% loading data
currentFolder = pwd;
data_dir = [currentFolder, '\Data'];  % Data directory

% boolean variable
showOff = 1;

%% Choose your function

Hopfield = 'random';             
% Hopfield = 'deter';            
% Hopfield = 'distort';          
% Hopfield = 'MNIST';            
% Hopfield = 'MNIST Handwrite';
% Hopfield = 'MNIST Divert';
% Hopfield = 'MNIST deter';


%% Random

if isequal(Hopfield , 'random')
    % INPUT ARGUMENTS:
    %   - number of neurons
    %   - number of maximum patterns
    %   - starting number of patterns
    %   - number of trials for each number of patterns
    %   - distortion percentage
    %   - boolean variable:
    %       True - 100 neurons, 10 patterns, 1 trial. display figure
    %       False - real input, long caculation
    
    [random_patterns, P_error_random, mean_steps_random, random_distortion] = ...
        randomNoise(100, 100, 1, 1000, 2, showOff);
    
    % OUTPUT ARGUMENTS:
    %   - number of maximum patterns
    %   - error probability for each number of patterns 
    %   - mean steps for each number of patterns
    %   - distortion percentage
end

%% Determinant

if isequal(Hopfield, 'deter')
    % INPUT ARGUMENTS:
    %   - number of neurons
    %   - number of maximum patterns
    %   - starting number of patterns
    %   - number of trials for each number of patterns
    %   - distortion percentage
    %   - boolean variable:
    %       True - 100 neurons, 10 patterns, 1 trial. display figure
    %       False - real input, long caculation
    
    [deter_patterns, P_error_deter, mean_steps_deter, deter_distortion] = ...
        determinantNoise(100, 100, 1, 1000, 20, showOff);

    % OUTPUT ARGUMENTS:
    %   - number of maximum patterns
    %   - error probability for each number of patterns 
    %   - mean steps for each number of patterns
    %   - distortion percentage
end

%% Distortion

if isequal(Hopfield, 'distort')
    % INPUT ARGUMENTS:
    %   - number of neurons
    %   - constant number of patterns
    %   - maximum distortion percentage
    %   - number of trials for each number of patterns
    %   - boolean variable:
    %       True - 100 neurons, 8 patterns, 1 trial. display figure
    %       False - real input, long caculation
    
    [n_distort, P_error_distort, mean_steps_distort] = ...
        distortionPercentage(100, 8, 100, 1000, showOff);
    
    % OUTPUT ARGUMENTS:
    %   - number of maximum distortion percentage
    %   - error probability for each distortion percentage 
    %   - mean steps for each distortion percentage
end

%% MNIST

if isequal(Hopfield, 'MNIST')
    % INPUT ARGUMENTS:
    %   - data directory file path
    %   - number of maximum patterns
    %   - number of trials for each number of patterns
    %   - distortion percentage
    %   - boolean variable:
    %       True - 100 neurons, 2 patterns, 1 trial. display figure
    %       False - real input long caculation
    
    [MNIST_patterns, P_error_MNIST, mean_steps_MNIST, distortPerceMNIST] = ...
        MNISTPatterns (data_dir, 10, 1000, 2, showOff);
    
    % OUTPUT ARGUMENTS:
    %   - number of maximum patterns
    %   - error probability for each number of patterns 
    %   - mean steps for each number of patterns
    %   - distortion percentage
end

%% MNIST Handwrite

if isequal(Hopfield, 'MNIST Handwrite')
    % INPUT ARGUMENTS:
    %   - data directory file path
    %   - number of maximum patterns
    %   - number of trials for each number of patterns
    %   - boolean variable:
    %       True - 100 neurons, 2 patterns, 1 trial. display figure
    %       False - real input long caculation
    
    [MNIST_HW_patterns, P_error_MNIST_HW, mean_steps_MNIST_HW] = ...
        MNISTHandwrite (data_dir, 10, 1000, showOff);
    
    % OUTPUT ARGUMENTS:
    %   - number of maximum patterns
    %   - error probability for each number of patterns 
    %   - mean steps for each number of patterns
end

%% MNIST Diverted

if isequal(Hopfield, 'MNIST Divert')
    % INPUT ARGUMENTS:
    %   - data directory file path
    %   - number of maximum patterns
    %   - number of trials for each number of patterns
    %   - number rows and columns to be diverted in the picture
    %   - boolean variable:
    %       True - 100 neurons, 2 patterns, 1 trial. display figure
    %       False - real input long caculation
    
    [MNIST_D_patterns, P_error_MNIST_D, mean_steps_MNIST_D] = ...
        MNISTDiverted (data_dir, 10, 1000, 2, showOff);
    
    % OUTPUT ARGUMENTS:
    %   - number of maximum patterns
    %   - error probability for each number of patterns 
    %   - mean steps for each number of patterns
end

%% MNIST Determinant noise

if strcmpi(Hopfield, 'MNIST deter')
    % INPUT ARGUMENTS:
    %   - data directory file path
    %   - number of maximum patterns
    %   - number of trials for each number of patterns
    %   - distortion percentage
    %   - boolean variable:
    %       True - 100 neurons, 2 patterns, 1 trial. display figure
    %       False - real input long caculation
    
    [MNIST_deter_patterns, P_error_MNIST_deter, mean_steps_MNIST_deter, noisePercentageMNISTDeter] = ...
    MNISTPatternsDeter (data_dir, 10, 1000, 20, showOff);

    % OUTPUT ARGUMENTS:
    %   - number of maximum patterns
    %   - error probability for each number of patterns 
    %   - mean steps for each number of patterns
    %   - distortion percentage
end