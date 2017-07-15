# Creating Your Own SNOBFit Optimisation
**Barnaby Walker, James Bannock, Adrian Nightingale, and John de Mello**

In our article, '*Tuning Reaction Products by Constrained Optimisation*', we describe an approach to formulating chemical syntheses as soft constrained optimisations with several competing requirements on the outputs. The algorithm we used was the Stable Noisy Optimisation by Branch and Fit, or SNOBFit, algorithm proposed by [Huyer and Neumaier](https://www.mat.univie.ac.at/neum/ms/snobfit.pdf). For ease of use, we developed a MATLAB class-based wrapper for the SNOBFit [implementation provided by Huyer and Neumaier](http://www.mat.univie.ac.at/neum/software/snobfit/).

In this folder you will find tutorials on how to install our MATLAB package, how to run an standard optimisation with SNOBFit, and how to run a soft constrained optimisation.

In this tutorial we will explain how to configure your own optimsation.

## Defining Your Own Functions
Our SNOBFit interface package includes some example objective and constraint functions. However, you will more than likely want to define your own optimisation targets and constraints. To do this, you will need to write them in the form of an *objective function* and a *constraint function* (which may contain multiple constraints). These need to be written in the form of a MATLAB function, and stored in the correct folder in the code files.

### SNOBFit Package Organisation
Our SNOBFit package is organised in the following folders:

```
+snobfitclass
├── +confcn
├── +minq5
├── +objfcn
├── +snobfcn
├── @snobHandler
└── @snobclass
```

The **@snobclass** folder contains files defining the SNOBFit class, and the functions that it uses to run an optimisation, and the **@snobHandler** folder contains functions that allow the class to handle things like plotting and saving to files. As our SNOBFit interface is a wrapper around the implementation provided by Huyer and Neumaier, it uses some of the code they wrote to call the SNOBFit algorithm. The folders **+snobfcn** and **+minq5** contain the files from their original implementation.

The important folders for defining your own custom optimisation are **+objfcn** and **+confcn**. All of the *objective function* definitions are stored in **+objfcn** and all of the *constraint function* definitions are stored in **+confcn**. Once you've written your function definitions, you will need to save them to the appropriate folders.

### Writing an Objective Function

For our SNOBFit interface to use your objective function, you have to write it into a MATLAB function file with a specific format. It needs to:
* Take a SNOBFit object (an instance of the SNOBFit class) as its only argument
* Return a 1D array of objective function values evaluated at each set of parameters.

An example function from the SNOBFit package is the *hsf18* 2D surface:
```
function f = hsf18(SNOB)

    x1 = SNOB.next(:,1);      % x1 dimension
    x2 = SNOB.next(:,2);      % x2 dimension

    f = 0.01*x1.^2 + x2.^2;

end
```
In this example:
* SNOB is the SNOBFit object
* The parameter sets (experiments) to evaluate are stored as rows in the SNOB.next 2D array, where each column represents an input parameter (dimension)
* For clarity, the parameters for each dimension have been unpacked from SNOB.next and assigned to *x1* and *x2*
* The evaluated objective function values are returned as a 1D array, *f*.

### Writing a Constraint Function

Like the objective function, your constraints must be written as a MATLAB function file with a specific format:
* No matter how many constraints you have, they all go in one function file
* The function must take a SNOBFit object as its only argument
* It must return the values of all the constraint functions as one *n*-by-*m* array, where *n* is the number of experiments (rows) and *m* is the number of constraints (columns)

An example:
```
function F = hsf18(SNOB)

	x1 = SNOB.next(:,1);           % x1 dimension
	x2 = SNOB.next(:,2);           % x2 dimension

	F(:,1) = x1.*x2 - 25;          % constraint 1
	F(:,2) = x1.^2 + x2.^2 - 25;   % constraint 2

end
```
In this example:
* There are two constraints
* SNOB is the SNOBFit object
* The recommended experiments have been unpacked from the SNOB.next property as in the previous example
* Each constraint is evaluated and stored as a column in a 2D-array, *F*

### Naming Your Function Files
When you save your objective and constraint function definitions to the appropriate place you must give the files a name.

Any name you want is fine so long as the **file name is the same name as your function**. For example, both functions above need to be saved as **hsf18.m**.

You must save *objective* functions in the **+objfcn** folder and *constraint* functions in the **+confcn** folder. In this way, the function and file names for a pair of objective and constraint functions may be the same without causing any conflicts.

When you set the objective and constraint functions on your SNOBFit object you then need to give the name of the files, e.g.
```
snobfit_object.fcn = 'hsf18'      % objective function
snobfit_object.softfcn = 'hsf18'  % constraint function
```
Note: You can only assign functions in the **+objfcn** folder to *'snobfit_object.fcn'*, and similarly you can only assign functions in **+confcn** to *'snobfit_object.softfcn'* .

## Defining a Chemical Optimisation
The information above, as well as in the other tutorials, should be all that you need to define and run your own optimisation. However, doing so for a chemical synthesis requires a few more steps.

### Formulating the Chemical Optimisation
You will need to formulate the requirements of your chemical synthesis into a system of objective and constraint functions. In the previous examples we have been able to take the suggested parameters sets and directly determine the objective and constraint values using an algebraic expression.

For chemical processes, however, there is a disconnect between the input parameters (e.g. temperature, pressure, concentration) and the reaction outputs. Any quantifiable parameter in your system can be used to form an objective or constraint function. In practice this is usually an analytical result (e.g. a metric that relates to product yield or selectivity), however you could base your optimisation on other metrics such as economic factors (e.g. space-time yield or process cost) or environmental considerations (e.g. E-factor or atom efficiency of the proposed configuration).

In the previous examples the number of inputs parameters and their boundary conditions (upper and lower  limits) have been predefined. In your optimisation you will need to configure this. In principle you can have any number of input parameters (dimensions), however the more dimensions you add, the longer the optimisation will take to converge on optimal results. As a starting point, two or three dimensions is advisable. Whatever you decide, SNOBFit needs to know the number of input parameters and the range of values that each parameter may take. This can be defined as follows:

BW TO ADD.

In our article we optimised a cascadic synthesis with four competing products: X0, X1, X2, and X3. One example we reported was to minimise the amount of X3 (Objective) and keep the conversion to X1 and X2 above 90 % (Constraint 1), while achieving at least a two-fold excess of X2 relative to X1 (Constraint 2).

We translated this into:

* Objective: Minimise [X3]
* Constraint 1: ([X1] + [X2]) > 0.9
* Constraint 2: ([X1] / [X2]) < 0.5

where [X] corresponded to the mole fraction of X in the sample.

### Writing Your Chemical Optimisation Files
As discussed above, it is highly probable that you will not be evaluating your functions directly. In our case, each set of recommended points would be used as the reaction conditions for running an automated flow reactor.

This means your objective and constraint functions may need to call other functions that you have written. For us, our objective function called another function that took a set of conditions as the argument, ran those conditions on our flow reactor, and returned the mole fractions of the product at each point:
```
function f = objective(SNOB)

    flow_rate1 = SNOB.next(:,1);
    flow_rate2 = SNOB.next(:,2);
    temperature = SNOB.next(:,3);

    mole_fractions = run_reactor(flow_rate1, flow_rate2, temperature);

    X3 = mole_fractions(:,4);   % mole fraction of X3

    f = X3;

end
```

One small problem that you might encounter is that the constraint function is evaluated after the objective function. Therefore the constraint function will not have access to the values returned by our reactor in the objective function. To get around that, we made our reactor save the mole fractions to a file each time it ran, and had our constraint function read those files:
```
function F = constraint(SNOB)

    mole_fractions = read_mole_fractions();

    X1 = mole_fractions(:,1);
    X2 = mole_fractions(:,2);

    F(:,1) = X1 + X2;
    F(:,2) = X1 / X2;

end
```

### Setting The Constraints

You might notice that in the *constraint function* definitions above, there is nowhere for the values of the constraints to be set. The values of the constraints on your *constraint functions* need to be set after creating a SNOBFit object in MATLAB, before running the experiment.

To set up your SNOBFit object for the above optimisation:
```
snobfit_object = snobclass()
snobfit_object.name = 'constrained_optimisation';
snobfit_object.fcn = 'objective';
snobfit_object.softfcn = 'constraint';
snobfit.soft = true;
```

The values of the constraints are then set as *upper* and *lower* limits on each of the constraint functions:
```
snobfit_object.F_upper = [inf; 0.5];
snobfit_object.F_lower = [0.9; 0];
```
In this example:

*  *F_upper* stores the *upper limits*
*  *F_lower* stores the *lower limits*
*  Both are *1*-by-*n* arrays, where *n* is the number of constraint functions
*  The position of each value corresponds to the column the the constraint is output to *F* in, e.g. the constraint function *X1 / X2* is output to the *first column* in our function, so the lower limit of 0.9 is the *first value* in *F_lower*.

You will also need to define how soft or hard each constraint function is, using the &#963; parameter:
```
snobfit_object.sigma = [0.3; 0.3]
```
Here we have set &#963; to the same value for both constraints, but you can chose any value that seems sensible to you. One way of choosing &#963; is to define it as the maximum tolerable violation of a constraint. For our example this would mean that we could tolerate anything down to 0.6 for X1 + X2 (*F_lower* - &#963), and anything up to 0.8 for X1 / X2 (*F_upper* + &#963).

#### This should be all of the information that you need to successfully run a soft constrained optimisation using our SNOBFit interface, for a chemical synthesis. :microscope: :thumbsup:
