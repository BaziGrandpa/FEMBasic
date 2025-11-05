function Be = voigtize_shape_gradients(dNdx)
% dMdx = voigtize_shape_gradients(dNdx)
% Convert the gradients of scalar base functions to gradients of vectorized
% shape functions in voigt notation, aka B-matrix for continuum elements.
% Inputs
% * dNdx: [dim, num] - The derivatives of the scalar shape functions. 
%         Normally for the physical coordinates,
%         but can also be used on reference coordinates. 
% Outputs
% * Be:   [k, dim * num] - The derivatives of the vectorized shape
%         functions in Voigt (strain) notation.
%         dMdx(:,i) gives the derivative of the ith shape function. 
    dim = size(dNdx, 1);
    num = size(dNdx, 2);
    if dim == 1
        k = 1;
    elseif dim == 2
        k = 3;
    elseif dim == 3
        k = 6;
    else
        error("voigtize_shape_gradients only support dims 1, 2, and 3")
    end
    % This preallocation is equivalent to zeros(k, dim*num), but supports 
    % using symbolic dNdx also
    Be = zeros(k, dim * num, "like", dNdx);
end
