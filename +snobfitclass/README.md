# SnobfitClass
Class-based wrapper for MATLAB implementation of SNOBfit optimisation algorithm,
hopefully making it easier to use for reaction optimisation experiments

The underlying files ( in +snobfcn folder ) were written by Arnold Neumaier, and can be found here:
http://www.mat.univie.ac.at/~neum/software/snobfit/

The paper describing the SNOBFit algorithm and its implementation can be found here:
http://www.mat.univie.ac.at/~neum/ms/snobfit.pdf

Some example objective functions are provided in the +objfcn folder. To use the package on a new objective function, a function file must be created in this folder that only accepts one argument, the SNOB object, and returns evaluated values of the function.

Default parameters can be defined for objective functions by editing the defaults.m method in @snobclass.

The class provides options for linking two inputs to the objective function, for instance if they are flow rates in a flow-reactor system.

There are also options for running the snobfit algorithm in soft or combination modes. Soft mode minimises an objective function that has soft constraints on it. These soft constraints must be provided in a function file in the +confcn folder, with the same name as the objective function. Combination mode runs normal snobfit on the constraint function, to find a point that satisfies these constraints, and then switches to soft SNOBFit to minimise the objective function. 
