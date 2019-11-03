function [] = a4_write_werami( parameters,prop )
%WRITE_WERAMI driver

PROJ = parameters.PROJ;
thermo_dat = parameters.thermo_dat;

RUNFILE = ['a4_infile_werami.txt'];

if strcmpi(prop,'rho')
    prop_num = 2;
elseif strcmpi(prop,'vp')
    prop_num = 13;
elseif strcmpi(prop,'vs')
    prop_num = 14;
else
    error('Physical property not recognized. Try vp, vs, or rho');
end
%% Write file

if exist(RUNFILE,'file') == 2
    disp('File exists! Removing it now')
    com = ['rm -f',RUNFILE];
    [status,log] = system(com);
end

fid = fopen(RUNFILE,'w');

fprintf(fid,'%s\n',thermo_dat);
fprintf(fid,'2\n');
fprintf(fid,'%d\n',prop_num); %2 - Density (kg/m3); 13 - P-wave velocity (Vp, km/s); 14 - S-wave velocity (Vs, km/s)
fprintf(fid,'n\n');
fprintf(fid,'n\n');
fprintf(fid,'0\n');
fprintf(fid,'n\n');
fprintf(fid,'4\n'); % resolution [1-4] 1=lowest 4=highest
fprintf(fid,'0\n');

fclose(fid);
end

