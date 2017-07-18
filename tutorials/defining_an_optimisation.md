# Creating Your Own SNOBFit Optimisation
**Barnaby Walker, James Bannock, Adrian Nightingale, and John de Mello**

In our article '*Tuning Reaction Products by Constrained Optimisation*' we describe a simple method for carrying out multiobjective chemical optimisations, in which a compromise must be reached between several competing properties. The optimisation is carried out by treating the problem as a "constrained optimisation", in which a lead property is minimised subject to upper and lower limits being placed on the values that the other properties may attain. The optimisation routine we use here to carry out the optimisation is "Stable Noisy Optimisation by Branch and Fit (SNOBFit)" by Huyer and Neumaier (https://www.mat.univie.ac.at/neum/ms/snobfit.pdf). For convenience, we have developed a class-based wrapper for their Matlab-based implementation of SNOBFit (http://www.mat.univie.ac.at/neum/software/snobfit/), which simplifies both the installation of SNOBFit and its use.

In this folder you will find tutorials explaining how to install our MATLAB package, how to run a standard (unconstrained) optimisation with SNOBFit, and how to run a constrained optimisation.

## Defining Your Own Functions
Our SNOBFit interface package includes some example objective and constraint functions that are commonly used for benchmarking the performance of global optimisation routines. You should first familiarise yourself with running these example functions by following the instructions in *using_snobfit.mlx*. The remainder of this document describes the procedure for defining your own objective and constraint functions.

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

The **@snobclass** folder contains files defining the SNOBFit class, and the functions that it uses to run an optimisation. The **@snobHandler** folder contains functions that allow the class to handle tasks such as plotting and saving data. As our SNOBFit interface is a wrapper around the original SNOBFit implementation provided by Huyer and Neumaier, it uses parts of their code to call the SNOBFit algorithm. The folders **+snobfcn** and **+minq5** contain files from their original implementation.

The important folders for defining your own custom optimisation are **+objfcn** and **+confcn**. *Objective function* definitions are stored in **+objfcn**, while *constraint function* definitions are stored in **+confcn**. Once you have written your function definitions (following the procedure outlined below), you will need to save them to the appropriate folders.

### Writing an Objective Function for a Mathematical Optimisation

Your objective function must:
* Take a SNOBFit object (an instance of the SNOBFit class) as its only argument
* Return a 1D array of objective function values at each set of input parameters, where each cell of the output array corresponds to the function value at a different set of reaction conditions

An example objective function from the SNOBFit package is the *hsf18* 2D surface in **+objfcn**:
```
function f = hsf18(SNOB)

    x1 = SNOB.next(:,1);      % x1 is a 1D column vector for the first input parameter
    x2 = SNOB.next(:,2);      % x2 is a 1D column vector for the second input parameter

    f = 0.01*x1.^2 + x2.^2;   % f is a 1D column vector, where the *i*th elemement f(*i*) contains the function value at (x1(*i*),x2(*i*))

end
```
In this example:
* SNOB is the SNOBFit object
* The sets of input parameter values to be tested are stored as rows in the SNOB.next 2D array
* Each column of SNOB.next represents a separate input parameter
* Since we are carrying out a 2D optimisation SNOB.next has two columns, one for each input parameter
* For clarity, the input parameters have been unpacked from SNOB.next and assigned to *x1* and *x2*
* There is a single output property *f* that we wish to minimise
* The objective function returns a 1D column vector *f*, where the *i*th elemement f(*i*) contains the function value at (x1(*i*),x2(*i*))

### Writing a Constraint Function for a Mathematical Optimisation

You will use a single constraint function to define all constraints. Your constraint function must:
* Take a SNOBFit object as its only argument
* Return the values of all the constraint functions as a single *n*-by-*m* array, where *n* is the number of experiments (rows) and *m* is the number of constraints (columns)

An example:
```
function F = hsf18(SNOB)

	x1 = SNOB.next(:,1);           % first input parameter
	x2 = SNOB.next(:,2);           % second input parameter

	F(:,1) = x1.*x2 - 25;          % first constraint
	F(:,2) = x1.^2 + x2.^2 - 25;   % second constraint

end
```
In this example:
* There are two constraints
* SNOB is the SNOBFit object
* The two input parameters have again been unpacked from SNOB.next as x1 and x2
* Each constraint is evaluated and stored as a separate column in a 2D-array, *F*

### Naming Your Function Files
When you save your objective and constraint function definitions to the appropriate place you must give the files a name.

**The objective function and the constraint function should be given the same name, but should be saved to different directories**. For example, both functions above should be saved as **hsf18.m**.

You must save *objective* functions in the **+objfcn** folder and *constraint* functions in the **+confcn** folder. In this way, the function and file names for a pair of objective and constraint functions may be the same without causing any conflicts.

When you set the objective and constraint functions on your SNOBFit object you then need to give the name of the files, e.g.
```
snobfit_object.fcn = 'hsf18'      % objective function
snobfit_object.softfcn = 'hsf18'  % constraint function
```
Note: You can only assign functions in the **+objfcn** folder to *'snobfit_object.fcn'*, and similarly you can only assign functions in **+confcn** to *'snobfit_object.softfcn'*. If you do not define the constraint function, then SNOBFit will carry out an unconstrained optimisation.

To run the optimisation, you should follow the steps described in *using_soft_snobfit.mlx*.

## Defining a Chemical (or Blackbox) Optimisation
The instructions provided above include all of the information needed to define a mathematical optimisation problem, in which the objective function and constraint functions are known algebraic functions of the input parameters. Chemical optimisation is an example of blackbox optimisation, in which we do not know the functional dependence of the output properties on the input paramaters, and we must therefore carry out an experiment to determine the output properties for a given set of input paramaters. Blackbox optimisation is handled in a slightly different manner to the above procedure.

### Formulating the Chemical Optimisation
Most chemical optimisations are examples of multiobjective optimisation problems, in which we wish to find an acceptable compromise between  several criteria, e.g. yield, side-product concentration. As described in our article '*Tuning Reaction Products by Constrained Optimisation*', this may be conveniently achieved by framing the problem as a constrained optimisation, in which we optimise a lead property subject to constraints being placed on the values that the other properties may attain. For instance, in the above case of yield and side-product concentration, we might set yield as our lead property (that we wish to maximise) while asserting that the concentration of certain unwanted side products should not exceed specified values. The lead property is handled by the objective function, while the other properties are handled by the constraint function.

To achieve this, you must write an experimental objective function that accepts the input parameters (i.e. reaction conditions such as (e.g. temperature, pressure, concentration) of the problem as its arguments. This objective function will launch an experiment under the specified conditions, and then return scalar values for the properties of interest. Typical properties might include 

You will need to formulate the requirements of your chemical synthesis into a system of objective and constraint functions. In the previous examples we have been able to take the suggested parameters sets and directly determine the objective and constraint values using an algebraic expression.

For chemical processes, however, there is a disconnect between the input parameters (e.g. temperature, pressure, concentration) and the reaction outputs. Any quantifiable parameter in your system can be used to form an objective or constraint function. In practice this is usually an analytical result (e.g. a metric that relates to product yield or selectivity), however you could base your optimisation on other metrics such as economic factors (e.g. space-time yield or process cost) or environmental considerations (e.g. E-factor or atom efficiency of the proposed configuration).

In our article we optimised a cascadic synthesis with four competing products: X0, X1, X2, and X3. One example we reported was to minimise the amount of X3 (Objective) and keep the conversion to X1 and X2 above 90 % (Constraint 1), while achieving at least a two-fold excess of X2 relative to X1 (Constraint 2).

We translated this into:

* Objective: Minimise [X3]
* Constraint 1: ([X1] + [X2]) > 0.9
* Constraint 2: ([X1] / [X2]) < 0.5

where [X] corresponded to the mole fraction of X in the sample.

### Writing Your Chemical Optimisation Files
As discussed above, it is highly probable that you will not be evaluating your functions directly. In our case, each set of recommended points would be used as the reaction conditions for running an automated flow reactor.

This means your objective and constraint functions may need to call other functions that you have written. The objective function needs to take the general form as shown below, where for example the objective is to minimise the first output property:

```
function f = my_objective_function(SNOB)

    input_parameter_1 = SNOB.next(:,1);
    input_parameter_2 = SNOB.next(:,2);

    output_properties = run_reaction(input_parameter_1, input_parameter_2);
    
    f = output_properties(:,1); 

end
```
In this example:
* *input_parameter_1* and *input_parameter_2* represent the first and second reaction parameters, respectively
* *run_reaction* is a function that takes the input parameters as an argument, performs **sequential reactions** and returns a *n*-by-*m* array of required output properties, where *n* is the number of experiments and *m* is the number of output properties
* the objective function is configured to minimise output_properties(:,1)

For us, our objective function called our flow reactor with set of conditions as the argument, ran those conditions, and returned the mole fractions of the product at each point:

```
function f = my_objective_function(SNOB)

    flow_rate1 = SNOB.next(:,1);
    flow_rate2 = SNOB.next(:,2);
    temperature = SNOB.next(:,3);

    mole_fractions = run_reactor(flow_rate1, flow_rate2, temperature);
    SNOB.valuesToPass = mole_fractions;

    X3 = mole_fractions(:,4);   % mole fraction of X3

    f = X3;

end
```

One small problem that you might encounter is that the constraint function is evaluated after the objective function. Therefore the constraint function will not have access to the values returned by our reactor in the objective function. To get around that, we included a *valuesToPass* property on the SNOBFit object to store any values you need to pass between functions. This can then be accessed by the constraint function:
```
function F = my_constraint_function(SNOB)

    mole_fractions = SNOB.valuesToPass;

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
snobfit_object.fcn = 'my_objective_function';
snobfit_object.softfcn = 'my_constraint_function';
snobfit.soft = true;
```

The values of the constraints are then set as *upper* and *lower* limits on each of the constraint functions:
```
snobfit_object.F_upper = [inf; 0.5];
snobfit_object.F_lower = [0.9; 0];
```
In this example:
*  *snobfit_object.F_upper* stores the *upper limits*
*  *snobfit_object.F_lower* stores the *lower limits*
*  Both are *1*-by-*n* arrays, where *n* is the number of constraint functions
*  The position of each value corresponds to the column the the constraint is output to *F* in, e.g. the constraint function *X1 / X2* is output to the *first column* in our function, so the lower limit of 0.9 is the *first value* in *F_lower*.

You will also need to define how soft or hard each constraint function is, using the &#963; parameter:
```
snobfit_object.sigma = [0.3; 0.3]
```
Here we have set &#963; to the same value for both constraints, but you can chose any value that seems sensible to you. One way of choosing &#963; is to define it as the maximum tolerable violation of a constraint. For our example this would mean that we could tolerate anything down to 0.6 for X1 + X2 (*F_lower* - &#963;), and anything up to 0.8 for X1 / X2 (*F_upper* + &#963;).

### Setting the Bounds

SNOBFit is a bounded optimisation algorithm, which means that it only works with limits placed on the parameters that you are varying. This makes it a good fit for chemical optimisations, which usually have limits on the ranges of reaction conditions. These may be physical limitations, for instance the boiling point of a solvent places an upper limit on the temperature of a reaction, or just the range of conditions that you think the optimum is most likely to be in.

These bounds can be set by changing properties on the SNOBFit object. For an optimisation that is changing two reaction conditions, this might be:
```
snobfit_object.x_lower = [5; 30];   % lower bounds
snobfit_object.x_upper = [25; 80];  % upper bounds
```
In this example:
* The lower bounds are set with the *x_lower* property, and the upper bounds are set with the *x_upper* property.
* The number of lower/upper bounds you declare defines the dimensionality of the optimisation, no further setup is required (with the exception defined below where input parameters are linked together).
* Both of these are *n*-by-*1* arrays where *n* is the number of reaction conditions, or dimensions, you are changing in your optimisation.
* For clarity, in the above example SNOBFit is allowed to test any value between 5 and 25 for input parameter *1* and any value between 30 and 80 for parameter *2*.
* It is important to note for your objective/constraint functions that the order that you define the bounds here correlates directly to the column in *snobfit_object.next* that the new test conditions are stored. For e.g. if parameter *2* here were reaction temperature then the next set of temperatures that SNOBFit wants to test are stored in *snobfit_object.next(:,2)*.

#### Linked Bounds

If you are using a flow reactor, two things that you often want to control are the overall flow rate of reagents and the ratio of those flow rates to each other. However, this links the flow rates together and forms a trapezoidal boundary for the reaction conditions. SNOBFit can only handle square boundaries, so the flow rate boundaries need to be transformed into a square before it can use them. A method for handling this has been included in the SNOBFit object. **Currently it only works for two reagent flow rates, and a third (optional) unlinked reaction condition**.

To use linked reaction conditions, you need to change the property on the SNOBFit object:
```
snobfit_object.linked = true
```
You can then set the bounds for the linked reaction conditions:
```
snobfit_object.xyMin = 50;      % the minimum overall flow rate
snobfit_object.xyMax = 300;     % the maximum overall flow rate

snobfit_object.minRatio = 0.5;  % the minimum ratio between the flow rates
snobfit_object.maxRatio = 2.0;  % the maximum ratio between the flow rates
```
The bounds on a third reaction condition can then also be set:
```
snobfit_object.zMin = 100;
snobfit_object.zMax = 150;
```

### Termination Criteria

The final thing that you might want to change for your own chemical optimisation is the termination criteria, or when the optimisation decides that it has finished. The options that have been incorporated into the SNOBFit object are called **'minimised'**, **'no_change'**, and **'n_runs'**. 

**The default option is 'minimised'**. This means that the optimisation will end when the best objective function value is below a threshold value, or after a maximum number of objective function evaluations. You can set this threshold, and a target minimum if known:
```
snobfit_object.termination = 'minimised';  % termination criterion
snobfit_object.fglob = 0;                  % target minimum, defaults to zero if not known
snobfit_object.threshold = 0.001;          % threshold for termination
snobfit_object.ncall = 100;                % maximum number of objective function evaluations
```

If you are running a soft constrained optimisation, there is an additional check to make sure the point(s) that satisfy the termination criterion also satisfy the constraints.

Another termination criterion is **'no_change'**. This ends the optimisation if there has been no change in the best objective function value for a set number of calls to the SNOBFit algorithm. There is a chance that this may terminate the optimisation too early, so you can also set a minimum number of objective function evaluations before checking for a change:
```
snobfit_object.termination = 'no_change'; % termination criterion
snobfit_object.ncallNoChange = 5;         % number of SNOBFit calls without a change before terminating
snobfit_object.minCalls = 50;             % minimum number of function evaluations before checking for a change
```

The final termination criterion included in the SNOBFit object is **'n_runs'**. This terminates the optimisation after a set number of evaluations of the objective function:
```
snobfit_object.termination = 'n_runs'; % termination criterion
snobfit_object.ncall = 100;            % maximum number of function evaluations
```

These termination conditions have been included in the SNOBFit object for ease of use. There may be other criteria that are more suitable to your particular use. If you want to add any conditions, you can add them to the **'+snobfitclass/@snobclass/checkTermination.m'** file.

#### This should be all of the information that you need to successfully run a soft constrained optimisation using our SNOBFit interface, for a chemical synthesis. :microscope: :thumbsup:
