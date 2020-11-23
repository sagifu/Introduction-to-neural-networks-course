function [X] = intoImage (vector)

X = reshape(vector, [length(vector)^0.5, length(vector)^0.5]);

X(X>0.2) = 6;
X(X<=0.2) = 20;
end