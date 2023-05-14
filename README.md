## Structural FEA in Matlab
Using MATLAB, finite element analysis is performed on mechanical structures under loading.

### Stepped Shaft under Axial Loading
In the _FEA_stepped_shaft.m_ script, a shaft of non-uniform diameter experiences loading along its longitudinal axis. Modeled using its stiffness matrix to analyze stress, strain, and displacement of each shaft section are obtained.

### Deformation of a Truss Structure
In the _FEA_truss_deformation.m_ script, a truss structure with two fixed supports experiences external loading on one of its free pin joints. Similar to the stepped shaft, the stiffness matrix of each element is assembled and boundaries conditions are applied. Stress, strain, and the safety factor given the material's yield strength are obtained.

## On FEA
Domains with irregular geometry, complicated boundary conditions, or non-uniform material properties can be discretized into finite elements for easier analysis. A solution for the partial differential equation of each element can be approximated. When individual solutions of all elements are assembled while ensuring continuity with the elements' boundaries conditions, the complete solution can be generated.

## Remarks
Project description, as well as a short report on methodology and conclusions can be found in the included PDFs.

Completed in Fall 2022 as a course project for MTE 204 Numerical Methods at the University of Waterloo.
