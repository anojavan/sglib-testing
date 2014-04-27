classdef Chebyshev1Polynomial < Polynomial

    
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
    properties
        deg
    end
    
    methods
        function sys=Chebyshev1Polynomial(deg)

            sys.deg=deg;
        end
        function r=recur_coeff(sys)
            n = (0:sys.deg-1)';
            one = ones(size(n));
            zero = zeros(size(n));
            r = [zero, 2*one - (n==0), one];
        end
    end
end
