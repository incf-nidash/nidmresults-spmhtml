function value = get_value(value)
    if isstruct(value)
        value = value.('x_value');
    end
end