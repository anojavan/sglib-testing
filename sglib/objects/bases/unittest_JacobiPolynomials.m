function unittest_JacobiPolynomials
% UNITTEST_JACOBIPOLYNOMIALS Test the JACOBIPOLYNOMIALS function.
%
% Example (<a href="matlab:run_example unittest_JacobiPolynomials">run</a>)
%   unittest_JacobiPolynomials
%
% See also JACOBIPOLYNOMIALS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'JacobiPolynomials' );
%% Initialization
J=JacobiPolynomials(1,1);
assert_equals( J.alpha, 1,'Initialization alpha');
assert_equals( J.beta, 1,'Initialization beta');
%% Recurrence Coefficients
r = J.recur_coeff(3);
assert_equals(r,[0 1 2/3;0 15/32 0.75;0 14/45 0.8],'recur_coeff');
%% evaluate
xi=[1,2,3,4];
y=J.evaluate(3,xi);
assert_equals(y,[1 1 -0.28125;1 2 1.125;1 3 3.46875;1 4 6.75],'evaluate');

