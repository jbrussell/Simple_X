clear; close all;
% Run Perple_X codes to calculate desired properties (Vp, Vs, Density) for
% temperature and pressure ranges and components defined in
% in the setup_parameters.m file. The phase diagram is also output as a .ps
% file in the project directory.
%
% NOTES: 
%   - Calculation of (vp, vs, density) only requires rerunning WERAMI
%   once the phase diagram has already been computed by VERTEX
%   - If sharp discontinuities due to artifacts occur in the velocities, try increasing
%   x_nodes and y_nodes (both default: 40 40) in the perplex_option.dat file.
%
% JBR - 11/19
%% ===================================================================== %%
%                               USER INPUT                                %
%  =====================================================================  %

% Desired physical properties
props = {'vs','vp'}; % vp, vs, rho

% Recalculate phase diagram? This can be set to 0 until want to overwrite
% previous results
is_recalc_phase = 0;

%  =====================================================================  %
%                             END USER INPUT                              %
%  =====================================================================  %
%% Setup paths
setup_parameters;
PROJ_path = parameters.PROJ_path;
path2datafiles = parameters.path2datafiles;
workingDir = parameters.workingDir;
thermo_dat = parameters.thermo_dat;
path_thermo_dat = parameters.path_thermo_dat;
solution_model = parameters.solution_model;
options = parameters.options;

% Clear all PROJ_pathect files in current folder
if ~isempty(dir([PROJ_path,thermo_dat,'*'])) && is_recalc_phase 
    system(['rm ',PROJ_path,thermo_dat,'*']);
end

%% Copy files to project folder
% Copy data files to project folder
system(['cp ',path2datafiles,path_thermo_dat,' ',PROJ_path]);
system(['cp ',path2datafiles,solution_model,' ',PROJ_path]);
system(['cp ',options,' ',PROJ_path]);
system(['cp setup_parameters.m ',PROJ_path]);

% Check for blk file. If does not exist, must recalculate
if isempty(dir([PROJ_path,thermo_dat,'*.blk'])) && is_recalc_phase==0
    is_recalc_phase = 1;
end

%% Run Perple_X
cd(PROJ_path);
if is_recalc_phase 
    %% a1: BUILD - Setting up the thermodynamic problem
    %========== OUTPUT ===========%
    %        _____.dat       %
    %=============================%
    % Write BUILD driver
    a1_write_build_stx11(parameters);

    % Run BUILD
    disp('Running BUILD');
    tic
    com = ['cat a1_infile_build.txt | build > build.log'];
    [status,log] = system(com);
    if status ~= 0     
        error( 'something went wrong in build')
    end
    toc

    %% a2: VERTEX - Computing the phase diagram
    %============== OUTPUT ==============%
    %        ______auto_refine.txt       %
    %        _____.tof                   %
    %        _____.arf                   %
    %        _____.plt                   %
    %        _____.blk                   %
    %====================================%
    % Write VERTEX driver
    a2_write_vertex(parameters);

    % Run VERTEX
    disp('Running VERTEX');
    tic
    com = ['cat a2_infile_vertex.txt | vertex > vertex.log'];
    [status,log] = system(com);
    if status ~= 0     
        error( 'something went wrong in vertex')
    end
    toc

    %% a3: PSSECT - Plot phase diagram to .ps
    %============== OUTPUT ==============%
    %              _____.ps              %
    %====================================%
    % Write PSSECT driver
    a3_write_pssect(parameters);

    % Run PSSECT
    disp('Running PSSECT');
    tic
    com = ['cat a3_infile_pssect.txt | pssect > pssect.log'];
    [status,log] = system(com);
    if status ~= 0     
        error( 'something went wrong in pssect')
    end
    toc
    
end
%% a4: WERAMI - Calculate physical properties
%============== OUTPUT ==============%
%            ______1.tab             %
%====================================%
for iprop = 1:length(props)
    prop = props{iprop};
    
    if ~isempty(dir('*.tab'))
        system('rm *.tab');
    end
    
    % Write WERAMI driver
    a4_write_werami(parameters,prop);

    % Run WERAMI
    disp(['Running WERAMI: calculating ',prop]);
    tic
    com = ['cat a4_infile_werami.txt | werami > werami.log'];
    [status,log] = system(com);
    if status ~= 0     
        error( 'something went wrong in werami')
    end
    toc

    tab_fls = dir([thermo_dat,'*.tab']);
    tab_fil = tab_fls(end).name(1:end-4);
    system(['cp ',tab_fil,'.tab ',thermo_dat,'_',prop,'.tabs']);
end

%%
cd(workingDir)