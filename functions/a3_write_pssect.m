function [] = a3_write_pssect( parameters )
%WRITE_PSSECT driver

PROJ = parameters.PROJ;
thermo_dat = parameters.thermo_dat;

RUNFILE = ['a3_infile_pssect.txt'];
%% Write file

if exist(RUNFILE,'file') == 2
    disp('File exists! Removing it now')
    com = ['rm -f',RUNFILE];
    [status,log] = system(com);
end

fid = fopen(RUNFILE,'w');

fprintf(fid,'%s\n',thermo_dat);
fprintf(fid,'n\n');

fclose(fid);
end

