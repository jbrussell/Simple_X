function [] = b1_write_werami_mode( parameters,TP_file )
%WRITE_WERAMI driver

PROJ = parameters.PROJ;
thermo_dat = parameters.thermo_dat;

RUNFILE = ['b1_infile_werami_mode.txt'];

prop_num = 25; % to calculate modal distributions

%% Write file

if exist(RUNFILE,'file') == 2
    disp('File exists! Removing it now')
    com = ['rm -f',RUNFILE];
    [status,log] = system(com);
end

fid = fopen(RUNFILE,'w');

fprintf(fid,'%s\n',thermo_dat); % project name (thermodynamic data)
fprintf(fid,'4\n'); % 4: read in P-T path
fprintf(fid,'2\n'); % 2: use a predefined text file of T-P
fprintf(fid,'%s\n',TP_file); % Path to T-P text file ../PROJ_NM_Colleen_T100_1600.P1_80000/TP_HSC_70Ma_Tp1350.dat
fprintf(fid,'1\n'); % every nth plot will be plotted, enter n:
fprintf(fid,'%d\n',prop_num); % 25 - Modes of all phases 
fprintf(fid,'n\n'); % Output cumulative modes (y/n)? [!! breaks with cumulative modes]
fprintf(fid,'0\n'); % EXIT

fclose(fid);
end

