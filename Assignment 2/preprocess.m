function [X] = preprocess(images, memory)
%PREPROCESS Preprocess a MNIST dataset
% Reshapes each image into a vector and rescale each pixel to [0,1]
% interval.
% Converts the labels to 1-hot encoding.


% Preprocess the images
X = reshape(images, [size(images, 1)*size(images, 2), size(images, 3)]);


if isequal(memory, 'yes')
    X(X <= 50) = -1;
    X(X > 50) = 1;
end
end