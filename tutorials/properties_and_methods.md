# Property and Method List for SNOBFit Object (snobfitclass)

In this document you will find a list of available properties and methods of the SNOBFit object created by snobfitclass.

## Properties

Below is a list of properties of the object. To get a list of properties from the MATLAB command line, type:
```
snobfit_metadata = ?snobfitclass.snobclass;
snobfit_properties = reshape({snobfit_metadata.PropertyList.Name}, size(snobfit_metadata.PropertyList))
```

There are some properties of the SNOBFit object that you can change and others that only the object itself can change. The properties that you can change are:

| Property Name | Description |
| --- | --- |
| name | The name that your experiment should be saved under |
| fcn | The name of the function that you want to minimise, it should return the value of your lead property |
| constraintFcn | The name of the function that calculates your constrained properties; this property is required only for a constrained optimisation |
| linked | This property is mainly relevant for flow reactors, where you may need to control the relative and total flow rates of two reagent streams (see XXX). If two of your input parameters are linked, set to true |
| constrained | If you are running a contrained optimisation, set to true |
| continuing | If you are continuing a previous optimisation (can be inititialised by creating a SNOBFit object with the same name as a previous optimisation) |
| combo | If you are running a constrained optimisation, in which you first search for a feasible point by minimising the penalty function P calculated from the constraint functions (can by initialised by XXX) |
| ncall | The maximum number of function evaluations before termination |
| termination | The termination criteria for the optimisation, can be set to *n_runs* (default), *minimised*, or *no_change* |
| filepath | The file path that specifies where the optimisation results will be saved |
| x_lower | The lower bounds on your input parameters |
| x_upper | The upper bounds on your input parameters |
| xyMin | The overall minimum of two linked input parameters |
| xyMax | The overall maximum of two linked input parameters |
| minRatio | The minimum ratio between two linked input parameters |
| maxRatio | The maximum ratio between two linked input parameters |
| zMin | The minimum of an optional third input parameter when using two linked input parameters |
| zMax | The maximum of an optional third input parameter when using two linked input parameters |
| F_upper | Upper limits on the constrained properties |
| F_lower | Lower limits on the constraint properties |
| sigma | Maximum permitted deviations from preferred upper and lower bounds of properties |
| sigmaUpper | Maximum permitted deviations from preferred upper bounds of properties |
| sigmaLower | Maximum permitted deviation from preferred lower bounds of properties |
| nreq | The number of points to request from the SNOBFit algorithm |
| npoint | The number of random points used to initialise the optimisation |
| p | Defines the ratio between local and global minimisers recommended by the SNOBFit algorithm (defaults to 0.4) |
| fglob | The expected function minimum for your lead property (defaults to 0) |
| threshold | The threshold from the expected function minimum. The optimisation will terminate when the function value is smaller than fglob + threshold |
| nCallNoChange | The SNOBFit algorithm if nCallNoChange successive function evaluations lead to no reduction in the lowest function value , use with *no_change* termination criterion |
| minCalls | The minimum number of function evaluations to run before termination, use with *no_change* termination criterion |
| repeatBest | If true, re-evaluates the lead property function at the best point (xbest) at the end of the optimisation |
| plot_delay | Delay in seconds between each function evaluation, can aid with plotting during optimisation |

The properties that only the SNOBFit object can change are:

| Property Name | Description |
| --- | --- |
| x | The values of the input parameters that have been investigated already |
| f | The values of the lead property for points that have already been evaluated |
| F | The values of the constrained properties for points that have already been evaluated |
| fm | The values of the constrained merit function for points that have already been evaluated |
| xVirt | The transformed values of input parameters, when two input parameters are linked together |
| n | The number of input parameters, the dimension of the optimisation |
| ncall0 | The number of function evaluations during the optimisation |
| status | The status of the optimisation |
| minimised | True if the optimisation has found a minimum, false if not |
| xbest | The input parameters at the best result found during the optimisation |
| fbest | The value of your lead property at the best result found during the optimisation |
| xcon | The input parameters at the best feasible result found during a constrained optimisation |
| fcon | The value of your lead property at the best feasible result found during a constrained optimisation |
| f0 | The value of your lead property at an initial feasible point, used in the constrained merit function |
| Delta | A scaling parameter used in the constrained merit function (see our article or original SNOBFit paper) |
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
