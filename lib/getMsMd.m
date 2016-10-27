function [Ms, Md] = getMsMd(units, M, DIM)
    % The below code was taken from the spm_mip_ui.m file in SPM12. 
    % Md maps various non-spatial data
    % Ms maps spatial (mm) to pixel coordinates, it must not change
    % mapping of non-spatial coordinates
    % Ms is left-multiplied to Md
    
    mipmat = char(spm_get_defaults('stats.results.mipmat'));
    load(mipmat, 'DXYZ', 'CXYZ', 'scale');
    
    if isequal(units,{'mm' 'mm' 'mm'})
        Md      = eye(4);
        Ms      = diag([scale(1:3) 1]);
    elseif isequal(units,{'mm' 'mm' ''})
        Md      = eye(4);
        Md(3,4) = -100;  % out of field of view (MNI) 
        Ms      = diag([scale(1:2) 1 1]);
    elseif isequal(units,{'mm' 'mm' 'ms'}) || isequal(units,{'mm' 'mm' 'Hz'})
        Md      = eye(4);
        Md(3,3) = 80 / (M(3,3)*DIM(3));
        Md(3,4) = -80 * M(3,4) / (M(3,3)*DIM(3));
        Ms      = diag([scale(1:2) 1 1]);
    elseif isequal(units,{'Hz' 'ms' ''})
        Md      = eye(4);
        Md(1,1) = -136 / (M(1,1)*DIM(1));
        Md(1,4) = M(1,4)*136 / (M(1,1)*DIM(1)) + 68;
        Md(2,2) = 172 / (M(2,2)*DIM(2));
        Md(2,4) = -M(2,4)*172 / (M(2,2)*DIM(2)) - 100;
        Md(3,4) = -100;
        Ms      = eye(4);
    elseif isequal(units,{'Hz' 'Hz' ''})
        Md      = eye(4);
        Md(1,1) = 136 / (M(1,1)*DIM(1));
        Md(1,4) = -M(1,4)*136 / (M(1,1)*DIM(1)) - 68;
        Md(2,2) = 172 / (M(2,2)*DIM(2));
        Md(2,4) = -M(2,4)*172 / (M(2,2)*DIM(2)) - 100;
        Md(3,4) = -100;
        Ms      = eye(4);
    elseif isequal(units,{'mm' 'mm' '%'})
        warning('Handling of data units changed: please re-estimate model.');
        units   = {'mm' 'mm' 'ms'};
        Md      = eye(4);
        Md(3,3) = 80 / (M(3,3)*DIM(3));
        Md(3,4) = -80 * M(3,4) / (M(3,3)*DIM(3));
        Ms      = diag([scale(1:2) 1 1]);
    else
        error('Unknown data units.');
    end
end
