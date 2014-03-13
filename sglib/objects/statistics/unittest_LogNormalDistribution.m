function unittest_LogNormalDistribution
% UNITTEST_LOGNORMALDISTRIBUTION Test the LOGNORMALDISTRIBUTION function.
%
% Example (<a href="matlab:run_example unittest_LogNormalDistribution">run</a>)
%   unittest_LogNormalDistribution
%
% See also LOGNORMALDISTRIBUTION, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'LogNormalDistribution' );

%%Initialization
LN=LogNormalDistribution(2,3);
assert_equals( LN.mu, 2, 'Initialization default a' );
assert_equals( LN.sigma,3, 'Initialization default b' );

LN=LogNormalDistribution(2);
assert_equals( LN.mu, 2, 'Initialization default a' );
assert_equals( LN.sigma, 1, 'Initialization default b' );

LN=LogNormalDistribution();
assert_equals( LN.mu, 0, 'Initialization default a' );
assert_equals( LN.sigma, 1, 'Initialization default b' );

%% lognormal_cdf
LN=LogNormalDistribution(2,0.5);
assert_equals(cdf(LN,-inf), 0, 'cdf_minf' );
assert_equals(cdf(LN,-1e8), 0, 'cdf_negative' );
assert_equals(cdf(LN,inf), 1, 'cdf_inf' );
assert_equals(cdf(LN,exp(LN.mu)), 1/2, 'cdf_median' );

% default arguments
% x = linspace(-0.5, 4.3);
% assert_equals( lognormal_cdf(x), lognormal_cdf(x,0,1), 'cdf_def12' );
% assert_equals( lognormal_cdf(x,-0.2), lognormal_cdf(x,-0.2,1), 'cdf_def2' );


% lognormal_pdf
assert_equals(pdf(LN,-inf), 0, 'pdf_minf' );
assert_equals(pdf(LN,-1e8), 0, 'pdf_negative' );
assert_equals(pdf(LN,inf), 0, 'pdf_inf' );

% pdf matches cdf
% [x1,x2]=linspace_mp(0,exp(mu+5*sig));
% F=cdf(LN,x1);
% F2=pdf_integrate(pdf(LN,x2), F, x1);
% assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

% default arguments
% LN=LogNormalDistribution();
% x = linspace(-0.5, 4.3);
% assert_equals(pdf(x),pdf(LN,x), 'pdf_def12' );
% LN=LogNormalDistribution(-0.2,1);
% assert_equals(pdf(x,-0.2), pdf(x,-0.2,1), 'pdf_def2' );


% lognormal_invcdf
y = linspace(0, 1);
x = linspace(0, 10);

LN=LogNormalDistribution();
assert_equals(cdf(LN,invcdf(LN,y)), y, 'cdf_invcdf_1');
assert_equals(invcdf(LN,cdf(LN,x)), x, 'invcdf_cdf_1');
assert_equals( isnan(invcdf(LN,[-0.1, 1.1])), [true, true], 'invcdf_nan1');

LN=LogNormalDistribution(0,0.5);
assert_equals(cdf(LN,invcdf(LN,y)), y, 'cdf_invcdf_2');
assert_equals(invcdf(LN,cdf(LN,x)), x, 'invcdf_cdf_2');
assert_equals( isnan(invcdf(LN,[-0.1, 1.1])), [true, true], 'invcdf_nan2');

LN=LogNormalDistribution(0.7,1.5);
assert_equals(cdf(LN,invcdf(LN,y)),cdf(LN,invcdf(LN,y)),'cdf_invcdf_3');
assert_equals(invcdf(LN,cdf(LN,x)), x, 'invcdf_cdf_3');
assert_equals( isnan(invcdf(LN,[-0.1, 1.1])), [true, true], 'invcdf_nan3');


% % lognormal_stdnor
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

LN=LogNormalDistribution(0.2,0.3);
x=stdnor( LN,gam );
assert_equals(cdf(LN,x), uni, 'lognormal' )
assert_equals( lognormal_stdnor(gam), lognormal_stdnor(gam, 0, 1), 'lognormal_def12');
assert_equals( lognormal_stdnor(gam, 0), lognormal_stdnor(gam, 0, 1), 'lognormal_def2');


% lognormal_raw_moments

% some precomputed moments
expected=[ 1., 1.6487212707001282, 7.38905609893065, 90.01713130052181, ...
    2980.9579870417283, 268337.2865208745, 6.565996913733051e7, ...
    4.3673179097646416e10, 7.896296018268069e13, 3.8808469624362035e17, ...
    5.184705528587072e21];
LN=LogNormalDistribution(0,1);
% assert_equals( expected, lognormal_raw_moments(LN,0:10 ), 'mu0sig1' );


expected=[1.0, 3.472934799336826, 13.197138159658358, ...
    54.871824399070078, 249.63503718969369, 1242.6481670549958];
LN=LogNormalDistribution(1.2,0.3);
% assert_equals( expected(1+[3,1,5])', lognormal_raw_moments(LN,[3;1;5]), 'mu12sig03' );

% 
% test default arguments
% assert_equals( lognormal_raw_moments(0:5), lognormal_raw_moments(0:5, 0, 1), 'def_12');
% assert_equals( lognormal_raw_moments(0:5, -0.2), lognormal_raw_moments(0:5, -0.2, 1), 'def_2');
% 

