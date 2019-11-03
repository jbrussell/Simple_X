% Calculate modal distributions. Must furst run a1 to calculate
% thermodynamic tables and a2 to generate textfile containing T-P path.
%
% JBR - 11/19
clear; close all;
%% ===================================================================== %%
%                               USER INPUT                                %
%  =====================================================================  %
% Define half-space cooling parameters
age = 70; % [Myr] seafloor age
Tp = 1350; % [C] Mantle potential temperature

%  =====================================================================  %
%                             END USER INPUT                              %
%  =====================================================================  %
%% ========================================================================
%  ========================================================================
setup_parameters;
PROJ_path = parameters.PROJ_path;
thermo_dat = parameters.thermo_dat;
workingDir = parameters.workingDir;

% Clear .tab files
if ~isempty(dir([PROJ_path,thermo_dat,'*.tab']))
    system(['rm ',PROJ_path,thermo_dat,'*.tab']);
end

TP_file = ['TP_HSC_',num2str(age),'Ma_Tp',num2str(Tp),'.dat'];

cd(PROJ_path)
%% b1: WERAMI - Calculate physical properties along T-P
%============== OUTPUT ==============%
%            ______1.tab             %
%            ______1.plt             %
%====================================%
% Write WERAMI driver
b1_write_werami_mode(parameters,TP_file);

% Run WERAMI
disp('Running WERAMI');
tic
com = ['cat b1_infile_werami_mode.txt | werami > werami_mode.log'];
[status,log] = system(com);
if status ~= 0     
    error( 'something went wrong in werami')
end
toc

%% b2: PSVDRAW - Plot modes of all phases
%============== OUTPUT ==============%
%            ______1.ps              %
%====================================%
% Write PSVDRAW driver
plt_fls = dir([thermo_dat,'*.plt']);
plt_fil = plt_fls(end).name(1:end-4);
b2_write_psvdraw_mode(parameters,plt_fil);

% Run PSVDRAW
disp('Running PSVDRAW');
tic
com = ['cat b2_infile_psvdraw_mode.txt | psvdraw > psvdraw_mode.log'];
[status,log] = system(com);
if status ~= 0     
    error( 'something went wrong in pssect')
end
toc

system(['cp ',plt_fil,'.tab ',plt_fil(1:end-1),'mode.tabs']);

%%
cd(workingDir)