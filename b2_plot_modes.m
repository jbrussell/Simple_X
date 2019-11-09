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

is_plot_sum = 1; % plot cumulative sum of modes?

modes_order = {'O' 'Cpx' 'Opx' 'Gt' 'Pl'}; % leave empty for automatic ordering;
%  =====================================================================  %
%                             END USER INPUT                              %
%  =====================================================================  %

%%
setup_parameters;
PROJ_path = parameters.PROJ_path;
thermo_dat = parameters.thermo_dat;

%% Load data
path2tab = [PROJ_path,thermo_dat,'_mode.tabs'];
[tab,tab_mat,mvar,nrow,dnames,titl] = load_perple_x_tab_mode(path2tab);

%% Find components that are repeated and sum them
I_modes = [3:mvar];

I_good=0; I_bad=0;
rep_count=0; icount = 0;
for ii = I_modes(1:end-1)
    icount = icount+1;
    for jj = I_modes(icount)+1:mvar
        if strcmp(dnames{1}{ii},dnames{1}{jj})
            rep_count = rep_count + 1;
            I_good(rep_count) = ii;
            I_bad(rep_count) = jj;
        end
    end
end
if I_good~=0 && I_bad~=0
    for ii = 1:length(I_good)
        tab_mat(I_good(ii),:) = nansum([tab_mat(I_good(ii),:); tab_mat(I_bad(ii),:)]);
    end
    I_modes = setdiff(I_modes,I_bad);
else
    I_modes = [3:mvar];
end

% Cumulative sum of collapsed modes
if ~isempty(modes_order)
    [~, Imode, Iorder] = intersect(dnames{1},modes_order);
    [~,Isrt] = sort(Iorder);
    I_modes = Imode(Isrt)';
end
tab_mat_sum = tab_mat;
tab_mat_sum(I_modes,:) = cumsum(tab_mat_sum(I_modes,:),'omitnan');

%% Gather modes
names={}; modes=[];
kk = 0;
T = tab_mat(1,:);
P = tab_mat(2,:)/10000;
for jj = I_modes
    if isempty( tab_mat(jj,~isnan(tab_mat(jj,:))) )
        continue
    end
    if is_plot_sum
        y = tab_mat_sum(jj,:);
    else
        y = tab_mat(jj,:);
    end
    
    % Smooth modes and replace NAN with zeros
    y(isnan(y)) = 0;
    y = smooth(y,3);
    
    kk = kk+1;
    names{kk} = dnames{1}{jj};
    modes(kk,:) = y;
end

%% PLOT
% %%
%plot inline
FS = 14;
LW = 2;
figure(3); clf;

% clrs = brewermap(length(names),'set1');
clrs = lines(length(names));
lgd={};
for jj = 1:length(names)
    plot(P,modes(jj,:),'-','color',clrs(jj,:),'linewidth',LW); hold on;
    lgd{jj} = names{jj};
end
if is_plot_sum
    ylims = [0 100];
    figname = ['b2_modes_sum.pdf'];
else
    ylims = [0 ceil(max(modes(:)))];
    figname = ['b2_modes.pdf'];
end
xlabel('P (GPa)');
ylabel('Vol. %');
xlim([min(P) max(P)])
ylim(ylims);
legend(lgd,'Location','eastoutside');
set(gca,'fontsize',FS,'linewidth',1,'TickDir','in','layer','top');
grid on;

if ~exist([PROJ_path,'figs/'])
    mkdir([PROJ_path,'figs/']);
end
save2pdf([PROJ_path,'figs/',figname],3,100);

%% Save mat file
% %%
if is_plot_sum
    matout = [PROJ_path,'matout/modes_sum.mat'];
else
    matout = [PROJ_path,'matout/modes.mat'];
end
save(matout,'names','T','P','modes');