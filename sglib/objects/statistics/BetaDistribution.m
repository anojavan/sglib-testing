classdef BetaDistribution < Distribution
    % BETADISTRIBUTION Construct a BetaDistribution.
    %   OBJ=BETADISTRIBUTION(A,B) constructs an object returned in
    %   OBJ representing a Beta distribution with parameters A and B.
    %
    % Example (<a href="matlab:run_example BetaDistribution">run</a>)
    %   dist = BetaDistribution(2,3);
    %   [var,mean,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION NORMALDISTRIBUTION BETA_PDF
    
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
    % The parameter A of the Beta(A,b) distribution. A is a positive
    % shape parameter, that appears as exponent of the random
    % variable and controls the shape of the distribution
        a
        
    % The parameter B of the Beta(a,B) distribution.  B is a positive
    % shape parameter, that appears as exponent of the random
    % variable and controls the shape of the distribution
        b
    end
    methods
        function obj=BetaDistribution(a,b)
    % BETADISTRIBUTION Construct a BetaDistribution.
    % OBJ=BETADISTRIBUTION(A,B) constructs an object returned in
    % OBJ representing a Beta distribution with parameters A and B.
            obj.a=a;
            obj.b=b;
        end
        
        function y=pdf(obj,x)
     % PDF Computes the probability distribution function of the Beta distribution.
            y=beta_pdf( x, obj.a, obj.b );
        end
        function y=cdf(obj,x)
     % CDF Computes the cumulative distribution function of the Beta distribution.
            y=beta_cdf( x, obj.a, obj.b );
        end
        function x=invcdf(obj,y)
     % INVCDF Computes the inverse CDF (or quantile) function of the Beta distribution.
            x=beta_invcdf( y, obj.a, obj.b );
        end
        function [var,mean,skew,kurt]=moments(obj)
     % MOMENTS Computes the moments of the Beta distribution.
            [var,mean,skew,kurt]=beta_moments( obj.a, obj.b );
        end
        function y=stdnor(dist, x)
     % STDNOR Map normal distributed random values.
     % Y=STDNOR(DIST, X) Map normal distributed random values X to random
     % values Y distribution according to the probability distribution DIST.
            y=dist.invcdf( normal_cdf( x ) );
        end
        
    end
end