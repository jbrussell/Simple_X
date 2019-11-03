function [zstruct,z,mvar,nrow,dnames,titl] = load_perple_x_tab_mode(data_file)
%
% % JBR: This version is for loading tab files for plotting modes
%
% MatLab script to read Perple_X tab files see:
%    perplex.ethz.ch/faq/Perple_X_tab_file_format.txt
% for format details.

% JADC March 26, 2011

% modified to allow arbitrary plotting of 3d data, requires spread sheet
% format. Old version is function_to_get_perple_x_file.

% JADC April 27, 2013

% if nvar = 2: a 2d table at evenly spaced increments of x & y the
% numbers of x-nodes and y-nodes are inc(1) and inc(2) and on return
% a(inc(2),inc(1)) is an arrary containing the value of a dependent
% property selected in this function by the user

% if nvar = 1: assumes a 1d table with nrow arbitrarily spaced rows
% consisting of mvar (>1) properties. nrow is computed by dividing the size
% of the data array a by mvar. This format requires reduntant information
% if the table is regularly spaced.

% see get_perple_x_file_with_regular_1d_grid for a mode efficient data
% format.
    
fid = fopen(data_file, 'rt');

fmt = fgetl(fid); % read revision tag

if strcmp(fmt,'|6.6.6')     % valid revision

    ok = 1;

    titl  = fgetl(fid); % title
    nvar  = fscanf(fid, '%f', 1); % number of independent variables

    for i = 1:nvar                % independent variables
                                  % the problem with using fscanf here
                                  % is that an error will result if the
                                  % variable name exceeds the length
                                  % specified by the format, there's
                                  % gotta be a better way to do this.
        vname(i,:) = fscanf(fid, '%9c', 1);
        vmin(i)    = fscanf(fid, '%f', 1);
        dv(i)      = fscanf(fid, '%f', 1);
        inc(i)     = fscanf(fid, '%f', 1);
%         v(i,1:inc(i))   = vmin(i):dv(i):vmin(i)+(inc(i)-1)*dv(i);
    end

    mvar  = fscanf(fid, '%f', 1); % number of dependent variables
    dnames = textscan(fid,'%s',mvar); % dependent variable names

    fclose(fid);

    a = textread(data_file, '%f','headerlines',4*(nvar+1)+1); % read the numeric data

    [m, n] = size(a); nrow = m*n/mvar;
    z = reshape(a,mvar,nrow);
    
    for ii = 1:mvar
        var = dnames{1}{ii};
        var(regexp(var,'[()/]'))=[];
        zstruct.(var) = z(ii,:);
    end

else

    error('Invalid file format');

end
   
end