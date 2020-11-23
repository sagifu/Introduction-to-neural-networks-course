function [train_images, ...
    train_labels, ...
    test_images, ...
    test_labels] = get_data(data_dir)
%GET_DATA Get the MNIST dataset
% Downloads the MNIST dataset (if necessary) to `data_dir` and loads it 
% into MATLAB. 
% Returns: 
% - train_images: a 28x28x[number of MNIST images] matrix containing the 
%                 raw MNIST images of the training set
% - train_labels: a [number of MNIST images]x1 matrix containing the labels
%                 for the MNIST images of the training set
% - test_images:  a 28x28x[number of MNIST images] matrix containing the 
%                 raw MNIST images of the test set
% - test_labels:  a [number of MNIST images]x1 matrix containing the labels
%                 for the MNIST images of the test set

% Get training images
if ~exist(fullfile(data_dir, 'train-images-idx3-ubyte'), 'file')
    gunzip('http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz', ...
        data_dir);
end

% Get training labels
if ~exist(fullfile(data_dir, 'train-labels-idx1-ubyte'), 'file')
    gunzip('http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz', ...
        data_dir);
end

% Get test images
if ~exist(fullfile(data_dir, 't10k-images-idx3-ubyte'), 'file')
    gunzip('http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz', ...
        data_dir);
end

% Get test labels
if ~exist(fullfile(data_dir, 't10k-labels-idx1-ubyte'), 'file')
    gunzip('http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz', ...
        data_dir);
end

% Load training data
train_images = MNIST.load_images(fullfile(data_dir, ...
                                          'train-images-idx3-ubyte'));
train_labels = MNIST.load_labels(fullfile(data_dir, ...
                                          'train-labels-idx1-ubyte'));

% Load test data
test_images = MNIST.load_images(fullfile(data_dir, ...
                                         't10k-images-idx3-ubyte'));
test_labels = MNIST.load_labels(fullfile(data_dir, ...
                                         't10k-labels-idx1-ubyte'));

end

