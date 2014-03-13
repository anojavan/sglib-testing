classdef NormalDistribution < Distribution
    % NORMALDISTRIBUTION Construct a NormalDistribution.
    %   OBJ=NORMALDISTRIBUTION(MU,SIGMA) constructs an object
    %   returned in OBJ representing a Normal distribution with
    %   parameters MU and SIGMA.
    %
    % Example (<a href="matlab:run_example NormalDistribution">run</a>)
    %   dist = LogNormalDistribution(2,3);
    %   [var,mean,skew,kurt]=dist.moments()
    %    
    
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
        % The parameter MU of the Normal(MU,sigma) distribution. MU is
        %   the mean value.
        mu
        
        % The parameter SIGMA of the Normal(mu,SIGMA) distribution. SIGMA 
        %   is the variance value.        
        sigma
    end
    
    methods
        function obj=NormalDistribution(mu,sigma)
            % NORMALDISTRIBUTION Constructs a NormalDistribution.
            %   OBJ=NORMALDISTRIBUTION(MU,SIGMA) constructs an object
            %   returned in OBJ representing a Normal distribution with
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
            % PDF Computes the probability distribution function of the Normal distribution.
            y=normal_pdf( x, obj.mu, obj.sigma );
        end
        function y=cdf(obj,x)
            % CDF Computes the cumulative distribution function of the Normal distribution.
            y=normal_cdf( x, obj.mu, obj.sigma );
        end
        function x=invcdf(obj,y)
            % INVCDF Computes the inverse CDF (or quantile) function of the Normal distribution.
            x=normal_invcdf( y, obj.mu, obj.sigma );
        end
        function [var,mean,skew,kurt]=moments(obj)
            % MOMENTS Computes the moments of the Normal distribution.
            [var,mean,skew,kurt]=normal_moments( obj.mu, obj.sigma );
        end
        function y=stdnor(dist, x)
            % STDNOR Map normal distributed random values.
            %   Y=STDNOR(DIST, X) Map normal distributed random values X to random
            %   values Y distribution according to the probability distribution NormalDistribution.
            y = normal_stdnor(x, dist.mu, dist.sigma);
        end
        
    end
end
