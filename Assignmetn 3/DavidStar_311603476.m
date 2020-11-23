clear; close all; clc;

Data = struct();
nData = 25000;
N = 100000;

XVecShape = [0.5 0.62 0.85 0.7 0.85 0.62 0.5 0.38 0.15 0.3 0.15 0.38];
YVecShape = [1 0.78 0.78 0.5 0.22 0.22 0 0.22 0.22 0.5 0.78 0.78];
sp = polyshape(XVecShape,YVecShape);

Data.X(1,:) = randperm(N,nData)/N;
Data.X(2,:) = randperm(N,nData)/N;
Data.Y(1,:) = isinterior(sp,Data.X(1,:),Data.X(2,:));

%%
N = [2 12 1];          % first layer - two inputs. last layer - one output
L = length(N) - 1;    % number of connecting layers
eta = 15e-2;
nTest = 1000;
correct = zeros(nTest,1);

% Initialize the layers' weights and activation functions
Net = arrayfun(@(n, n1) struct('W', 0.1*randn(n1, n+1)), ...	% weights
    N(1:L), N(2:L + 1));

feedBack = cell(length(N),1);
iter = zeros(1,300);
hiddenLayer = cell(1,nTest);

for rounds = 1:70
    perm = randperm(nData);
    TrainX = Data.X(:,perm);
    TrainY = Data.Y(:,perm);
    eta = eta*.97;
    for n = 1:nData
        % initial input
        feedBack{1}.activity = TrainX(:,n);
        feedBack{1}.derivative = zeros(size(TrainX(:,n)));
        % Feed forward
        for l = 1:L
            feedBack{l}.activity(end+1,:) = 1;
            [g, gp] = Sigmoid(Net(l).W * feedBack{l}.activity);	% get next layer's activities
            % (and derivatives)
            feedBack{l+1}.activity = round(g);
            if l == L
                feedBack{l+1}.activity = g;
            end
            feedBack{l+1}.derivative = gp;       % save results per layer
        end
        Y = feedBack{L + 1}.activity;           % get the output
        Y0 = TrainY(:,n);
        % Back propagation
        % we start with the derivative of the error function:
        %    E = 1/2*(sum(Y - Y0)^2)
        delta = (Y - Y0).*feedBack{L + 1}.derivative;
        for l = L:-1:1
            dW =  -eta * (delta * (feedBack{l}.activity'));   % get the weights updated
            delta = ((Net(l).W(:,1:end-1)') * delta) .* feedBack{l}.derivative;     % update delta
            Net(l).W = Net(l).W + dW;	% update the weights
        end
    end
    
%     for t = 1:nTest
%         point = rand(2,1);
%         % initial input
%         feedBack{1}.activity = point;
%         
%         for l = 1:L
%             feedBack{l}.activity(end+1,:) = 1;
%             feedBack{l+1}.activity = round(Sigmoid(Net(l).W * feedBack{l}.activity));	% get next layer's activities
%             if l == L
%                 feedBack{l+1}.activity = Sigmoid(Net(l).W * feedBack{l}.activity);
%             end
%         end
%         Y = feedBack{L + 1}.activity;           % get the output
%         Y0 = isinterior(sp,point(1),point(2));
%         
%         correct(t) = round(Y)==Y0;
%     end
%     iter(rounds) = mean(correct(:));
end

% pointType = [0 0.5 0.5 0.5 1 ; 0 0.2 0.5 0.8 1];
% feedBack{1}.activity = pointType;
% for l = 1:L
%     feedBack{l}.activity(end+1,:) = 1;
%     feedBack{l+1}.activity = round(Sigmoid(Net(l).W * feedBack{l}.activity));	% get next layer's activities
%     if l == L
%         feedBack{l+1}.activity = Sigmoid(Net(l).W * feedBack{l}.activity);
%     end
% end
% 
% plot(iter); hold on;
% ylim ([0 1]);
% xlabel('learning cycle');
% ylabel('P(correct classification)');
% title('mean rate of successful classification');

figure(); hold on;
plot(sp);
xlim([0 1]);
ylim([0 1]);
axis off;
for t = 1:150
    point = rand(2,1);
    % initial input
    feedBack{1}.activity = point;
    
    for l = 1:L
        feedBack{l}.activity(end+1,:) = 1;
        feedBack{l+1}.activity = round(Sigmoid(Net(l).W * feedBack{l}.activity));	% get next layer's activities
        if l == L
            feedBack{l+1}.activity = Sigmoid(Net(l).W * feedBack{l}.activity);
        end
    end
    Y = feedBack{L + 1}.activity;           % get the output
    Y0 = isinterior(sp,point(1),point(2));
    
    if Y0
        scatter(point(1),point(2),'r');
    else
        scatter(point(1),point(2),'b');
    end
end