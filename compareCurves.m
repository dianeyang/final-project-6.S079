function [output_args] = compareCurves(curve1, curve2)
    % Generate the 2 curves we want to compare
    t = 0:0.01:2*pi;
    [x1, y1] = ellipse(t);
    [x2, y2] = ellipse(t);
    
    % Compute the Euclidean signature of each curve
    [kappa1, dkds1] = discreteEuclideanSignature(x1, y1);
    [kappa2, dkds2] = discreteEuclideanSignature(x2, y2);
    
    % Compute distance between original curves & between signature curves
    % (originalDist is for curiosity, signatureDist is what we really want)
    originalDist = discreteFrechetDist([x1 y1], [x2 y2])
    signatureDist = discreteFrechetDist([kappa1 dkds1], [kappa2 dkds2])
    
    createPlot(x1, y1, x2, y2, kappa1, dkds1, kappa2, dkds2)
end

function [] = createPlot(x1, y1, x2, y2, kappa1, dkds1, kappa2, dkds2)
    figure
    subplot(2,1,1);
    title('Original curve');
    plot(x1,y1)
    hold on
    plot(x2,y2)
    
    subplot(2,1,2);
    title('Euclidean signature');
    xlabel('curvature');
    ylabel('dk/ds');
    plot(kappa1, dkds1)
    hold on
    plot(kappa2, dkds2)
end

function [kappa] = curvature(x, y)
    % Compute curvature = u_xx / (1 + u_x^2)^(3/2)
    x_prime = gradient(x);
    y_prime = gradient(y);
    x_2prime = gradient(x_prime);
    y_2prime = gradient(y_prime);
    
    numerator = abs((x_prime .* y_2prime) - (y_prime .* x_2prime));
    denominator = (x_prime.^2 + y_prime.^2).^(3/2);
    kappa = numerator ./ denominator;
end

function [dkds] = dkds(x, y, kappa)
    % Compute dk/ds
    dkdx = gradient(kappa);
    dsdx = sqrt(1+gradient(y).^2);
    dkds = dkdx ./ dsdx;
end

function [kappa, deriv] = discreteEuclideanSignature(x, y)
    kappa = curvature(x, y);
    deriv = dkds(x, y, kappa);
    % Throw out the first 3 and last 3 values (I think they're
    % messed up because of how the gradient function works)
    kappa = kappa(4:end-3);
    deriv = deriv(4:end-3);
end

% function [dist] = hausdorffDistance(x1, y1, x2, y2) 
%
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURVES
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