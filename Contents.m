% BasicFEM - Finite Element Package for learning FEM Basics
% Version 0.1.0 15-Oct-2025
%
% Tensor operations (provided)
%   tovoigt                 - Convert a tensor to Voigt notation
%   tovoigt_strain          - Convert a strain tensor to Voigt notation
%   fromvoigt               - Convert a Voigt vector/matrix to a tensor
%   fromvoigt_strain        - Convert a strain Voigt vector/matrix to a tensor
%   symmetrize              - Symmetrize a tensor
% 
% Mesh routines (provided)
%   generate_mesh           - Generate a mesh for a line, rectangle, or box
%   read_mesh               - Read a mesh from an Abaqus `.inp` file
%   get_element_coordinates - Get the coordinates for each element to simplify plotting
%   plot_fe_mesh            - Plot the mesh including node and element numbers
%
% Shape functions on different reference shapes
% * Line
%   linear_line_reference_shape_values               - N(xi) for "LinearLine"
%   linear_line_reference_shape_gradients            - dN/dxi for "LinearLine"
%   quadratic_line_reference_shape_values            - N(xi) for "QuadraticLine"
%   quadratic_line_reference_shape_gradients         - dN/dxi for "QuadraticLine"
% * Triangle
%   linear_triangle_reference_shape_values           - N(xi) for "LinearTriangle"
%   linear_triangle_reference_shape_gradients        - dN/dxi for "LinearTriangle"
% * Quadrilateral
%   bilinear_quadrilateral_reference_shape_values    - N(xi) for "BilinearQuadrilateral"
%   bilinear_quadrilateral_reference_shape_gradients - dN/dxi for "BilinearQuadrilateral"
% 
% Parametric element mapping
%   calculate_jacobian                  - Calculate the Jacobian of the mapping from the 
%                                         reference to the physical domain.
% 
% Numerical integration: Quadrature
%   line_quadrature                     - Quadrature weights and points on the reference line
%   triangle_quadrature                 - Quadrature weights and points on the reference triangle
%   quadrilateral_quadrature            - Quadrature weights and points on the reference quadrilateral
%   triangle_facet_coords               - Transform coordinates on facet (edge) to coordinates in triangle 
%   triangle_facet_weighted_normal      - Get n * dA on a triangle facet (edge)
%   quadrilateral_facet_coords          - Transform coordinates on facet (edge) to coordinates in quadrilateral 
%   quadrilateral_facet_weighted_normal - Get n * dA on a quadrilateral facet (edge)
% 
% Material models (constitutive models)
%   elastic_stiffness               - Isotropic elastic stiffness in Voigt notation
%   elastic_stiffness_plane_strain  - Isotropic elastic stiffness for plane strain in Voigt notation
%   elastic_stiffness_plane_stress  - Isotropic elastic stiffness for plane stress in Voigt notation
%   vonmises                        - Calculate the effective von Mises stress
% 
% Complete element routines
% * Heat equation
%   linear_line_heat_element                - Element stiffness and load for "LinearLine"
%   quadratic_line_heat_element             - Element stiffness and load for "QuadraticLine"
%   linear_triangle_heat_element            - Element stiffness and load for "LinearTriangle"
%   linear_triangle_heat_neumann            - Neumann BC contribution to "LinearTriangle"
%   linear_triangle_heat_flux               - Calculate quadrature point fluxes in "LinearTriangle"
%   bilinear_quadrilateral_heat_element     - Element stiffness and load for "BilinearQuadrilateral"
%   bilinear_quadrilateral_heat_neumann     - Neumann BC contribution to "BilinearQuadrilateral"
%   bilinear_quadrilateral_heat_flux        - Calculate quadrature point fluxes in "BilinearQuadrilateral"
% * Linear elasticity
%   linear_triangle_elastic_element         - Element stiffness and load for "LinearTriangle"
%   linear_triangle_elastic_neumann         - Neumann BC contribution to "LinearTriangle"
%   linear_triangle_elastic_stress          - Calculate quadrature point stresses in "LinearTriangle"
%   bilinear_quadrilateral_elastic_element  - Element stiffness and load for "BilinearQuadrilateral"
%   bilinear_quadrilateral_elastic_neumann  - Neumann BC contribution to "BilinearQuadrilateral"
%   bilinear_quadrilateral_elastic_stress   - Calculate quadrature point stresses in "BilinearQuadrilateral"
