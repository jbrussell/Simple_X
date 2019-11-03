function [] = a2_write_vertex( parameters )
%WRITE_VERTEX driver

PROJ = parameters.PROJ;
thermo_dat = parameters.thermo_dat;

RUNFILE = ['a2_infile_vertex.txt'];
%% Write file

if exist(RUNFILE,'file') == 2
    disp('File exists! Removing it now')
    com = ['rm -f',RUNFILE];
    [status,log] = system(com);
end

fid = fopen(RUNFILE,'w');

fprintf(fid,'%s\n',thermo_dat);

fclose(fid);
end

