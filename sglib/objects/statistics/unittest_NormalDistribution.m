function unittest_NormalDistribution
% UNITTEST_NORMALDISTRIBUTION Test the NORMALDISTRIBUTION function.
%
% Example (<a href="matlab:run_example unittest_NormalDistribution">run</a>)
%   unittest_NormalDistribution
%
% See also NORMALDISTRIBUTION, MUNIT_RUN_TESTSUITE 

%   <Aidin Nojavan>
%   Copyright 2014, <Inst. of Scientific Computing, TU Braunschweig>
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'NormalDistribution' );

%% Initialization
N=NormalDistribution(2,3);
assert_equals( N.mu, 2, 'Initialization default mu' );
assert_equals( N.sigma,3, 'Initialization default sigma' );

N=NormalDistribution(2);
assert_equals( N.mu, 2, 'Initialization default mu' );
assert_equals( N.sigma, 1, 'Initialization default sigma' );

N=NormalDistribution();
assert_equals( N.mu, 0, 'Initialization default mu' );
assert_equals( N.sigma, 1, 'Initialization default sigma' );
%% normal_cdf
N=NormalDistribution(1,2);
assert_equals(cdf(N,-inf), 0, 'cdf_minf' );
assert_equals(cdf(N,inf), 1, 'cdf_inf' );
assert_equals(cdf(N,N.mu), 1/2, 'cdf_median' );

%% normal_pdf
N=NormalDistribution(1,2);
assert_equals( pdf(N,-inf), 0, 'pdf_minf' );
assert_equals(pdf(N,inf), 0, 'pdf_inf' );

%% normal_invcdf

y = linspace(0, 1);
x = linspace(-2, 3);

N=NormalDistribution();
assert_equals(cdf(N,invcdf(N,y)), y, 'cdf_invcdf_1');
assert_equals(invcdf(N,cdf(N,x)), x, 'invcdf_cdf_1');
assert_equals( isnan(invcdf(N,[-0.1, 1.1])), [true, true], 'invcdf_nan1');

N=NormalDistribution(0.5);
assert_equals(cdf(N,invcdf(N,y)), y, 'cdf_invcdf_2');
assert_equals(invcdf(N,cdf(N,x)), x, 'invcdf_cdf_2');
assert_equals( isnan(invcdf(N,[-0.1, 1.1])), [true, true], 'invcdf_nan2');

N=NormalDistribution(0.7,1.5);
assert_equals(cdf(N,invcdf(N,y)), y, 'cdf_invcdf_3');
assert_equals(invcdf(N,cdf(N,x)), x, 'invcdf_cdf_3');
assert_equals( isnan(invcdf(N,[-0.1, 1.1])), [true, true], 'invcdf_nan3');

%% normal_stdnor
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

N=NormalDistribution(0.2,0.3);
x=stdnor( N,gam );
assert_equals( cdf(N,x), uni, 'normal' )
N=NormalDistribution(0,1);
assert_equals( normal_stdnor(gam), stdnor(N,gam), 'normal_def12');
assert_equals( normal_stdnor(gam, 0),stdnor(N,gam), 'normal_def2');

