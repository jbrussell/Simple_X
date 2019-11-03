function [] = b2_write_psvdraw_mode( parameters,thermo_dat_mode )
%WRITE_PSSECT driver

Trange = parameters.Trange;
PROJ = parameters.PROJ;
thermo_dat = parameters.thermo_dat;

RUNFILE = ['b2_infile_psvdraw_mode.txt'];

%% Write file

if exist(RUNFILE,'file') == 2
    disp('File exists! Removing it now')
    com = ['rm -f',RUNFILE];
    [status,log] = system(com);
end

fid = fopen(RUNFILE,'w');

fprintf(fid,'%s\n',thermo_dat_mode);
fprintf(fid,'y\n');
fprintf(fid,'y\n');
fprintf(fid,'n\n');
fprintf(fid,'n\n');
fprintf(fid,'n\n');
fprintf(fid,'n\n');
fprintf(fid,'y\n');
fprintf(fid,'%d 250\n',Trange(1));
fprintf(fid,'0 10\n');

fclose(fid);
end

