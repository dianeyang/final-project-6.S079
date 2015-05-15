%% finalProject.m
% Main program for running our final project.

% Capture desired curve from user input
fprintf('Please draw the path you want the coupler point to follow. Press ENTER when you are done drawing.\n\n');
desiredPath = getBSpline();

% Set up and run genetic algorithm
fprintf('Running the genetic algorithm...\n\n');
nGenerations = 1;
popSize = 5;
[linkage, Fval] = runGeneticAlgorithm(desiredPath, popSize, nGenerations);
fprintf('\nThe genetic algorithm has completed running.\n\n');

% Exit if the genetic algorithm somehow doesn't find any feasible solution
if isinf(Fval)
    fprintf('Unable to find feasible linkage, sorry :(\n');
    return
end

fprintf('Here is a visualization of the linkage we found.\n\n');
[finalPath, links, pins] = getLinkageCurve(linkage, true);

fprintf('Here is a comparison of the desired path and the path we found.\n\n');
compareCurves(desiredPath, finalPath, true);
pause(2);

fprintf('Saving linkage as SVG for fabrication...\n');
saveToSVG(links, pins);