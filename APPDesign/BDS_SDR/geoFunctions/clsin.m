%-----------------------------------------------------------------------------------
% This code has been adapted by Xin Zhang for purposes of course
% "AV423 Satellite Navigation" taught at School of Aeronautics & Astronautics, 
% Shanghai Jiao Tong University,
% from the SoftGNSS v3.0 code base developed for the
% text: "A Software-Defined GPS and Galileo Receiver: A Single-Frequency Approach"
% by Borre, Akos, et.al.
%-----------------------------------------------------------------------------------
function  result = clsin(ar, degree, argument)
%Clenshaw summation of sinus of argument.
%
%result = clsin(ar, degree, argument);

% Written by Kai Borre
% December 20, 1995
%
% See also WGS2UTM or CART2UTM
%
% CVS record:
% $Id: clsin.m,v 1.1.1.1.2.4 2006/08/22 13:45:59 dpl Exp $
%==========================================================================

cos_arg = 2 * cos(argument);
hr1     = 0;
hr      = 0;

for t = degree : -1 : 1
   hr2 = hr1;
   hr1 = hr;
   hr  = ar(t) + cos_arg*hr1 - hr2;
end

result = hr * sin(argument);
%%%%%%%%%%%%%%%%%%%%%%% end clsin.m  %%%%%%%%%%%%%%%%%%%%%
