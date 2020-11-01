function [ delz,Te,presG,rho ] = calc_platecooling( Tp,age,spr_rate,z_max,z_plate )
% Plate Cooling from Turcotte and Schubert eq 4.130
% Assumes spreading rate of 5 cm/year by default
%
% INPUT
% Tp  : Mantle potential temperature in Kelvin 
% age : Seafloor age in Myr
% spr_rate: Spreading rate in cm/yr
% z_max: Maximum depth to outpu  in km
% z_plate: plate thickness in km (~100 km)
%
% OUTPUT
% delz  : depth in meters
% Te    : temperature in Kelvin
% presG : pressure in GPa
% rho   : density in kg/m3
% 
% JBR 10/22/20

% age = 70; % Ma
% spr_rate = 5; % cm/yr
% z_max = 400; % maximum depth in km
dist = age *spr_rate*1e4;
% Tp = 1623; % mantle potential temperature for geotherm, K

%depth sampling, m
delz = [(5000:2000:197000),(200000:5000:z_max*1000)]; 
% dk = -delz(2:length(delz))/1000; lz = length(delz);

% Tr = 1173; Pr = 0.2; %reference temperature and pressure, part of fit
% parameters for T and density calculation (Turcotte and Schubert)
grav = 9.98; kappa = 1E-6; 
rho0 = 3310; 
betaa = 6E-12;

% adiabatic T and rho increase, Turcotte and Schubert, Ch. 4-16 and 4-27
Tad = Tead(delz,Tp);
% add conductive cooling
vel = spr_rate/100/(60*60*24*365); t = dist/vel;
% Te = 273 + (Tad - 273) .* erf(delz/(2*sqrt(kappa*dist/vel)));
z_plate = z_plate*1000; % convert to meters
integr = 0;
for n = 1:100
    integr = integr + 2/(n*pi) * exp(-kappa*n^2*pi^2*t/z_plate^2)*sin(n*pi*delz/z_plate);
end
Te = 273 + (Tad - 273) .* (delz/z_plate + integr);
% Connect plate to geotherm
Te(delz>=z_plate) = Tad(delz>=z_plate);

% calculate density and pressure
rr = 1 - rho0*grav*betaa*delz;
pres = -log(rr) / betaa;
presG = pres/1E9;
rho = rho0./rr;

if 0 % plot
    % half-space cooling
    Te_hsc = 273 + (Tad - 273) .* erf(delz/(2*sqrt(kappa*t)));
    
    % Large time (t >> z_plate^2/kappa
    Te_lt = 273 + (Tad - 273) .* delz/z_plate;
    
    % First 2 terms of infinite sum
    Te_approx = 273 + (Tad - 273) .* (delz/z_plate + 2/pi*exp(-kappa*pi^2*t/z_plate^2).*sin(pi*delz/z_plate)...
                                 + 1/pi * exp(-4*kappa*pi^2*t/z_plate^2).*sin(2*pi*delz/z_plate));
    figure(1); clf;
    plot(Tad,-delz/1000,'--k'); hold on;
    plot(Te_hsc,-delz/1000,'-k','linewidth',1); hold on;
    plot(Te_lt,-delz/1000,'-g'); hold on;
    plot(Te_approx,-delz/1000,'-b','linewidth',1); hold on;
    plot(Te,-delz/1000,'-r'); hold on;
    xlim([0 max(Tad)*1.1]);
end

end

function [Tad] = Tead(delz,Tp)
% Calculates the adiabatic temperature gradient for a given Tp
cp = 1350; alv = 2.9E-5; grav = 9.98;
Tad = alv * grav * Tp * delz/cp + Tp;
end

