%% Genetic Algorithm Options
% This example shows how to create and manage options for the genetic 
% algorithm function |ga| using |gaoptimset| in the Global Optimization Toolbox.

% Online: http://www.mathworks.com/help/gads/examples/genetic-algorithm-options.html

%   Copyright 2004-2014 The MathWorks, Inc.

%% Setting Up a Problem for |ga|
desiredPath = getBSpline();
FitnessFunction = @(linkage) computeFitness(linkage, desiredPath);
numberOfVariables = 6;

% Adding Visualization
opts = gaoptimset('PlotFcns',{@gaplotbestf, @gaplotscorediversity});

opts = gaoptimset(opts, 'PopulationSize', 100, ...
    'CreationFcn', @initPopulation, ...
    'SelectionFcn', @selectiontournament, ...
    'FitnessScalingFcn', @fitnessScaling);

% Stopping Criteria
opts = gaoptimset(opts,'Generations', 20,'StallGenLimit', 20, 'TimeLimit', 30*60);

% Constraints
A = eye(6);
b = [1;1;1;1;2;pi];
lb = zeros(6,1);
lb(6) = -pi;

%% Run the |ga| solver.
[linkage,Fval,exitFlag,Output] = ga(FitnessFunction,numberOfVariables,A,b,[], ...
    [],lb,[],[],opts);

fprintf('The number of generations was : %d\n', Output.generations);
fprintf('The number of function evaluations was : %d\n', Output.funccount);
fprintf('The best function value found was : %g\n', Fval);

finalPath = getLinkageCurve(linkage);
compareCurves(desiredPath, finalPath, true);
