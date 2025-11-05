# BasicFEM
The goal of the `BasicFEM` package is that it should be mostly written by 
students in the FEM Basics course (VSM167) in the structural engineering
master program at Chalmers University of Technology.

## Using the package
In order to use the package, add `src` (including subfolders) to the MATLAB 
path. To get an overview of the functionality, run `help BasicFEM` in the
Command Window when `BasicFEM` is your current folder in MATLAB.

## Folder organization
The project is organized in 3 top level folders,

* `src`: The source file directory - this should only include function
  files. These should have documentation, and you will be instructured 
  which files to add or modify. Most files are already included but are 
  missing the implementation. 
* `homework`: In this folder, you should keep the scripts and functions for 
  solving the smaller homework problems that are in addition to the 
  computer assignments
* `assignments`: This folder contains your solution to the graded computer 
  assignments that you will work with during the course. All code, except 
  what is included in the `BasicFEM/src`, required to produce the results
  for the assignment should be put in the specific assignment folder, CA1 
  or CA2. Furthermore, the following subfolders in each assignment,
  - `inputdata`: All provided and generated input data files (e.g. meshes)
  - `resultfiles`: Save all results (e.g. images or data files) in this folder.
