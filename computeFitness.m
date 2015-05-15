%% computeFitness.m
% Return fitness value for a linkage.
% 0 if infeasible, distance from desired path otherwise.

function [distance] = computeFitness(linkage, desiredPath)
    currentPath = getLinkageCurve(linkage);
    if length(currentPath) == 0
        distance = Inf(1);
    else
        distance = compareCurves(desiredPath, currentPath);
    end
end