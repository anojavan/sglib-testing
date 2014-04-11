classdef UniformDistribution < Distribution
    % UNIFORMDISTRIBUTION Constructs a UniformDistribution.
    %   DIST=UNIFORMDISTRIBUTION(A,B) constructs a distribution
    %   returned in DIST representing a uniform distribution with
    %   parameters A and B.
    %
    % Example (<a href="matlab:run_example UniformDistribution">run</a>)
    %   dist = LogNormalDistribution(2,3);
    %   [var,mean,skew,kurt]=dist.moments()
    %
    % See also DISTRIBUTION NORMALDISTRIBUTION BETA_PDF
    
    %   Aidin Nojavan
    %   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or
    %   modify it under the terms of the GNU General Public License as
    %   published by the Free Software Foundation, either version 3 of the
    %   License, or (at your option) any later version.
    %   See the GNU General Public License for more details. You should
    %   have received a copy of the GNU General Public License along with
    %   this program.  If not, see <http://www.gnu.org/licenses/>.
    
    properties
        % The parameter A of the Uniform(A,b) distribution.
        a
        % The parameter B of the Uniform(a,B) distribution.
        b
    end
    methods
        function dist=UniformDistribution(a,b)
            % UNIFORMDISTRIBUTION Constructs a UniformDistribution.
            %   DIST=UNIFORMDISTRIBUTION(A,B) constructs a distribution
            %   returned in DIST representing a uniform distribution with
            %   parameters A and B.
            
            % Default parameters
            if nargin<1
                a=0;
            end
            if nargin<2
                b=1;
            end
            
            dist.a=a;
            dist.b=b;
        end
        function m=mean(dist)
            % MEAN computes the mean value of the uniform distribution.
            m=mean@Distribution(dist);
        end
        function var=var(tdist)
            % VAR computes the variance of the uniform distribution.
            var=var@Distribution(tdist);
        end
        function y=pdf(dist,x)
            % PDF compute the probability distribution function of the
            %uniform distribution.
            y=uniform_pdf( x, dist.a, dist.b );
        end
        function y=cdf(dist,x)
            % CDF compute the cumulative distribution function of the
            % uniform distribution.
            y=uniform_cdf( x, dist.a, dist.b );
        end
        function x=invcdf(dist,y)
            % INVCDF compute the inverse CDF (or quantile) function of the
            % uniform distribution.
            x=uniform_invcdf( y, dist.a, dist.b );
        end
        function [var,mean,skew,kurt]=moments(dist)
            % MOMENTS compute the moments of the uniform distribution.
            [var,mean,skew,kurt]=uniform_moments( dist.a, dist.b );
        end
        function y=stdnor(dist, x)
            % STDNOR Map normal distributed random values.
            % Y=STDNOR(DIST, X) Map normal distributed random values X to
            % random values Y distribution according to the probability
            % distribution DIST.
            y=dist.invcdf( normal_cdf( x ) );
        end
        function new_dist=translate(dist,shift,scale)
            % TRANSLATE translates the uniform distribution DIST in regard
            % to parameters SHIFT and SCALE
            new_dist=UniformDistribution(0.5*(dist.a+dist.b)+shift-...
                0.5*scale,0.5*(dist.a+dist.b)+shift+0.5*scale);
        end
    end
end
