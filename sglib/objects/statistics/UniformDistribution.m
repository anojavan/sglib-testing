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
            % DIST=UNIFORMDISTRIBUTION(A,B) constructs a distribution
            % returned in DIST representing a uniform distribution with
            % parameters A and B.
            
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
        function y=pdf(dist,x)
            % PDF compute the probability distribution function of the
            % uniform distribution.
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
        function dist=translate(dist,shift,scale)
            % TRANSLATE translates the uniform distribution DIST
            % NEW_DIST=TRANSLATE(DIST,SHIFT,SCALE) translates the uniform
            % distribution DIST in regard to parameters SHIFT and SCALE
            m=(dist.a+dist.b)/2;
            v=scale*(dist.b-dist.a)/2;
            
            dist.a=m+shift-v;
            dist.b=m+shift+v;
        end
        function new_dist=fix_moments(dist,mean,var)
            % FIX_MOMENTS Generates a new dist with specified moments.
            % NEW_DIST=FIX_MOMENTS(DIST, MEAN, VAR) computes from the
            % distribution DIST a new shifted and scaled distribution
            % NEW_DIST such that the mean and variance of NEW_DIST are
            % given by MEAN and VAR.
            [shift,scale]=fix_moments@Distribution(dist,mean,var);
            new_dist=translate(dist,shift,scale);
        end
        function new_dist=fix_bounds(dist,min,max,varargin)
            % reads the user option or return the default in varargin.
            % If DIST is an unbounded distribution the options 'q0' and or
            % 'q1' can be set. Then the Q0 quantile of the new distribution
            % will be MIN and the Q1 quantile will be MAX.
            % If these options are not set, they default to 0 and 1, which
            % means the bounds of the distribution.
            mean=moments(dist);
            [shift,scale]=fix_bounds@Distribution(dist,min,max,mean,varargin);
            new_dist=translate(dist,shift,scale);
        end
    end
end
