function [r,n,N0] = add_awgn_noise(s,SNRdB,L)
s_temp=s;
if iscolumn(s)
    s=s.';
end 
gamma = 10^(SNRdB/10); %SNR
if nargin==2
    L=1;
end
if isvector(s)
    P=L*sum(abs(s).^2)/length(s);
else 
    P=L*sum(sum(abs(s).^2))/length(s);
end
N0=P/gamma;
if(isreal(s))
    n = sqrt(N0/2)*randn(size(s));
else
    n = sqrt(N0/2)*(randn(size(s))+1i*randn(size(s)));
end
r = s + n; %received signal
if iscolumn(s_temp)
    r=r.';
end
end