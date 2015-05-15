%% runGeneticAlgorithm.m
% Sets up options and constraints for MATLAB's built-in
% genetic algorithm implementation. Runs genetic algorithm
% and gets output.

function [linkage, Fval] = runGeneticAlgorithm(desiredPath, popSize, nGenerations)
    % Setting Up a Problem for |ga|
    FitnessFunction = @(linkage) computeFitness(linkage, desiredPath);
    numberOfVariables = 6;

    % Adding Visualization
    opts = gaoptimset('PlotFcns',{@gaplotbestf, @gaplotscorediversity});

    opts = gaoptimset(opts, 'PopulationSize', popSize, ...
        'CreationFcn', @initPopulation, ...
        'SelectionFcn', @selectiontournament, ...
        'FitnessScalingFcn', @fitnessScaling);

    % Stopping Criteria
    opts = gaoptimset(opts,'Generations', nGenerations);

    % Constraints
    A = eye(6);
    b = [1;1;1;1;2;pi];
    lb = zeros(6,1);
    lb(6) = -pi;

    % Run the |ga| solver.
    [linkage,Fval,exitFlag,Output,finalPop] = ga(FitnessFunction, ...
        numberOfVariables,A,b,[],[],lb,[],[],opts);
end