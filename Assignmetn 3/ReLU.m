function [g, gp] = ReLU(x)
% Rectified Linear Units
% g -  max(0,x)
% gp - ReLU derivative

g = max(0,x);
if x<=0
    gp = 0;
else
    gp = 1;
end

end