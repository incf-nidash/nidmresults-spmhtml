%==========================================================================
% Return the value of the provided field i.e. returns the value of the 
% 'x_value' field if it exists or returns the input.
%
% value - value taken by the input field.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function value = get_value(value)
    if isstruct(value)
        value = value.('x_value');
    end
end