function unittest_Monomials
% UNITTEST_MONOMIALS Test the MONOMIALS function.
%
% Example (<a href="matlab:run_example unittest_Monomials">run</a>)
%   unittest_Monomials
%
% See also MONOMIALS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'Monomials' );
%% Recur_coeff
M=Monomials();
r=M.recur_coeff(3);
assert_equals(r, ...
    [[0,1,0]; [0,1,0]; [0,1,0]],'recur_coeff');
%% evaluate
xi=[1,2,3,4];
y=M.evaluate(3,xi);
assert_equals(y,[1 1 1;1 2 4;1 3 9;1 4 16],'evaluate');

