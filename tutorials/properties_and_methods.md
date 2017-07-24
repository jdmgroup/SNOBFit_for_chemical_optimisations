# Property and Method List for SNOBFit Object (snobfitclass)

In this document you will find a list of available properties and methods on the SNOBFit object created by snobfitclass.

## Properties

Below is a list of properties on the object. If you want to get a list of properties inside MATLAB, you can use:
```
snobfit_metadata = ?snobfitclass.snobclass;
snobfit_properties = reshape({snobfit_metadata.PropertyList.Name}, size(snobfit_metadata.PropertyList))
```

For the object, there are some properties that you can change and there are others that only the SNOBFit object can change. The properties that you can change are:

| Property Name | Description |
| --- | --- |
| name | The name that your experiment should be saved under |
| fcn | The name of the function that you want to minimise, it should return the value of your lead property |
| constraintFcn | The name of the function that calculates your constrained properties, for a constrained optimisation |
| linked | If two of your input parameters are linked, set to true if they are |
| constrained | If you are running a contrained optimisation, set to true if you are |
| continuing | If you are continuing a previous optimisation (can be inititialised by creating a SNOBFit object with the same name as a previous optimisation) |
| combo | If you are running a constrained optimisation that is initialised by running an unconstrained optimisation on the constraint functions |
| ncall | The maximum number of function evaluations to terminated the optimisation after |
| termination | The termination criteria for the optimisation, can be *n_runs* (default), *minimised*, or *no_change* |
| filepath | The path to where you want to save the optimisation results |
| x_lower | The lower bounds of your input parameters |
| x_upper | The upper bounds of your input parameters |
| xyMin | The overall minimum of two linked input parameters |
| xyMax | The overall maximum of two linked input parameters |
| minRatio | The minimum ratio between two linked input parameters |
| maxRatio | The maximum ratio between two linked input parameters |
| zMin | The minimum of an optional third input parameter when using two linked input parameters |
| zMax | The maximum of an optional third input parameter when using two linked input parameters |
| F_upper | Chosen upper limits on the constraint functions |
| F_lower | Chosen lower limits on the constraint functions |
| sigma | Symmetric gradient on the penalty function for a constrained optimisation |
| sigmaUpper | Gradient of the penalty function for violations of the upper limits of constraints |
| sigmaLower | Gradient of the penalty function for the violations of the lower limits of constraints |
| nreq | The number of points to request from the SNOBFit algorithm |
| npoint | The number of random points to initialise the optimisation with |
| p | Defines the ratio between local and global minimisers recommended by the SNOBFit algorithm (defaults to 0.4) |
| fglob | The expected function minimum for your lead property (defaults to 0) |
| threshold | The threshold from the expected function minimum under which to terminate the optimisation |
| nCallNoChange | The number of calls to the SNOBFit algorithm with no change to the best results to terminate after, use with *no_change* termination criterion |
| minCalls | The minimum number of function evaluations to run before termination, use with *no_change* termination criterion |
| repeatBest | If true, evaluates the lead property function again at the best result found during the optimisation |
| plot_delay | Delay in seconds between each function evaluation, can aid with plotting during optimisation |

The properties that only the SNOBFit object can change are:

| Property Name | Description |
| --- | --- |
| x | The values of the input parameters that have been investigated already |
| f | The values of the lead property for points that have already been evaluated |
| F | The values of the constrained properties for points that have already been evaluated |
| fm | The values of the constrained merit function for points that have already been evaluated |
| xVirt | The transformed values of input parameters, when two are linked together |
| n | The number of input parameters, the dimension of the optimisation |
| ncall0 | The number of function evaluations during the optimisation |
| status | The status of the optimisation |
| minimised | True if the optimisation has found a minimum, false if not |
| xbest | The input parameters at the best result found during the optimisation |
| fbest | The value of your lead property at the best result found during the optimisation |
| xcon | The input parameters at the best feasible result found during a constrained optimisation |
| fcon | The value of your lead property at the best feasible result found during a constrained optimisation |
| f0 | The value of your lead property at an initial feasible point, used in the constrained merit function |
| Delta | A scaling parameter used in the constrained merit function, calculated from the median difference in lead property value of an initial set of points from the value of an initial feasible point |
| next | The input parameters recommended by the latest call to the SNOBFit algorithm |
| fbestHistory | A store of the lead property value at the best result found after each call to the SNOBFit algorithm, used for *no_change* termination criterion |
| valuesToPass | A store of values to be passed between an objected function and the constraint function, can be accessed by a MATLAB function |
| trapezoid | The corners of the trapezoidal input parameter bounds defined by two linked input parameters |
| created | The date and time that the SNOBFit object was created |
| conStart | The function evaluation number that the constrained portion of a combined optimisation started at |

## Methods

Below is a list of methods and a description of what they can do. You can access most of them, but it is only advisable to call some of them yourself.

These are the methods that you may use yourself:

| Method Name | Description |
| --- | --- |
| startExp | Begins the optimisation. If you have not set up your optimisation properly, it will throw errors saying what you have forgotten to do |
| saveExp | Saves the results and a summary of your optimistion |
| plotBounds | Plots an outline of the input parameter bounds |

These are the methods that the *startExp* method calls, and that you should avoid calling directly yourself:

| Method Name | Description |
| --- | --- |
| runsnob | Runs an unconstrained SNOBFit optimisation |
| runconstrained | Runs a constrained SNOBFit optimisation |
| runcombo | Runs a combined SNOBFit optimisation - a constrained optimisation initialised by an unconstrained optimisation of the constrained properties |
| defaults | Sets default values for SNOBFit object properties when a particular function name is set. |