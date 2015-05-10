function [distance] = compareCurves(curve1, curve2)
% Calculate the distance metric between 2 input curves
    % Compute arc lengths and normalize
    [arcLen1, totalLen1] = arcLength(curve1);
    [arcLen2, totalLen2] = arcLength(curve2);
    arcLen1 = arcLen1 / totalLen1;
    arcLen2 = arcLen2 / totalLen2;

    % Compute curvature at each point
    curvature1 = curvature(curve1);
    curvature2 = curvature(curve2);
    
    % Find rotation of curve that minimizes distance
    minDist = discreteFrechetDist([arcLen1 curvature1], [arcLen2 curvature2]);
    shift = 0;
    for i=1:length(curvature1)
        curvature2 = circshift(curvature2,1,2);
        distance = discreteFrechetDist([arcLen1 curvature1], [arcLen2 curvature2])
        if distance < minDist
            minDist = distance;
            shift = i;
        end
    end       
    curvature2 = circshift(curvature2,shift,2);
    
    % Scale: scale signature curve
    curvature2 = curvature2 * (totalLen2/totalLen1);
    
    plotTwo(curve1, curve2, curvature1, curvature2, arcLen1, arcLen2)
end

function [] = plotTwo(curve1, curve2, k1, k2, s1, s2)
    x1 = curve1(1,:);
    y1 = curve1(2,:);
    x2 = curve2(1,:);
    y2 = curve2(2,:);
    
    figure
    subplot(2,1,1);
    plot(x1,y1)
    hold on
    plot(x2,y2)
    title('Original curve');
    xlabel('x')
    ylabel('y')
    
    subplot(2,1,2);
    plot(s2, k1)
    hold on
    plot(s2, k2)
    title('Signature curve')
    xlabel('Arc length')
    ylabel('Curvature')
end

function [curvature] = curvature(curve)
% Compute curvature = u_xx / (1 + u_x^2)^(3/2)
% Can also be viewed as the 2nd derivative of slope wrt arc length
    x = curve(1,:);
    y = curve(2,:);
    x_prime = gradient(x);
    y_prime = gradient(y);
    x_2prime = gradient(x_prime);
    y_2prime = gradient(y_prime);
    
    numerator = abs((x_prime .* y_2prime) - (y_prime .* x_2prime));
    denominator = (x_prime.^2 + y_prime.^2).^(3/2);
    curvature = chop(numerator ./ denominator);
end

function [arcLength, totalLength] = arcLength(curve)
% Compute cumulative arc length, then normalize length to 1
    x = curve(1,:);
    y = curve(2,:);
    x_prime = chop(gradient(x));
    y_prime = chop(gradient(y));
    N = length(x_prime);
    arcLength = zeros(N, 1);
    increments = zeros(N, 1);
    for i=2:N
        prev = arcLength(i-1);
        ds = sqrt(x_prime(i)^2 + y_prime(i)^2);
        arcLength(i) = prev + ds;
    end
    arcLength = arcLength';
    totalLength = arcLength(end);
end

function [result] = chop(arr)
    result = arr(4:end-3);
end