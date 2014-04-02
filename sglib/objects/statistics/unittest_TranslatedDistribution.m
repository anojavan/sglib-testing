function unittest_TranslatedDistribution
% UNITTEST_TRANSLATEDDISTRIBUTION Test the TRANSLATEDDISTRIBUTION function.
%
% Example (<a href="matlab:run_example unittest_TranslatedDistribution">run</a>)
%   unittest_TranslatedDistribution
%
% See also TRANSLATEDDISTRIBUTION, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'TranslatedDistribution' );
%% Initialization
B = BetaDistribution(2,3);
T = TranslatedDistribution(B,4,5,3);
assert_equals( T.dist, B, 'Initialization dist' );
assert_equals( T.shift, 4, 'Initialization shift' );
assert_equals( T.scale, 5, 'Initialization scale' );
assert_equals( T.mean, 3, 'Initialization mean' );

%% PDF
B = BetaDistribution(3,3);
T = TranslatedDistribution(B,0.25,2,0.5);
assert_equals(pdf(T,1/2), 0.8240, 'pdf_median','abstol',0.001);
LN = LogNormalDistribution(3,3);
T = TranslatedDistribution(LN,0.25,1,0.5);
assert_equals(pdf(T,1/2), 0.1827, 'pdf_median','abstol',0.0001);
%% CDF
T = TranslatedDistribution(B,0.25,1,0.5);
assert_equals(cdf(T,1/2), 0.1035, 'cdf_median','abstol',0.001);
T = TranslatedDistribution(B,0.25,2,0.5);
assert_equals(cdf(T,1/2), 0.2752, 'cdf_median','abstol',0.001);
T = TranslatedDistribution(B,0.15,1,0.5);
assert_equals(cdf(T,1/2), 0.2352, 'cdf_median','abstol',0.001);
LN = LogNormalDistribution(3,3);
T = TranslatedDistribution(LN,0.25,1,0.5);
assert_equals(cdf(T,1/2), 0.0719, 'cdf_median','abstol',0.0001);
%% INVCDF
T = TranslatedDistribution(B,0.25,2,0.5);
assert_equals(invcdf(T,1/2), 0.75, 'invcdf_median','abstol',0.001);
T = TranslatedDistribution(LN,0.25,1,0.5);
assert_equals(invcdf(T,1/2), 20.3355, 'invcdf_median','abstol',0.0001);
N = NormalDistribution(4,1);
T = TranslatedDistribution(N,0.25,1,0.5);
assert_equals(invcdf(T,1/2), 4.25, 'invcdf_median','abstol',0.0001);

%% Moments
N = NormalDistribution(4,1);
T = TranslatedDistribution(N,0,1,1.5);
[mean,var,skew,kurt]=moments(T);
assert_equals(mean, 4, 'moments_median','abstol',0.0001);
assert_equals(var, 1, 'moments_median','abstol',0.0001);
assert_equals(skew, 0, 'moments_median','abstol',0.0001);
assert_equals(kurt, 0, 'moments_median','abstol',0.0001);
B = BetaDistribution(3,3);
T = TranslatedDistribution(B,0,1,0.5);
[mean,var,skew,kurt]=moments(T);
assert_equals(mean, 0.5, 'moments_median','abstol',0.0001);
assert_equals(var, 0.0357, 'moments_median','abstol',0.0001);
assert_equals(skew,0 , 'moments_median','abstol',0.0001);
assert_equals(kurt, -0.6667, 'moments_median','abstol',0.0001);
%% Fix Moments
% can test directly for the normal and uniform distributions
N = NormalDistribution(2,5);
T = TranslatedDistribution(N,0,1,2);
dist=fix_moments(T,7,13);
assert_equals([dist.shift,dist.scale], [5, sqrt(13/25)], 'normal','abstol',0.0001);

dist = gendist_create('uniform', {22, 88});
U = UniformDistribution(22,88);
T = TranslatedDistribution(U,0,1,55);
dist=fix_moments(T, 50, 3 );
assert_equals([dist.shift,dist.scale], [-5, 1/11], 'uniform');

% can test via the moments for the lognormal distribution
dist=gendist_create('lognormal', {0,1});
LN=LogNormalDistribution(0,1);
T=TranslatedDistribution(LN,0,1,6487);
dist=fix_moments(T, 3.1, 2.4 );
[mean,var]=moments( dist );
assert_equals( mean, 3.1, 'mean' );
assert_equals( var, 2.4, 'var' );

% change a second time
dist=fix_moments( dist, 7, 5 );
[mean,var]=moments( dist );
assert_equals( mean, 7, 'mean2' );
assert_equals( var, 5, 'var2' );

%% Fix Bounds
% test for the uniform distribution
U = UniformDistribution(2,3);
T = TranslatedDistribution(U,3,0.5,2.5);
dist = fix_bounds(T,2,4);
% assert_equals(invcdf(dist,0), 2, 'uni_min');
% assert_equals(invcdf(dist,1), 4, 'uni_max');

% test with quantiles for the normal distribution
N = NormalDistribution(2,3);
T = TranslatedDistribution(N,0,1,2);
dist = fix_bounds(T,2,4,'q0',0.001,'q1', 0.5);
assert_equals(invcdf(dist,0.001), 2, 'nor_min');
assert_equals(invcdf(dist,0.5), 4, 'nor_max');