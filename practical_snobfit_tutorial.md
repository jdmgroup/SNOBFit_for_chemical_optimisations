# Creating Your Own SNOBFit Optimisation
**Barnaby Walker, James Bannock, Adrian Nightingale, and John deMello**

In our article, '*Tuning Reaction Products by Constrained Optimisation*', we describe an approach to formulating chemical syntheses, with several competing requirements on the outputs, as soft constrained optimisations. The algorithm we used was the Stable Noisy Optimisation by Branch and Fit, or SNOBFit, algorithm proposed by [Huyer and Neumaier](https://www.mat.univie.ac.at/neum/ms/snobfit.pdf). For ease of use, we developed a MATLAB class-based wrapper for the SNOBFit [implementation provided by Huyer and Neumaier](http://www.mat.univie.ac.at/neum/software/snobfit/).

In this folder you will find tutorials on how to install and use our MATLAB package to run an optimisation with SNOBFit, and how to use it to run a soft constrained optimisation. In this tutorial we will explain how to define your own, custom optimsation.

## Defining Your Own Functions
Our SNOBFit interface package includes some example objective and constraint functions. However, you will more than likely want to define your own optimisation targets and constraints. To do this, you'll need to write the in the form of an objective function and constraint functions. These need to be written in the form of MATLAB function files, and stored in the correct folder in the code files.

### SNOBFit Package Organisation
Our SNOBFit package is organised in the following folders:

![snobfit folder structure](snob_folders.png)

The **@snobclass** folder contains files defining the SNOBFit class, and the functions that it uses to run optimisations, and the **@snobHandler** folder contains functions that allow the class to handle things like plotting and saving to files. As our SNOBFit interface is a wrapper around the implementation provided by Huyer and Neumaier, it uses some of the code they wrote to call the SNOBFit algorithm. The folders **+snobfcn** and **+minq5** contain the files from their original implementation.

The important folders for defining your own custom optimisation are **+objfcn** and **+confcn**. All of the objective function definitions are stored in **+objfcn** and all of the constraint function definitions are stored in **+confcn**. Once you've written your function definitions, you will need to save them to the appropriate folders.

### Writing an Objective Function

For our SNOBFit interface to use your objective function, you have to write it into a MATLAB function file with a specific format. It needs to:
* Take a SNOBFit Object as its only argument
* Unwrap the recommended points from the SNOBFit Object
* Return the value of the object function evaluated at those points as a single number or a 1D vector

An example function is:
```
function f = hsf18(SNOB)
    
    x1 = SNOB.next(:,1);
    x2 = SNOB.next(:,2);

    f = 0.01*x1.^2 + x2.^2

end
```
In this example:
* SNOB is the SNOBFit Object
* The recommended points are stored as columns in a matrix as the SNOB.next property
* The evaluated function values are returned in the 'f' variable

### Writing a Constraint Function

Like the objective function, your constraints must be written as a MATLAB function file with a specific format:
* No matter how many constraints you have, they all go in one function file
* That function must take a SNOBFit Object as its only argument
* It must unpack the recommended points from the SNOBFit Object
* It must return the values of all the constraint functions as one *n*-by-*m* matrix, where *n* is the number of recommended points and *m* is the number of constraints

An example:
```
function F = hsf18(SNOB)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);

	F(:,1) = x1.*x2 - 25;
	F(:,2) = x1.^2 + x2.^2 - 25;

end
```
In this example:
* There are two constraints in this function definition
* SNOB is the SNOBFit Object
* The recommended points are unpacked from the SNOB.next property
* Each constraint is evaluated and stored as a column in the matrix variable 'F'

### Naming Your Function Files
When you save your objective and constraint function definitions to the appropriate place you must give the files a name.

Any name you want is fine, as long as the **file name has the same name as your function**. For example, both functions above need to be saved as **hsf18.m**.

When you set the objective and constraint functions on your SNOBFit Object you then need to give the name of the files, e.g.
```
snobfit_object.fcn = 'hsf18'      % objective function
snobfit_object.softfcn = 'hsf18'  % constraint function
```

## Defining a Chemical Optimisation
The information above, as well as in the other tutorials, should be all you need to define and run your own optimisation. However, doing so for a chemical synthesis might require a few more steps.

### Formulating the Chemical Optimisation
Firstly, you will need to formulate the requirements of your chemical synthesis into a system of objective and constraint functions. In our paper we optimised a synthesis with four competing products: X0, X1, X2, and X3. One objective for us was to minimise the amount of X3 and keep the conversion to X1 and X2 above 90 %, while getting more X2 than X1.

We translated this into:
```
f = [X3]                     # objective function
F1 = 0.9 < [X1] + [X2]   # a constraint
F2 = [X1] / [X2] < 0.5   # another constraint
```

### Writing Your Chemical Optimisation Files
Another consideration is that you probably won't be evaluating your functions directly. In our case, each set of recommended points would be used as the conditions for running an automated flow reactor.

This means your objective and constraint functions may need to call other functions that you have written. For us, our objective function called another function that took a set of conditions as the argument, ran those conditions on our flow reactor, and returned the mole fractions of the product at each point:
```
function f = objective(SNOB)

    flow_rate1 = SNOB.next(:,1);
    flow_rate2 = SNOB.next(:,2);
    temperature = SNOB.next(:,3);

    mole_fractions = run_reactor(flow_rate1, flow_rate2, temperature);

    f = mole_fractions(:,4);

end
```

One small problem that you might encounter is that the constraint function is evaluated after the objective function. Therefore the constraint function will not have access to the values returned by our reactor in the objective function. To get around that, we made our reactor save the mole fractions to a file each time it ran, and had our constraint function read those files:
```
function F = constraint(SNOB)

    mole_fractions = read_mole_fractions();

    F(:,1) = mole_fractions(:,2) + mole_fractions(:,3);
    F(:,2) = mole_fractions(:,2) / mole_fractions(:,3);

end
```


#### This should be all of the information that you need to successfully run a soft constrained optimisation using our SNOBFit interface, for a chemical synthesis.