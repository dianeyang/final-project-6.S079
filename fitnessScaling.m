function expectation = fitnessScaling(scores, nParents)
% Overconstrained mechanisms should not reproduce
    nTotal = length(scores);
    nInf = sum(isinf(scores));
    avgValue = (nParents / (nTotal - nInf));
    expectation = ~isinf(scores) * avgValue;
end