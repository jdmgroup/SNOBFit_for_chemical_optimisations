# SnobfitClass
Class-based wrapper for Neumaier and Huyer's MATLAB-based implementation of SNOBFit. This wrapper is designed to simplify the installation and use of SNOBFit, especially for chemical and other blackbox optimisations.

The underlying files (which may be found in the "+snobfcn" folder) were written by Arnold Neumaier, and can be found here:
http://www.mat.univie.ac.at/~neum/software/snobfit/

The paper describing the SNOBFit algorithm and its implementation can be found here:
http://www.mat.univie.ac.at/~neum/ms/snobfit.pdf

## Installation
To install the package on your computer, either clone or download this repository onto your computer.

Inside the repository, the code is written as a 'package folder' in the '+snobfitclass' folder. For ease of use we recommend you **copy  the '+snobfitclass' folder into the MATLAB folder on your computer**.

For Linux/Mac this is usually found in:
```
~/Documents/MATLAB
```
For Windows it is usually found in:
```
C:\Users\{user name}\Documents\MATLAB
```

Having saved the code into the recommended folder, you may import the contents of the package into MATLAB by typing:
```
import snobfitclass.*
```

## Using the Package

Tutorials explaining how to use the package to run unconstrained and constrained optimisations may be found in the 'tutorials' folder. Two of these are provided in the form of MATLAB live scripts. By opening the live scripts in MATLAB, you will be able to run (and edit) the code directly.
