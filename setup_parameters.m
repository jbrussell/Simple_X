% Matlab wrapper for calculating velcity and density from Perple_X codes
%
% JBR: 10/31/19

addpath('./functions/');
parameters.workingDir = [pwd,'/'];
parameters.resultsDir = './RESULTS/';
parameters.path2bin = '/Users/russell/Lamont/PROJ_NoMelt_Cij/GRL_19/5_Perple_X/bin/'; % Path to compiled binaries
parameters.path2datafiles = './data_files/';

% parameters.PROJ = './PROJ_NM_Colleen/'; %'./PROJ_NM_Colleen/';
% % Define temperature and pressure range over which to calculate
% parameters.Trange = [673 1473]; % K
% % Pressure range (Don't use zero! Causes code to hang)
% parameters.Prange = [30000 80000]; % bar (1 GPa = 10,000 bars)

parameters.PROJ = 'PROJ_NM_Colleen_T100_1600.P1_80000_noky.cor_grid60/'; %'./PROJ_NM_Colleen/';
% Define temperature and pressure range over which to calculate
parameters.Trange = [100 1600]+273; % [K]
% Pressure range (Don't use zero! Causes code to hang)
parameters.Prange = [1 80000]; % [bar] (1 GPa = 10,000 bars)

% Thermodynamic data and solution model
parameters.thermo_dat = 'stx11'; % Stixrude & Lithgow-Bertelloni (2011)
parameters.path_thermo_dat = [parameters.thermo_dat,'ver.dat'];
parameters.solution_model = 'stx11_solution_model.dat';
% Options file
parameters.options = 'perplex_option.dat';

% Components of interest
parameters.comps =    {'SIO2' 'AL2O3' 'FEO' 'MGO' 'CAO' 'NA2O'};
% Amount of each component in wt%
parameters.bulk_comp = [45.18  4.42   7.63  38.96  3.41  0.40];
% Phases allowed in solution (see stx11_solution_model.dat)
parameters.solution_phases = {'Opx' 'Cpx' 'O' 'Sp' 'Gt' 'Pl' 'C2/c' 'Ring'};
% List endmember phases to exclude
parameters.exclude_endmembers = {'ky' 'cor'}; % Leave blank if don't want to exclude any (recommended to start with)

%% Setup paths to binaries
PATH = getenv('PATH');
if isempty(strfind(PATH,parameters.path2bin))
    setenv('PATH', [parameters.path2bin,':',PATH]);
end

%% Checks
parameters.PROJ_path = [parameters.resultsDir,parameters.PROJ];
if ~exist(parameters.PROJ_path)
    mkdir(parameters.PROJ_path)
end

if length(parameters.comps) ~= length(parameters.bulk_comp)
    error('Number of components must match number of values in bulk_comp')
end