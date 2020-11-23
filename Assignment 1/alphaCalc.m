function Alpha = alphaCalc(v,z)

if z == 'n'
    a = (10-v)/(100*(exp((10-v)/10) - 1));
end
if z == 'm'
    a = (25-v)/(10*(exp((25-v)/10) - 1));
end
if z == 'h'
    a = 0.07*exp(-v/20);
end

Alpha = a;
end