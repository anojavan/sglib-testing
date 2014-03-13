classdef LogNormalDistribution < Distribution
    % LOGNORMALDISTRIBUTION Construct a LogNormalDistribution.
    %   OBJ=LOGNORMALDISTRIBUTION(MU,SIGMA) constructs an object
    %   returned in OBJ representing a LogNormal distribution with
    %   parameters MU and SIGMA.
    %
    % Example (<a href="matlab:run_example LogNormalDistribution">run</a>)
    %   dist = LogNormalDistribution(2,3);
    %   [var,mean,skew,kurt]=dist.moments()
    %
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
        % The parameter MU of the LogNormal(MU,sigma) distribution. MU is
        %   the location parameter.
        mu
        
        % The parameter SIGMA of the LogNormal(mu,SIGMA) distribution.
        %   SIGMA is the scale parameter.
        sigma
    end
    methods
        function obj=LogNormalDistribution(mu,sigma)
            % LOGNORMALDISTRIBUTION Construct a LogNormalDistribution.
            %   OBJ=LOGNORMALDISTRIBUTION(MU,SIGMA) constructs an object
            %   returned in OBJ representing a LogNormal distribution with
            %   parameters MU and SIGMA.
            
            
            % Default parameters
            if nargin<1
                mu=0;
            end
            if nargin<2
                sigma=1;
            end
            
            obj.mu=mu;
            obj.sigma=sigma;
        end
        
        function y=pdf(obj,x)
            % PDF Computes the probability distribution function of the LogNormal distribution.
            y=lognormal_pdf( x, obj.mu, obj.sigma );
        end
        function y=cdf(obj,x)
            % CDF Computes the cumulative distribution function of the LogNormal distribution.
            y=lognormal_cdf( x, obj.mu, obj.sigma );
        end
        function x=invcdf(obj,y)
            % INVCDF Computes the inverse CDF (or quantile) function of the LogNormal distribution.
            x=lognormal_invcdf( y, obj.mu, obj.sigma );
        end
        function [var,mean,skew,kurt]=moments(obj)
            % MOMENTS Computes the moments of the LogNormal distribution.
            [var,mean,skew,kurt]=lognormal_moments( obj.sigma, obj.sigma );
        end
        function y=stdnor(dist, x)
            % STDNOR Map normal distributed random values.
            %   Y=STDNOR(DIST, X) Map normal distributed random values X to random
            %   values Y distribution according to the probability distribution DIST.
            y=dist.invcdf( normal_cdf( x ) );
        end
        
    end
end
