function [l1, l2, l3, l4, r, phi] = optimizeLinkage(desiredPath)
    % For now, generate the 2 curves we want to compare
    t = 0:0.01:2*pi;
    [desiredPathX, desiredPathY] = eggThing(t);
    [currentPathX, currentPathY] = ellipse(t);
    distance = compareCurves(desiredPathX, desiredPathY, currentPathX, currentPathY);
    
    %currentPath = computeLinkagePath(linkage);
    %distance = compareCurves(currentPath, desiredPath);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST CURVES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x,y] = circle(t)
    x = cos(t);
    y = sin(t);
end

function [x,y] = ellipse(t)
% From page 33 of http://www.math.umn.edu/~olver/vi_/sig.pdf
    x = (-6/5) + (9/5)*cos(t);
    y = (3/sqrt(5))*sin(t);
end

function [x,y] = ellipse2(t)
    x = (3/sqrt(5))*sin(t) + 3;
    y = (-6/5) + (9/5)*cos(t) + 3;
end

function [x,y] = limacon(t)
    x = 0.05 + 3*cos(t) + 0.05*cos(2*t);
    y = 3*sin(t) + 0.05*sin(2*t);
end

function [x,y] = roundedTriangleThing(t)
%This thing http://bit.ly/1PCuDV8
    x = cos(t) + 0.2*cos(t).^2;
    y = sin(t) + 0.1*sin(t).^2;
end

function [x,y] = eggThing(t)
% From page 37 of http://www.math.umn.edu/~olver/vi_/sig.pdf
    x = cos(t) + 0.2*cos(t).^2;
    y = 0.5*x + sin(t) + 0.1*sin(t).^2;
end