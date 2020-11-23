function [X, Y] = preprocess(images, labels)
%PREPROCESS Preprocess a MNIST dataset
% Reshapes each image into a vector and rescale each pixel to [0,1]
% interval. 
% Converts the labels to 1-hot encoding. 

% Preprocess the images
X = reshape(images, [size(images, 1)*size(images, 2), size(images, 3)]);
X = double(X) / 255;

% Preprocess the labels
Y = full(ind2vec(labels' + 1));

end