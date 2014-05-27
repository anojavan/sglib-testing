classdef PolynomialSystem < FunctionSystem
    % POLYNOMIALSYSTEM abstract base class for polynomial basis functions
    %
    % See also HERMITEPOLYNOMIALS LEGENDREPOLYNOMIALS
    
    
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
        r=recur_coeff(sys,p)
        % RECUR_COEFF Compute recurrence coefficient of polynomials of the
        % basis function
        % R = RECUR_COEFF(SYS,P) computes the recurrence coefficients for
        % the system of orthogonal polynomials SYS of order P. 
        % References:
        %   [1] Abramowitz & Stegun: Handbook of Mathematical Functions
        %   [2] http://dlmf.nist.gov/18.9
    end
    methods
        function y_alpha_j=evaluate(sys,p,xi)
            % EVALUATE Evaluates the basis functions at given points.
            % Y_ALPHA_J = EVALUATE(SYS, XI) evaluates the basis function
            % specified by SYS at the points specified by XI. If there
            % are M basis functions and XI is 1 x N matrix, where N is
            % the number of evaulation points, then the returned matrix Y
            % is of size N x M such that Y(j,I) is the I-th basis function
            % evaluated at point XI(J).
            k = size(xi, 2);
            n = (0:p-1)';
            y_alpha = zeros(k,p);
            y_alpha(:,1) = 0;
            y_alpha(:,2) = 1;
            r = recur_coeff(sys,p);
            for d=1:p-1
                y_alpha(:,d+2) = (r(d,1) + xi' * r(d, 2)) .* y_alpha(:,d+1) - r(d,3) * y_alpha(:,d);
            end
            y_alpha_j = y_alpha(:, n(:,1)+2);
        end
        
    end
end

