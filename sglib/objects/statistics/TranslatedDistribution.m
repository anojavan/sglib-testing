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
            x=obj.dist.invcdf(y);
            x=(x-obj.mean)*obj.scale+obj.mean+obj.shift;
        end
        function [mean,var,skew,kurt]=moments(obj)
            n=max(nargout,1);
            m=cell(1,n);
            [m{:}]=obj.dist.moments();
            mean=m{1}+obj.shift;
            if nargout>=2
                var=m{2}*obj.scale^2;
            end
            if nargout>=3
                skew=m{3};
            end
            if nargout>=4
                kurt=m{4};
                
            end
        end
        
        function [shift,scale] = fix_bounds(obj,min, max,varargin)
            % reads the user option or return the default in varargin.
            % If DIST is an unbounded distribution the options 'q0' and or 
            % 'q1' can be set. Then the Q0 quantile of the new distribution 
            % will be MIN and the Q1 quantile will be MAX (see Example 2). 
            % If these options are not set, they default to 0 and 1, which 
            % means the bounds of the distribution.
            options=varargin2options(varargin);
            [q0,options]=get_option(options,'q0',0);
            [q1,options]=get_option(options,'q1',1);
            check_unsupported_options(options,mfilename);
            
            % check bounds for the lower and upper quantiles (q0 and q1)
            check_range(q0, 0, 1, 'q0', mfilename);
            check_range(q1, q0, 1, 'q1', mfilename);
            
            % get the x values corresponding to the quantiles
            old_min=invcdf( q0, obj.dist );
            old_max=invcdf( q1, obj.dist );
            
            % check that the min and max are finite (i.e. either it was a
            %  bounded distribution or quantiles are different from 0 or 1)
            if ~isfinite(old_min)
                error('sglib:statistics', 'Lower quantile (q0) gives infinity (unbounded distribution?)');
            end
            if ~isfinite(old_max)
                error('sglib:statistics', 'Upper quantile (q1) gives infinity (unbounded distribution?)');
            end
            
            % Get the new scale and shift factors (just a linear mapping,
            % only the shift is a bit tricky since the mean needs to be
            % taken into account. BTW: it doesn't make a difference whether
            % the min or the max is used for the shift calculation)
            mean = obj.dist.mean;
            scale = (max-min) / (old_max-old_min);
            shift = min - ((old_min-mean-old_shift)*scale + mean+old_shift);
        end
    end
end

