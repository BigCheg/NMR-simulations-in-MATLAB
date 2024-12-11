# NMR-simulations-in-MATLAB

Discord: cheggers if you have questions or want to help

NMR script written in MATLAB that allows for the simulation of 1D and 2D solid state NMR spectra and their comparison to experimental data.
https://youtu.be/LCmeRfi5W6o?si=9wYge6fHUQQcKN5Q   Video example of how the code funtions. The input options may become outdated with time.

Install Requirements:
MATLAB (Using R2023a currently)
SIMPSON (available at https://inano.au.dk/about/research-centers-and-projects/nmr/software/simpson)

Installed MATLAB add-ons:
Communications Toolbox v8
Curve Fitting Toolbox v 3.9
DSP System Toolbox v 9.16
Industrial Communication Toolbox v 6.2
MATLAB Coder v 5.6
MATLAB Compiler v 8.6
Natual-Order Filename Sort v 3.3.0
Optimization Toolboc v 9.2
Signal Processing Toolbox v 9.2
Simulink v 10.7
Statistics and Machine Learning Toolboc v 12.5
Symbolic Math Toolbox v 9.3
WLAN Toolbox v 3.6

Files:
Cleanup.m - a script to close and and clear all windows and variables
CSAC.m - a script for processing experimental R16_3_2 data (or other CSA recovery techniques where the output spectra is symetrical)
EasyPantheon.m - A simpler version of the main script that functions with popup boxes to make the script simpler to use.
Pantheon.m - The main script that is being worked on. Allows for the simulation of NMR 2D and 1D spectra and the comparison to experimental data. The end goal is for this to be able to work for any given pulse program. The current forcus of the work of this improvement project. 
PantheonClean.m - A working "clean" backup of the script that changes can be measured against. 
QuickPlot.m - A script for plotting pre-processed data. Mostly used when wanting to change the contour levels or colours.
Slice_compare.m - Very similar to above but for comparing specific cross sections between already processed data.
testing_continuity.m - An edited version of PantheonClean used for testing.

CSACFunctions & Functions folders - Folders containing functions that CSAC and Pantheon use to function. There are likely unused ones in here that need to be identified and removed.

C313.in & SC212.in & R16_3_2.in - These are ".in" files that are used by SIMPSON to run the initial 1D simulation

csatest.xlsx - Excel sheet used to input test data that will be simulated. ISO CSA Aysm in that order. 
GettingSpinSpeedToWp.xlsx.xlsx -  Excel sheet used to calculated converison between spinning speed of a rotor and the weighted values required for the simulated data to give the best approximation. 
