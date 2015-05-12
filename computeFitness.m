function [distance] = computeFitness(linkage, desiredPath)
    currentPath = getLinkageCurve(linkage);
    if length(currentPath) == 0
        distance = Inf(1);
    else
        distance = compareCurves(desiredPath, currentPath);
    end
end