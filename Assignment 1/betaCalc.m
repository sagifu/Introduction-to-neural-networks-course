function Beta = betaCalc (v,z)

if z == 'n'
    b = 0.125*exp(-v/80);
end
if z == 'm'
    b = 4*exp(-v/18);
end
if z == 'h'
    b = 1/(exp((30-v)/10) + 1);
end

Beta = b;
end