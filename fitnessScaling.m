%% fitnessScaling.m
% Passed in as option to genetic algorithm.
% Determines that infeasible linkages should not reproduce,
% so births should be evenly distributed among feasible linkages.

function expectation = fitnessScaling(scores, nParents)
    nTotal = length(scores);
    nInf = sum(isinf(scores));
    avgValue = (nParents / (nTotal - nInf));
    expectation = ~isinf(scores) * avgValue;
end