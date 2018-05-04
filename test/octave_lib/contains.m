function tf = contains(s, pattern)
% This is a temporary fix as Octave does not yet
% include a contains function.
%
% Author: Tom Maullin (04/05/18)

    tf = isempty(strfind(s, pattern));

end