function [z_mat] = invert_P_rho_for_depth(P_GPa,rho_kgm3,T_K)

% Invert PERPLEX density and pressure for depth

P_Pa = P_GPa(:,1) * 1e9;
T = T_K(1,:);
NP = length(P_Pa);
NT = length(T);

grav = 10; % m/s^2

% Build G matrix and solve the exactly-determined (N = M) inverse problem
z_mat = zeros(NP,NT);
for iT = 1:NT
    G = zeros(NP,NP);
    for iP = 1:NP
        G(iP:NP,iP) = grav * rho_kgm3(iP,iT);
    end
%     dz = (G'*G)\G'*P_Pa;
    dz = G \ P_Pa; % can do direct solution for dz since G is square and invertable
    z_mat(:,iT) = cumsum(dz);
end

end

