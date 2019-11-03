clear; close all;
% Plot compositions along the P-T path defined in a2 and calculated in b1.
% For the cumulative sum plotting, may need to rearrange the order of the
% components for visual purposes.
%
% Note: Perple_X sometimes lists multiple instances of the same phase
% (i.e., Cpx, Cpx) for some reason. The simplest workaround is to just
% collapse them into a single phase.
%
% JBR - 11/19

setup_parameters;
PROJ_path = parameters.PROJ_path;
thermo_dat = parameters.thermo_dat;

%% Load data
path2tab = [PROJ_path,thermo_dat,'_mode.tabs'];
[tab,tab_mat,mvar,nrow,dnames,titl] = load_perple_x_tab_mode(path2tab);

%% Sum components that are repeated
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
for ii = 1:length(I_good)
    tab_mat(I_good(ii),:) = nansum([tab_mat(I_good(ii),:); tab_mat(I_bad(ii),:)]);
end
I_modes = setdiff(I_modes,I_bad);

%% Cumulative sum
% I_modes = [5 6 7 9 3];
tab_mat_sum = tab_mat;
tab_mat_sum(I_modes,:) = cumsum(tab_mat_sum(I_modes,:),'omitnan');

%% PLOT
FS = 14;
I_x = 2;
figure(3); clf;

clrs = brewermap(length(I_modes),'set1');
ii = 0;
for jj = I_modes
    LW = 2;
    if isempty( tab_mat(jj,~isnan(tab_mat(jj,:))) )
        continue
    end
    
    % Smooth modes
    x = tab_mat(I_x,:)/10000;
    y = tab_mat(jj,:);
    y(isnan(y)) = 0;
    y = smooth(y,3);
%     y = csaps(x,y,1-1e-9,x); % Smoothing spline
%     SplineFit = fit(x', y', 'smoothingspline');
%     y = SplineFit(x);
    
    ii = ii+1;
    plot(x,y,'-','color',clrs(ii,:),'linewidth',LW); hold on;
%     plot(tab_mat(I_x,:)/10000,tab_mat(jj,:),'-','color',clrs(ii,:),'linewidth',1); hold on;
    lgd{ii} = dnames{1}{jj};
end
xlabel('P (GPa)');
ylabel('Wt. %');
xlim([min(tab_mat(I_x,:)) max(tab_mat(I_x,:))]/10000)
% ylim([0 70]);
legend(lgd,'Location','eastoutside');
% ylim([min(y(:)) max(y(:))]/10000)
set(gca,'fontsize',FS,'linewidth',1.5,'TickDir','in','layer','top');


if ~exist([PROJ_path,'figs/'])
    mkdir([PROJ_path,'figs/']);
end
% save2pdf([PROJ_path,'figs/a1_TP_',prop,'.pdf'],1,500);
save2pdf([PROJ_path,'figs/b3_modes.pdf'],3,100);

%% PLOT SUM
FS = 14;
I_x = 2;
figure(4); clf;

ii = 0;
for jj = I_modes
    LW = 2;
    if isempty( tab_mat(jj,~isnan(tab_mat(jj,:))) )
        continue
    end
    
    % Smooth modes
    x = tab_mat_sum(I_x,:)/10000;
    y = tab_mat_sum(jj,:);
    y(isnan(y)) = 0;
    y = smooth(y,3);
%     y = csaps(x,y,1-1e-9,x); % Smoothing spline
%     SplineFit = fit(x', y', 'smoothingspline');
%     y = SplineFit(x);
    
    ii = ii+1;
    plot(x,y,'-','color',clrs(ii,:),'linewidth',LW); hold on;
%     plot(tab_mat(I_x,:)/10000,tab_mat(jj,:),'-','color',clrs(ii,:),'linewidth',1); hold on;
    lgd{ii} = dnames{1}{jj};
end
xlabel('P (GPa)');
ylabel('Wt. %');
xlim([min(tab_mat(I_x,:)) max(tab_mat(I_x,:))]/10000)
ylim([0 100]);
legend(lgd,'Location','eastoutside');
% ylim([min(y(:)) max(y(:))]/10000)
set(gca,'fontsize',FS,'linewidth',1.5,'TickDir','in','layer','top');


if ~exist([PROJ_path,'figs/'])
    mkdir([PROJ_path,'figs/']);
end
% save2pdf([PROJ_path,'figs/a1_TP_',prop,'.pdf'],1,500);
save2pdf([PROJ_path,'figs/b4_modes_sum.pdf'],4,100);
