function [ P,T,Z,depth ] = extract_PTpath( P_path,T_path,dep_path,Pmat,Tmat,Zmat )
% Extract physical properties along geotherm from perple_x matrix
%
% INPUT
% P_path : [GPa] pressure along geotherm
% T_path : [K] temperature along geotherm
% dep_path : [m] depth along geotherm
% Pmat : [GPa] pressure calculated by perple_x
% Tmat : [K] temperature calculated by perple_x
% Zmat : [km/s, kg/m3] velocity,density calculated by perple_x
%
% OUTPUT
% P : [GPa] pressure extracted from perple_x
% T : [K] temperature extracted from perple_x
% Z : [km/s, kg/m3] velocity,density extracted from perple_x
% 
% JBR 10/24/19

% Pind=0; Tind=0;
% T=0; P=0; Z=0; depth=0;
% ii = 0;
% for jj = 1:length(T_path)
%     if T_path(jj)<=min(Tmat(:)) || T_path(jj)>=max(Tmat(:)) || ...
%             P_path(jj)<=min(Pmat(:)) || P_path(jj)>=max(Pmat(:))
%         continue
%     end
%     ii = ii + 1;
%     diffmat = abs( (T_path(ii)-Tmat) .* (P_path(ii)-Pmat) );
%     minMatrix = min(diffmat(:));
%     [Pind(ii),Tind(ii)] = find(diffmat==minMatrix);
%     T(ii) = Tmat(Pind(ii),Tind(ii));
%     P(ii) = Pmat(Pind(ii),Tind(ii));
%     Z(ii) = Zmat(Pind(ii),Tind(ii));
% 
%     [~,Idepth] = min(abs(P(ii)-P_path));
%     depth(ii) = dep_path(Idepth);
% end

Z = interp2(Pmat',Tmat',Zmat',P_path(:)+(0:length(P_path)-1)'*1e-10,T_path(:));
P = P_path;
T = T_path;
depth = dep_path;

end
