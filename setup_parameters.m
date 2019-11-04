% Matlab wrapper for calculating velcity and density from Perple_X
%
% JBR: 10/31/19

addpath('./functions/');
parameters.workingDir = [pwd,'/']; % Current folder

% Project name
parameters.PROJ = 'EXAMPLE';

% Define temperature and pressure range over which to calculate
parameters.Trange = [100 1600]+273; % [K]
% Pressure range (Don't use zero! Causes code to hang)
parameters.Prange = [1 80000]; % [bar] (1 GPa = 10,000 bars)

% Define half-space cooling parameters for extracting velocities
parameters.age_Ma = 70; % [Myr] seafloor age
parameters.Tp_C = 1350; % [C] Mantle potential temperature

% Solution options
parameters.comps =    {'SIO2' 'AL2O3' 'FEO' 'MGO' 'CAO' 'NA2O'}; % Components of interest
parameters.bulk_comp = [45.18  4.42   7.63  38.96  3.41  0.40]; % Amount of each component in wt%
parameters.solution_phases = {'Opx' 'Cpx' 'O' 'Sp' 'Gt' 'Pl' 'C2/c' 'Ring'}; % Phases allowed in solution (see stx11_solution_model.dat)

% List endmember phases to exclude
parameters.exclude_endmembers = {'ky' 'cor'}; % Leave blank if don't want to exclude any (recommended to start with)

% Specify thermodynamic data and solution model (stx11 is the only one tested)
parameters.thermo_dat = 'stx11'; % just for naming purposes...
parameters.path_thermo_dat = 'stx11ver.dat'; % Stixrude & Lithgow-Bertelloni (2011)
parameters.solution_model = 'stx11_solution_model.dat'; % Stixrude & Lithgow-Bertelloni (2011)

% Perple_x advanced options file
parameters.options = 'perplex_option.dat';

%% Setup paths to binaries
parameters.resultsDir = [parameters.workingDir,'RESULTS/']; % Path to output directory
parameters.path2bin = [parameters.workingDir,'bin/']; % Path to compiled binaries
parameters.path2datafiles = [parameters.workingDir,'data_files/'];

PATH = getenv('PATH');
if isempty(strfind(PATH,parameters.path2bin))
    setenv('PATH', [parameters.path2bin,':',PATH]);
end

%% Checks
parameters.PROJ_path = [parameters.resultsDir,parameters.PROJ,'/'];
if ~exist(parameters.PROJ_path)
    mkdir(parameters.PROJ_path)
end

if length(parameters.comps) ~= length(parameters.bulk_comp)
    error('Number of components must match number of values in bulk_comp')
end