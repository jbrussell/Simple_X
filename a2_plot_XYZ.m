clear; close all;
% Plot physical properties output from Perple_X (a1) along a desired
% half-space cooling P-T path and it to text file for input for b1.
%
% JBR - 11/19
%% ===================================================================== %%
%                               USER INPUT                                %
%  =====================================================================  %
% Physical property of interest
prop = 'vs';

%  =====================================================================  %
%                             END USER INPUT                              %
%  =====================================================================  %
%% Paths
setup_parameters;
PROJ_path = parameters.PROJ_path;
thermo_dat = parameters.thermo_dat;
age = parameters.age_Ma;
Tp = parameters.Tp_C;
z_plate = parameters.z_plate;
modeltype = parameters.modeltype;
z_max_km = parameters.z_max_km;

%% Setup limits
if strcmpi(prop,'vs')
    clims = [4 5];
elseif strcmpi(prop,'vp')
    clims = [7 9];
elseif strcmpi(prop,'rho')
    clims = [3000 4600];
end

%% Load data
path2tab = [PROJ_path,thermo_dat,'_',prop,'.tabs'];
[x,y,z,xname,yname,zname,nvar,mvar,nrow,dnames,titl] = load_perple_x_tab(path2tab);
T_perplex=x; P_perplex=y/10000; Z_perplex=z;

%% Calculate HSC Temperature and Pressure
vel_spread_cmyr = 5; % [cm/yr] spreading rate
if strcmpi(modeltype,'hsc')
    [ depth_m_path,T_K_path,P_GPa_path,density_path ] = calc_HSC( Tp+273,age,vel_spread_cmyr,z_max_km );
elseif strcmpi(modeltype,'plate')
    [ depth_m_path,T_K_path,P_GPa_path,density_path ] = calc_platecooling( Tp+273,age,vel_spread_cmyr,z_max_km,z_plate );
end

%% PLOT
% %%
%plot inline
FS = 14;
figure(1); clf;
set(gcf,'color','w');
[C,h] = contourf(T_perplex,P_perplex,Z_perplex,50,'LineStyle','none'); hold on;
plot(T_K_path,P_GPa_path,'-r','linewidth',2);
xlabel('T (K)');
ylabel('P (GPa)');
xlim([min(x(:)) max(x(:))])
ylim([min(y(:)) max(y(:))]/10000)
cb = colorbar;
ylabel(cb, zname);
colormap(flip(parula))
caxis(clims);
set(cb,'LineWidth',1,'fontsize',FS);
set(gca,'fontsize',FS,'linewidth',1,'TickDir','out','YDir','reverse');


% Extract property along the defined T-P path
[ P,T,Z,depth ] = extract_PTpath( P_GPa_path,T_K_path,depth_m_path,P_perplex,T_perplex,Z_perplex );

% %%
%plot inline
figure(2); clf;
set(gcf,'color','w');
subplot(1,2,1);
plot(T,depth/1000,'-r','linewidth',2); hold on;
xlabel('T (K)');
ylabel('Depth (km)');
ylim([0 max(depth/1000)]);
xlim([min(T) max(T)]);
title([num2str(age),' Ma; ',num2str(Tp),' \circ','C']);
set(gca,'fontsize',FS,'linewidth',1,'TickDir','in','YDir','reverse');
grid on;

subplot(1,2,2);
plot(Z,depth/1000,'-k','linewidth',2); hold on;
xlabel(zname);
ylim([0 max(depth/1000)]);
xlim([min(Z)*0.99 max(Z)*1.01]);
set(gca,'fontsize',FS,'linewidth',1,'TickDir','in','YDir','reverse');
grid on;

if ~exist([PROJ_path,'figs/'])
    mkdir([PROJ_path,'figs/']);
end
export_fig(1,[PROJ_path,'figs/a2_TP_',prop,'.pdf'],'-pdf','-painters');
save2pdf([PROJ_path,'figs/a2_',prop,'_profile_',num2str(age),'Ma.pdf'],2,100);

%% Save T-P path in text file
% %%
filename = [PROJ_path,'TP_HSC_',num2str(age),'Ma_Tp',num2str(Tp),'.dat'];
fid = fopen(filename,'w');
for ii = 1:length(T)
    fprintf(fid,'%10f    %10f\n',T(ii),P(ii)*10000);
end
fclose(fid);

%% Save mat file
% %%
if ~exist([PROJ_path,'matout/'])
    mkdir([PROJ_path,'matout/']);
end
if strcmpi(prop,'vp')
    vp = Z;
elseif strcmpi(prop,'vs')
    vs = Z;
elseif strcmpi(prop,'rho')
    rho = Z;
end
matout = [PROJ_path,'matout/',prop,'_TP_',modeltype,'_',num2str(age),'Ma_Tp',num2str(Tp),'.mat'];
save(matout,'T','P',lower(prop),'depth');
