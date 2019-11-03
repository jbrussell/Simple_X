clear; close all;
% Plot physical properties output from Perple_X (a1) along a desired
% half-space cooling P-T path
%
% JBR - 11/19
%% ===================================================================== %%
%                               USER INPUT                                %
%  =====================================================================  %
% Physical property of interest
prop = 'vs';

% Define half-space cooling parameters
age = 70; % [Myr] seafloor age
Tp = 1350; % [C] Mantle potential temperature

%  =====================================================================  %
%                             END USER INPUT                              %
%  =====================================================================  %
%% Paths
setup_parameters;
PROJ_path = parameters.PROJ_path;
thermo_dat = parameters.thermo_dat;

%% Setup limits
if strcmpi(prop,'vs')
    clims = [4 5];
elseif strcmpi(prop,'vp')
    clims = [7 9];
end

%% Load data
path2tab = [PROJ_path,thermo_dat,'_',prop,'.tabs'];
[x,y,z,xname,yname,zname,nvar,mvar,nrow,dnames,titl] = load_perple_x_tab(path2tab);
T_perplex=x; P_perplex=y/10000; Z_perplex=z;

%% Calculate HSC Temperature and Pressure
[ depth_m_path,T_K_path,P_GPa_path,density_path ] = calc_HSC( Tp+273,age );

%% PLOT
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
set(cb,'LineWidth',1.5,'fontsize',FS);
set(gca,'fontsize',FS,'linewidth',1.5,'TickDir','out','YDir','reverse');


% Find property along the defined T-P path
Pind=0; Tind=0;
T=0; P=0; Z=0; depth=0;
ii = 0;
for jj = 1:length(T_K_path)
    if T_K_path(jj)<=min(T_perplex(:)) || T_K_path(jj)>=max(T_perplex(:)) || ...
            P_GPa_path(jj)<=min(P_perplex(:)) || P_GPa_path(jj)>=max(P_perplex(:))
        continue
    end
    ii = ii + 1;
    diffmat = abs( (T_K_path(ii)-T_perplex) .* (P_GPa_path(ii)-P_perplex) );
    minMatrix = min(diffmat(:));
    [Pind(ii),Tind(ii)] = find(diffmat==minMatrix);
    T(ii) = T_perplex(Pind(ii),Tind(ii));
    P(ii) = P_perplex(Pind(ii),Tind(ii));
    Z(ii) = Z_perplex(Pind(ii),Tind(ii));
    
    [~,Idepth] = min(abs(P(ii)-P_GPa_path));
    depth(ii) = depth_m_path(Idepth);
end

figure(2); clf;
set(gcf,'color','w');
subplot(1,2,1);
plot(T,depth/1000,'-k','linewidth',1); hold on;
plot(T_K_path,depth_m_path/1000,'--r','linewidth',1);
xlabel('T (K)');
ylabel('Depth (km)');
ylim([0 max(depth/1000)]);
xlim([min(T) max(T)]);
set(gca,'fontsize',FS,'linewidth',1.5,'TickDir','in','YDir','reverse');


subplot(1,2,2);
plot(Z,depth/1000,'-k','linewidth',1.5); hold on;
xlabel(zname);
% ylabel('Depth (km)');
ylim([0 max(depth/1000)]);
xlim([min(Z)*0.99 max(Z)*1.01]);
set(gca,'fontsize',FS,'linewidth',1.5,'TickDir','in','YDir','reverse');


if ~exist([PROJ_path,'figs/'])
    mkdir([PROJ_path,'figs/']);
end
% save2pdf([PROJ_path,'figs/a1_TP_',prop,'.pdf'],1,500);
export_fig(1,[PROJ_path,'figs/a1_TP_',prop,'.pdf'],'-pdf','-painters');
save2pdf([PROJ_path,'figs/a2_',prop,'_profile.pdf'],2,100);

%% Save T-P path in text file
filename = [PROJ_path,'TP_HSC_',num2str(age),'Ma_Tp',num2str(Tp),'.dat'];
fid = fopen(filename,'w');
for ii = 1:length(T)
    fprintf(fid,'%10f    %10f\n',T(ii),P(ii)*10000);
end
fclose(fid);
