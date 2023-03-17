clear; 
% Plot compositions along the P-T path defined in a2 and calculated in b1.
% For the cumulative sum plotting, may need to rearrange the order of the
% components for visual purposes.
%
% Note: Perple_X sometimes lists multiple instances of the same phase
% (i.e., Cpx, Cpx) for some reason. The simplest workaround is to just
% collapse them into a single phase.
%
% JBR - 11/19
%% ===================================================================== %%
%                               USER INPUT                                %
%  =====================================================================  %
% Physical property of interest
prop = 'vs';

is_plot_sum = 0; % plot cumulative sum of modes?

%  =====================================================================  %
%                             END USER INPUT                              %
%  =====================================================================  %

%%
setup_parameters;
PROJ_path = parameters.PROJ_path;
thermo_dat = parameters.thermo_dat;
age = parameters.age_Ma;
Tp = parameters.Tp_C;

%% Load data
% Load properties along path from a2
mat_in = [PROJ_path,'matout/',prop,'_TP_HSC_',num2str(age),'Ma_Tp',num2str(Tp),'.mat'];
prop_mat = load(mat_in);

% Load phase distributions from b2
if is_plot_sum
    mat_in = [PROJ_path,'matout/modes_sum.mat'];
else
    mat_in = [PROJ_path,'matout/modes.mat'];
end
mode_mat = load(mat_in);

%% Interpolate modes to same grid as property
modes_int = [];
for jj = 1:length(mode_mat.names)
    modes_int(jj,:) = interp1(mode_mat.P,mode_mat.modes(jj,:),prop_mat.P);
end
mode_mat.modes = modes_int;
mode_mat.P = prop_mat.P;
mode_mat.T = prop_mat.T;
mode_mat.depth = prop_mat.depth;

%% PLOT
% %%
%plot native
FS = 14;
LW = 2;
figure(4); clf;
set(gcf,'color','w','Position',[129 278 1079 420]);

% subplot(1,3,1)
% plot(prop_mat.T,prop_mat.depth/1000,'-k','linewidth',2); hold on;
% xlabel('T (K)');
% ylabel('Depth (km)');
% ylim([0 max(prop_mat.depth/1000)]);
% xlim([min(prop_mat.T) max(prop_mat.T)]);
% title([num2str(age),' Ma; ',num2str(Tp),' \circ','C']);
% set(gca,'fontsize',FS,'linewidth',1,'TickDir','in','YDir','reverse','Layer','top');
% grid on;

subplot(1,4,[1 2]);
path2tab = [PROJ_path,thermo_dat,'_',prop,'.tabs'];
[x,y,z,xname,yname,zname,nvar,mvar,nrow,dnames,titl] = load_perple_x_tab(path2tab);
T_perplex=x; P_perplex=y/10000; Z_perplex=z;
[C,h] = contourf(T_perplex,P_perplex,Z_perplex,50,'LineStyle','none'); hold on;
plot(prop_mat.T,prop_mat.P,'-r','linewidth',2);
xlabel('T (K)');
ylabel('P (GPa)');
xlim([min(x(:)) max(x(:))])
ylim([min(y(:)) max(y(:))]/10000)
cb = colorbar;
ylabel(cb, zname);
colormap(flip(parula))
% caxis(clims);
set(cb,'LineWidth',1,'fontsize',FS);
set(gca,'fontsize',FS,'linewidth',1,'TickDir','out','YDir','reverse');
pos = get(gca,'Position');
set(gca,'Position',[pos(1)-0.03 pos(2:4)]);

subplot(1,4,3);
plot(prop_mat.(prop),prop_mat.depth/1000,'-k','linewidth',2); hold on;
xlabel([prop,' (km/s)']);
ylabel('Depth (km)');
ylim([0 max(prop_mat.depth/1000)]);
xlim([min(prop_mat.(prop))*0.99 max(prop_mat.(prop))*1.01]);
set(gca,'fontsize',FS,'linewidth',1,'TickDir','in','YDir','reverse','Layer','top');
grid on;

subplot(1,4,4);
% clrs = brewermap(length(mode_mat.names),'set1');
clrs = lines(length(mode_mat.names));
lgd={};
for jj = 1:length(mode_mat.names)
    plot(mode_mat.modes(jj,:),mode_mat.depth/1000,'-','color',clrs(jj,:),'linewidth',LW); hold on;
    lgd{jj} = mode_mat.names{jj};
end
if is_plot_sum
    xlims = [0 100];
    figname = ['c1_',prop,'_modes_sum.pdf'];
else
    xlims = [0 ceil(max(mode_mat.modes(:)))];
    figname = ['c1_',prop,'_modes.pdf'];
end
xlabel('Vol. %');
ylim([0 max(mode_mat.depth/1000)]);
xlim(xlims);
pos3 = get(gca,'Position');
lg = legend(lgd,'Location','eastoutside');
set(gca,'Position',pos3);
xticks([0:20:100]);
set(gca,'fontsize',FS,'linewidth',1,'TickDir','in','YDir','reverse','Layer','top');
grid on;

if ~exist([PROJ_path,'figs/'])
    mkdir([PROJ_path,'figs/']);
end
save2pdf([PROJ_path,'figs/',figname],4,100);

%% Save mat file
% %%
if is_plot_sum
    matout = [PROJ_path,'matout/modes_sum.mat'];
else
    matout = [PROJ_path,'matout/modes.mat'];
end
names = mode_mat.names;
modes = mode_mat.modes;
T = mode_mat.T;
P = mode_mat.P;
depth = mode_mat.depth;
save(matout,'names','T','P','depth','modes');
