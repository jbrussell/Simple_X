# Simple_X: A MATLAB wrapper for Perple_X
#### A simplified MATLAB wrapper around the [Perple_X](http://www.perplex.ethz.ch/) mineral physics software package for calculating phase equilibria and physical properties in the Earth.

This wrapper is extremely limited in its capabilities and was built for the specific purpose of calculating seismic velocities (Vp, Vs) and density along desired geotherms. Simply input bulk composition, components of interest (and undesired endmembers, if any), and a temperature and pressure range over which to calculate the phase diagram. A P-T path is calculated assuming half-space cooling and used to extract physical properties from 2-D grid of (P,T,Z) values.

Although Perple_X includes thermodynamic parameters and solutions from many different studies, this wrapper has only been tested using the data and solution files from [Stixrude and Lithgow-Bertelloni (2011)](https://onlinelibrary.wiley.com/doi/10.1111/j.1365-246X.2010.04890.x) ([stx11ver.dat](./data_files/stx11ver.dat), [stx11_solution_model.dat](./data_files/stx11_solution_model.dat)).

The MATALB scripts are meant to be executed in alphanumeric order:
- a1_run_Perple_X.m
- a2_plot_XYZ.m
- b1_run_Perple_X_PTmodes.m
- b2_plot_modes.m
- c1_plot_veloc_phases.m

![](./_archive/example1.png)


#### Version info
The codes were tested using Mac-OS-X 10.12.2

Data files: [Perple_X_6.8.7_data_files.zip](./_archive/Perple_X_6.8.7_data_files.zip)

Executables: [Perple_X_6.8.7_OSX_O1_optimization_Intel64_core2duo_JS_Oct_22_2019.zip](./_archive/Perple_X_6.8.7_OSX_O1_optimization_Intel64_core2duo_JS_Oct_22_2019.zip)

#### References
- Connolly JAD (1990) Multivariable phase-diagrams - an algorithm based on generalized thermodynamics. American Journal of Science 290:666-718. (Errata)

- Connolly JAD (2005) Computation of phase equilibria by linear programming: A tool for geodynamic modeling and its application to subduction zone decarbonation. Earth and Planetary Science Letters 236:524-541. (Errata)
- Connolly JAD (2009) The geodynamic equation of state: what and how. Geochemistry, Geophysics, Geosystems 10:Q10014 DOI:10.1029/2009GC002540.
- Connolly JAD, Galvez ME (2018) Electrolytic fluid speciation by Gibbs energy minimization and implications for subduction zone mass transfer. Earth and Planetary Science Letters 501:90-102 doi:10.1016/ j.epsl.2018.08.024
- Connolly JAD, Kerrick DM (1987) An algorithm and computer program for calculating composition phase diagrams. CALPHAD 11:1-55
- Connolly JAD, Petrini K (2002) An automated strategy for calculation of phase diagram sections and retrieval of rock properties as a function of physical conditions. Journal of Metamorphic Petrology 20:697-708. (Errata)
