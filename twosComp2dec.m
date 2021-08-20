function intNumber = twosComp2dec(binaryNumber)
% TWOSCOMP2DEC(binaryNumber) Converts a two's-complement binary number
% BINNUMBER (in Matlab it is a string type), represented as a row vector of
% zeros and ones, to an integer. 
%
%intNumber = twosComp2dec(binaryNumber)

%--- Check if the input is string -----------------------------------------
if ~isstr(binaryNumber)
    error('Input must be a string.')
end

%--- Convert from binary form to a decimal number -------------------------
intNumber = bin2dec(binaryNumber);

%--- If the number was negative, then correct the result ------------------
if binaryNumber(1) == '1'
    intNumber = intNumber - 2^size(binaryNumber, 2);
end
