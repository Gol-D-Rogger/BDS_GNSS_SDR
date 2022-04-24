clear all;
close all;
clc;
warning off;
%Simulation Parameter
EbNodB = 1:0.5:8;
MAXBLOCK = 1e6;
MAXERROR = 500;
EbNo = 10.^(EbNodB./10);
% BCH Code Parameter
n = 15;
k = 11;
d1 = 3;
coderate = k/n;
%Chase Decoding parameter
p = 2;


fileID = fopen('BCH3121Wt_ber.txt','w');
fprintf(fileID,'%12s %12s\n','EbNo in dB','BER');

codeword = zeros(1,n);
TestErrPatt  = zeros(2^p,n);
testseq = zeros(2^p,n);

for i=1:length(EbNodB)
    if(EbNodB(i)<5)
        MAXERROR = 500;
    else
        MAXERROR = 100;
    end
    toterror = 0;
    numblock = 0;

    while((numblock < MAXBLOCK) && (toterror < MAXERROR))
        s = RandStream('swb2712', 'Seed', 9973);
        infbits = gf(randi(s,[0 1],1,k));
        code = bchenc(infbits,n,k);
        code = double(code.x);
        codeword(1:n) = code;
        txword = 2*codeword-1;
        
        %Addition of noise        
        sigma = sqrt(0.5*(1/(coderate*EbNo(i))));
        rxword = txword + sigma*randn(1,n);
        
        rhard = rxword > 0;
        rabs = abs(rxword);
        
        %arranging r in ascending order reliability
        [rtemp,rpos] = sort(rabs);
        
        for j=1:2^p
            temp = j-1;
            for jj = 1:p
                TestErrPatt(j,rpos(jj)) = mod(temp,2);
                temp = floor(temp/2);
            end
        end
        
        for j = 1:2^p
            testseq(j,:) = xor(rhard, TestErrPatt(j,:));
            tempword = testseq(j,1:n);
            tempword = gf(tempword);
            [~,~,tdecword] = bchdec(tempword,n,k);
            tdecword = double(tdecword.x);
            testseq(j,1:n) = tdecword; 
        end
        % Calculating Eucledian distance from rxword of each Testseq
        for j=1:(2^p)
            SfWt = 0;
            for jj = 1:n
%                 SfWt = SfWt +(abs(rxword(jj)))*(xor(rhard(jj),testseq(j,jj)));
                SfWt = SfWt + (rxword(jj)-(2*testseq(j,jj)-1))^2;
            end
            SfWtMetric(j) = SfWt;
        end
        [Sftemp, Sfpos] = sort(SfWtMetric);
        
        decword = testseq(Sfpos(1),:);        
        reserr = biterr(decword,codeword);
        toterror = toterror + reserr;
        numblock = numblock + 1;
    end
    ber(i) = toterror/(numblock*n);
    [EbNodB(i) ber(i)]
    A = [EbNodB(i); ber(i)];
    fprintf(fileID,'%6.2f \t\t\t  %12.8f\n',A);    
end
fclose(fileID);
semilogy(EbNodB,ber,'-dr','LineWidth',2,'MarkerEdgeColor','b');
grid on;