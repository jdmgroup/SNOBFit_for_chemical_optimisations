# SnobfitClass
Class-based wrapper for MATLAB implementation of SNOBfit optimisation algorithm,
hopefully making it easier to use for reaction optimisation experiments

The underlying files ( in +snobfcn folder ) were written by Arnold Neumaier, and can be found here:
http://www.mat.univie.ac.at/~neum/software/snobfit/

The paper describing the SNOBFit algorithm and its implementation can be found here:
http://www.mat.univie.ac.at/~neum/ms/snobfit.pdf

## Installation
To install the package on your computer, either clone or download this repository onto your computer.

Inside the repository, the code is written as a 'package folder', in the '+snobfitclass' folder. To be able to use the package easily, **copy just the '+snobfitclass' folder into the MATLAB on your computer**.

For Linux/Mac this is usually found in:
```
~/Documents/MATLAB
```
For Windows this is usually:
```
C:\Users\{user name}\Documents\MATLAB
```

This will allow you to import the contents of the package in MATLAB, by typing:
```
import snobfitclass.*
```

## Using the Package

Some tutorials on how to use the package to run different optimisations can be found in the 'tutorials' folder. Two of these are in the form of MATLAB live scripts. If you open them in MATLAB you will be able to run the code inside of them as well as edit parts of the code to experiment with it.
