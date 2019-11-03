function [] = a1_write_build( parameters )
%WRITE_BUILD driver

PROJ = parameters.PROJ;
thermo_dat = parameters.thermo_dat;
path_thermo_dat = parameters.path_thermo_dat;
solution_model = parameters.solution_model;
options = parameters.options;
Trange = parameters.Trange; % K
Prange = parameters.Prange; % bar (1 GPa = 10,000 bars)
comps = parameters.comps;
bulk_comp = parameters.bulk_comp;
solution_phases = parameters.solution_phases;
exclude_endmembers = parameters.exclude_endmembers;

RUNFILE = ['a1_infile_build.txt'];
%% Write file

if exist(RUNFILE,'file') == 2
    disp('File exists! Removing it now')
    com = ['rm -f',RUNFILE];
    [status,log] = system(com);
end

fid = fopen(RUNFILE,'w');

fprintf(fid,'%s\n',thermo_dat);
fprintf(fid,'%s\n',path_thermo_dat);
fprintf(fid,'%s\n',options);
fprintf(fid,'n\n');
fprintf(fid,'2\n');
fprintf(fid,'n\n');
fprintf(fid,'n\n');
fprintf(fid,'n\n');
for ii = 1:length(comps)
    fprintf(fid,'%s\n',comps{ii});
end
fprintf(fid,'\n');
fprintf(fid,'5\n');
fprintf(fid,'n\n');
fprintf(fid,'2\n');
fprintf(fid,'%f %f\n',Trange(1),Trange(2));
fprintf(fid,'%f %f\n',Prange(1),Prange(2));
fprintf(fid,'y\n');
for ii = 1:length(bulk_comp)
    fprintf(fid,'%f ',bulk_comp(ii));
end
fprintf(fid,'\n');
fprintf(fid,'n\n');
if isempty(exclude_endmembers)
    fprintf(fid,'n\n');
else
    fprintf(fid,'y\n');
    fprintf(fid,'n\n');
    for ii = 1:length(exclude_endmembers)
        fprintf(fid,'%s\n',exclude_endmembers{ii});
    end
    fprintf(fid,'\n');
end
fprintf(fid,'y\n');
fprintf(fid,'%s\n',solution_model);
for ii = 1:length(solution_phases)
    fprintf(fid,'%s\n',solution_phases{ii});
end
fprintf(fid,'\n');
fprintf(fid,'Staudigel closed system model\n');

fclose(fid);
end

