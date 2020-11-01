function [ delz,Te,presG,rho ] = calc_HSC( Tp,age,spr_rate,z_max )
% HSC from Turcotte and Schubert as implimented by Faul's scripts.
% Assumes spreading rate of 5 cm/year by default
%
% INPUT
% Tp  : Mantle potential temperature in Kelvin 
% age : Seafloor age in Myr
% spr_rate: Spreading rate in cm/yr
% z_max: Maximum depth to outpu  in km
%
% OUTPUT
% delz  : depth in meters
% Te    : temperature in Kelvin
% presG : pressure in GPa
% rho   : density in kg/m3
% 
% JBR 10/24/19

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
vel = spr_rate/100/(60*60*24*365); age = (dist/vel)/(60*60*24*365*1E6);
Te = 273 + (Tad - 273) .* erf(delz/(2*sqrt(kappa*dist/vel)));
ff = find(Te+5 > Tad);

% calculate density and pressure
rr = 1 - rho0*grav*betaa*delz;
pres = -log(rr) / betaa;
presG = pres/1E9;
rho = rho0./rr;

end

function [Tad] = Tead(delz,Tp)
% Calculates the adiabatic temperature gradient for a given Tp
cp = 1350; alv = 2.9E-5; grav = 9.98;
Tad = alv * grav * Tp * delz/cp + Tp;
end

