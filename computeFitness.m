function [distance] = computeFitness(l1, l2, l3, l4, r, phi, desiredPath)
    % For now, generate the 2 curves we want to compare
    t = 0:0.01:2*pi;
    desiredPath = eggThing(t);
    currentPath = roundedTriangleThing(t);
    distance = compareCurves(desiredPath, currentPath);
    
    %currentPath = computeLinkagePath(linkage);
    %distance = compareCurves(currentPath, desiredPath);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST CURVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function curve = circ(t)
    x = cos(t);
    y = sin(t);
    curve = [x;y];
end

function curve = ellipse(t)
% From page 33 of http://www.math.umn.edu/~olver/vi_/sig.pdf
    x = (-6/5) + (9/5)*cos(t);
    y = (3/sqrt(5))*sin(t);
    curve = [x;y];
end

function curve = ellipse2(t)
    x = (3/sqrt(5))*sin(t) + 3;
    y = (-6/5) + (9/5)*cos(t) + 3;
    curve = [x;y];
end

function curve = limacon(t)
    x = 0.05 + 3*cos(t) + 0.05*cos(2*t);
    y = 3*sin(t) + 0.05*sin(2*t);
    curve = [x;y];
end

function curve = roundedTriangleThing(t)
%This thing http://bit.ly/1PCuDV8
    x = cos(t) + 0.2*cos(t).^2;
    y = sin(t) + 0.1*sin(t).^2;
    curve = [x;y];
end

function curve = eggThing(t)
% From page 37 of http://www.math.umn.edu/~olver/vi_/sig.pdf
    x = cos(t) + 0.2*cos(t).^2;
    y = 0.5*x + sin(t) + 0.1*sin(t).^2;
    curve = [x;y];
end