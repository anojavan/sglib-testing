classdef Distribution % < handle
    % DISTRIBUTION Abstract base class for probability distribution objects.
    %
    % See also BETADISTRIBUTION
    methods (Abstract)
        y=pdf(dist, x); % PDF Compute the probability distribution function.
        y=cdf(dist, x); % CDF Compute the cumulative distribution function.
        x=invcdf(dist, y); % INVCDF Compute the inverse CDF (or quantile) function.
        y=moments(dist); % MOMENTS Compute the moments of the distribution.
    end
    methods
        function mean=mean(dist)
            mean=moments(dist);
        end
        function var=var(dist)
            m=cell(1,2);
            [m{:}]=dist.moments();
            var=m{2};
        end
        function dist=fix_moments(dist,mean,var)
            [old_mean, old_var]=moments( dist );
            
            dist.shift=mean-old_mean+ dist.shift;
            dist.scale=sqrt(var/old_var)* dist.scale;
        end
        function tdist = fix_bounds(tdist,min, max,varargin)
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
            old_min=invcdf( tdist,q0 );
            old_max=invcdf( tdist,q1 );
            
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
            %             mean = tdist.mean;
            old_shift=tdist.shift;
            old_scale=tdist.scale;
            tdist.scale = ((max-min) / (old_max-old_min));
            tdist.shift = min - ((old_min-tdist.center-tdist.shift)*tdist.scale + tdist.center+tdist.shift);
            
            tdist.shift=tdist.shift+old_shift;
            tdist.scale=tdist.scale*old_scale;
        end
        function y=stdnor(dist, x)
            % STDNOR Map normal distributed random values.
            %   Y=STDNOR(DIST, X) Map normal distributed random values X to random
            %   values Y distribution according to the probability distribution DIST.
            y=dist.invcdf( normal_cdf( x ) );
        end
    end
end
