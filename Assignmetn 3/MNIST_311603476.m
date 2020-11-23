clear; close all; clc;

%% load data
currentFolder = pwd;
data_dir = [currentFolder, '\Data'];  % Data directory

[train_images, train_labels, ...
    test_images, test_labels] = MNIST.get_data(data_dir);

%% Preprocess

[X_train, Y_train]  = MNIST.preprocess(train_images, train_labels);
[X_test,  Y_test]   = MNIST.preprocess(test_images,  test_labels);


%%
N = [784 69 10];          % first layer - two inputs. last layer - one output
L = length(N) - 1;    % number of connecting layers
eta = 1e-1;
TrainBatch = length(X_train(1,:))/10;
BatchStart = 1:TrainBatch:length(X_train(1,:));
TestBatch = length(X_test(1,:))/10;
correct = zeros(1,TestBatch);

% Boolean variable in order to stop experiment after learning if
% classification wasn't correct, and display figure
stopForHumanCheck = 0; 
HumanRecog = [];

% Initialize the layers' weights and activation functions
Net = arrayfun(@(n, n1) struct('W', 0.1*randn(n1, n+1)), ...	% weights
    N(1:L), N(2:L + 1));

feedBack = cell(length(N),1);
iter = zeros(1,51);

for t = 1:TestBatch
    test = randi(length(X_test(1,:)));
    % initial input
    feedBack{1}.activity = X_test(:,test);
    
    for l = 1:L
        feedBack{l+1}.activity = Sigmoid(Net(l).W * [feedBack{l}.activity; 1]);	% get next layer's activities
        if l == L
            [g, gp] = ReLU(Net(l).W * [feedBack{l}.activity ; 1]);
        end
    end
    Y = feedBack{L + 1}.activity;           % get the output
    
    correct(t) = vec2ind(Y) == vec2ind(Y_test(:,test));
end
iter(1) = mean(correct(:));

for rounds = 1:50
    perm = randperm(length(X_train(1,:)), TrainBatch);
    TrainX = X_train(:,perm);
    TrainY = Y_train(:,perm);
    eta = eta*.95;
    for n = 1:TrainBatch
        % initial input
        feedBack{1}.activity = TrainX(:,n);
        feedBack{1}.derivative = zeros(size(TrainX(:,n)));
        % Feed forward
        for l = 1:L
            [g, gp] = Sigmoid(Net(l).W * [feedBack{l}.activity ; 1]);	% get next layer's activities
            % (and derivatives)
            if l == L
                [g, gp] = ReLU(Net(l).W * [feedBack{l}.activity ; 1]);
            end
            feedBack{l+1}.activity = g;
            feedBack{l+1}.derivative = gp;       % save results per layer
        end
        Y = feedBack{L + 1}.activity ;           % get the output
        Y0 = TrainY(:,n);
        % Back propagation
        % we start with the derivative of the error function:
        %    E = 1/2*(sum(Y - Y0)^2)
        delta = (Y - Y0).*feedBack{L + 1}.derivative;
        for l = L:-1:1
            dW =  -eta * (delta * ([feedBack{l}.activity; 1]'));   % get the weights updated
            delta = ((Net(l).W(:,1:end-1)') * delta) .* feedBack{l}.derivative;     % update delta
            Net(l).W = Net(l).W + dW;	% update the weights
        end
    end
    
    for t = 1:TestBatch
        test = randi(length(X_test(1,:)));
        % initial input
        feedBack{1}.activity = X_test(:,test);
        
        for l = 1:L
            feedBack{l+1}.activity = Sigmoid(Net(l).W * [feedBack{l}.activity; 1]);	% get next layer's activities
            if l == L
                [g, gp] = ReLU(Net(l).W * [feedBack{l}.activity ; 1]);
            end
        end
        Y = feedBack{L + 1}.activity;           % get the output
        
        correct(t) = vec2ind(Y) == vec2ind(Y_test(:,test));
        if rounds>45 && ~correct(t) && stopForHumanCheck
            HumanRecog = feedBack{1}.activity;
            break;
        end
    end
    if ~isempty(HumanRecog)
        break;
    end
    iter(rounds+1) = mean(correct(:));
end

if ~isempty(HumanRecog)
    HumanRecog = intoImage(HumanRecog);
    imagesc(HumanRecog);
    axis off;
    error('the algorithm was not able to classify this number correctly');
end

plot((0:50), iter); hold on;
ylim ([0 1]);
xlabel('learning cycle');
ylabel('P(correct classification)');
title('mean rate of successful classification');

