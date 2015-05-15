%% initPopulation.m
% Passed in as option to genetic algorithm. Randomly generate
% bar lengths and try to arrange them in feasible linkage
% according to relationships between lengths.

function population = initPopulation(GenomeLength, FitnessFcn, options)
    population = zeros(options.PopulationSize, GenomeLength);
    for i=1:options.PopulationSize
        [s, p, q, l] = generateLengths();
        if s+l > p+q % drag-link
            population(i, :) = [s q l p rand()*2 rand()*2*pi-pi];
        elseif s+l < p+q % crank-rocker
            population(i, :) = [q s p l rand()*2 rand()*2*pi-pi];
        else % parallelogram
            population(i, :) = [s q p l rand()*2 rand()*2*pi-pi];
        end
    end
end

function [s, p, q, l] = generateLengths()
    lengths = sort(rand(1, 4));
    s = lengths(1);
    q = lengths(2);
    p = lengths(3);
    l = lengths(4);
end