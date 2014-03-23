classdef TranslatedDistribution < Distribution
    % TRANSLATEDDISTRIBUTION tranlates a distribution.
    % OBJ=TRANSLATEDDISTRIBUTION(DIST,SHIFT,SCALE,MEAN) translates
    % distribution DIST in regard to parameters SHIFT,SCALE,MEAN
    %
    % Example (<a href="matlab:run_example TranslatedDistribution">run</a>)
    %
    % See also DISTRIBUTION 
    
    %   <Aidin Nojavan>
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
        % The parameter DIST of the TRANSLATEDDISTRIBUTION(DIST,shift,scale,mean).
        % DIST is the original distribution.
        dist;
        % The parameter SHIFT of the TRANSLATEDDISTRIBUTION(dist,SHIFT,scale,mean).
        % SHIFT will shift the distribution to right or left.
        shift;
        % The parameter SCALE of the TRANSLATEDDISTRIBUTION(dist,shift,SCALE,mean).
        % Scale the whole distribution by the factor SCALE. Note that scaling
        % is done around the mean of the distribution and thus the mean is not
        % affected by scaling.
        scale;
        % The parameter SCALE of the TRANSLATEDDISTRIBUTION(dist,shift,scale,MEAN).
        % The MEAN refers to mean of the originial distribution.
        mean;
    end
    methods
        function obj = TranslatedDistribution(dist,shift,scale,mean)
            % TRANSLATEDDISTRIBUTION tranlates a distribution.
            % OBJ=TRANSLATEDDISTRIBUTION(DIST,SHIFT,SCALE,MEAN) translates
            % distribution DIST in regard to parameters SHIFT,SCALE,MEAN
            obj.dist = dist;
            obj.shift = shift;
            obj.scale = scale;
            obj.mean = mean;
        end
        
        function y=pdf(obj,x)
            % Y=PDF(OBJ,X) Computes the pdf of translated distribution of
            % original distribution, defined as a parameter of OBJ and values X
            x=(x-obj.shift-obj.mean)/obj.scale+obj.mean;
            % Computes the translated X values in regard to parameters
            % shift, mean and scale
            y=obj.dist.pdf(x)/obj.scale;
        end
        
        function y=cdf(obj,x)
            % Y=CDF(OBJ,X) Computes the cdf of translated distribution of
            % original distribution, defined as a parameter of OBJ and values X
            x=(x-obj.shift-obj.mean)/obj.scale+obj.mean;
            % Computes the translated X values in regard to parameters
            % shift, mean and scale
            y=obj.dist.cdf(x);
        end
        function x=invcdf(obj,y)
            % Y=INVCDF(OBJ,X) Computes the inverse cdf of translated
            % distribution of the original distribution, defined as a 
            % parameter of OBJ and values X
            x=obj.dist.invcdf(obj,y);
            x=(x-obj.mean)*obj.scale+obj.mean+obj.shift;
        end
    end
end


