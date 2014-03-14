function unittest_NormalDistribution
% UNITTEST_NORMALDISTRIBUTION Test the NORMALDISTRIBUTION function.
%
% Example (<a href="matlab:run_example unittest_NormalDistribution">run</a>)
%   unittest_NormalDistribution
%
% See also NORMALDISTRIBUTION, MUNIT_RUN_TESTSUITE 

%   <author>
%   Copyright 2014, <institution>
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

% default arguments
% x = linspace(-0.5, 4.3);
% assert_equals( normal_cdf(x), normal_cdf(x,0,1), 'cdf_def12' );
% assert_equals( normal_cdf(x,0.2), normal_cdf(x,0.2,1), 'cdf_def2' );


%% normal_pdf
N=NormalDistribution(1,2);
assert_equals( pdf(N,-inf), 0, 'pdf_minf' );
assert_equals(pdf(N,inf), 0, 'pdf_inf' );

% % pdf matches cdf
% [x1,x2]=linspace_mp(mu-5*sig,mu+5*sig);
% F=normal_cdf(x1, mu, sig);
% F2=pdf_integrate( normal_pdf(x2,mu,sig), F, x1);
% assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );
% 
% % default arguments
% x = linspace(-0.5, 4.3);
% assert_equals( normal_pdf(x), normal_pdf(x,0,1), 'pdf_def12' );
% assert_equals( normal_pdf(x,0.2), normal_pdf(x,0.2,1), 'pdf_def2' );


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

%% normal_raw_moments

% % some precomputed moments
% expected=[1, 0, 1, 0, 3, 0, 15, 0, 105, 0, 945];
% assert_equals( expected, normal_raw_moments( 0:10, 0, 1 ), 'mu0sig1' );
% 
% expected=[1.022, 0.2, 8.70382];
% assert_equals( expected, normal_raw_moments( [3;1;5], 0.2, 1.3 ), 'lam0.2T' );

% % test default arguments
% assert_equals( normal_raw_moments(0:5), normal_raw_moments(0:5, 0, 1), 'def_12');
% assert_equals( normal_raw_moments(0:5, 0.4), normal_raw_moments(0:5, 0.4, 1), 'def_2');


