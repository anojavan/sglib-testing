classdef Polynomial < FunctionSystem

    
    %   Aidin Nojavan
    %   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or modify it
    %   under the terms of the GNU General Public License as published by the
    %   Free Software Foundation, either version 3 of the License, or (at your
    %   option) any later version.
    %   See the GNU General Public License for more details. You should have
    %   received a copy of the GNU General Public License along with this
    %   program.  If not, see <http://www.gnu.org/licenses/>.
    methods (Abstract)
        r=recur_coeff(sys)
    end
    methods
        function y_alpha_j=evaluate(sys,xi)
            k = size(xi, 2);
            n = (0:sys.deg-1)';
            p = zeros(k,sys.deg);
            p(:,1) = 0;
            p(:,2) = 1;
            r = recur_coeff(sys);
            for d=1:sys.deg-1
                p(:,d+2) = (r(d,1) + xi' * r(d, 2)) .* p(:,d+1) - r(d,3) * p(:,d);
            end
            
            y_alpha_j = ones(k,sys.deg);
            y_alpha_j = y_alpha_j .* p(:, n(:,1)+2);
        end
        
    end
end

