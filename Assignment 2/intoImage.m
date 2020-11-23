function [X] = intoImage (vector)

X = reshape(vector, [length(vector)^0.5, length(vector)^0.5]);

end