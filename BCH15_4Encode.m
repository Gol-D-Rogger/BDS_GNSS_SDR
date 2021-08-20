function bchcode = BCH15_4Encode(indata)
    D3=0;D2=0;D1=0;D0=0;
    for i = 1 : 11
            tempbit = xor(indata(i), D3);
            D3 = D2;
            D2 = D1;
            D1 = xor(D0,tempbit);
            D0 = tempbit;
    end
    bchcode = [indata D3 D2 D1 D0];
end
% genpoly = bchgenpoly(N,K,'D^4 + D^3 + 1');
% bchEncoder = comm.BCHEncoder(N,K,genpoly);