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

is_plot_sum = 1; % plot cumulative sum of modes?

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

%% PLOT
FS = 14;
LW = 2;
figure(4); clf;
set(gcf,'color','w','Position',[129   278   880   420]);

subplot(1,3,1)
plot(prop_mat.T,prop_mat.depth/1000,'-k','linewidth',2); hold on;
xlabel('T (K)');
ylabel('Depth (km)');
ylim([0 max(prop_mat.depth/1000)]);
xlim([min(prop_mat.T) max(prop_mat.T)]);
title([num2str(age),' Ma; ',num2str(Tp),' \circ','C']);
set(gca,'fontsize',FS,'linewidth',1,'TickDir','in','YDir','reverse','Layer','top');
grid on;

subplot(1,3,2);
plot(prop_mat.(prop),prop_mat.depth/1000,'-k','linewidth',2); hold on;
xlabel([prop,' (km/s)']);
ylim([0 max(prop_mat.depth/1000)]);
xlim([min(prop_mat.(prop))*0.99 max(prop_mat.(prop))*1.01]);
set(gca,'fontsize',FS,'linewidth',1,'TickDir','in','YDir','reverse','Layer','top');
grid on;

subplot(1,3,3);
% clrs = brewermap(length(mode_mat.names),'set1');
clrs = lines(length(mode_mat.names));
lgd={};
for jj = 1:length(mode_mat.names)
    plot(mode_mat.modes(jj,:),prop_mat.depth/1000,'-','color',clrs(jj,:),'linewidth',LW); hold on;
    lgd{jj} = mode_mat.names{jj};
end
if is_plot_sum
    xlims = [0 100];
    figname = ['c1_',prop,'_modes_sum.pdf'];
else
    xlims = [0 ceil(max(mode_mat.modes(:)))];
    figname = ['c1_',prop,'_modes.pdf'];
end
xlabel('Wt. %');
ylim([0 max(prop_mat.depth/1000)]);
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
