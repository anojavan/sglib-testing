classdef ExponentialDistribution < Distribution
    % EXPONENTIALDISTRIBUTION Constructs an ExponentialDistribution.
    %   OBJ=EXPONENTIALDISTRIBUTION(LAMBDA) constructs an object
    %   returned in OBJ representing an Exponential distribution
    %   with parameter LAMBDA.
    %
    % Example (<a href="matlab:run_example ExponentialDistribution">run</a>)
    %   dist = ExponentialDistribution(2);
    %[var,mean,skew,kurt]=dist.moments()
    % See also
    
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
        % The parameter LAMBDA of the Exponential(LAMBDA) distribution.
        %   LAMBDA is the parameter of the Exponential Distribution (rate
        %   parameter)
        lambda
    end
    methods
        function obj=ExponentialDistribution(lambda)
            % EXPONENTIALDISTRIBUTION Constructs an ExponentialDistribution.
            %   OBJ=EXPONENTIALDISTRIBUTION(LAMBDA) constructs an object
            %   returned in OBJ representing an Exponential distribution
            %   with parameter LAMBDA.
            obj.lambda=lambda;
        end
        
        function y=pdf(obj,x)
            % PDF Computes the probability distribution function of the Exponential distribution.
            y=exponential_pdf( x, obj.lambda);
        end
        function y=cdf(obj,x)
            % CDF Computes the cumulative distribution function of the Exponential distribution.
            y=exponential_cdf( x, obj.lambda);
        end
        function x=invcdf(obj,y)
            % INVCDF Computes the inverse CDF (or quantile) function of the Exponential distribution.
            x=exponential_invcdf( y, obj.lambda );
        end
        function [var,mean,skew,kurt]=moments(obj)
            % MOMENTS Computes the moments of the Exponential distribution.
            [var,mean,skew,kurt]=exponential_moments( obj.lambda);
        end
        
    end
end

