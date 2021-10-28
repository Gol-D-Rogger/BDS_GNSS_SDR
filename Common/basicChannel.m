function recvSignal = basicChannel(b3isignalcode)

%% 参数初始化和噪声与瑞利衰落信道函数
SNR = 3;
% b3isignalcode = b3isignalcode';
N = length(b3isignalcode);
N0 = 1/sqrt(2)*(randn(1,N) + 1j*randn(1,N)); 
rayleigh_h = 1/sqrt(2)*(randn(1,N) + 1j*randn(1,N)); %高斯信道和瑞利信道函数
snrnodb = 10^(SNR/10);

bpskModulator = comm.BPSKModulator;
modData = bpskModulator(b3isignalcode);

bpsk_m = rayleigh_h .* modData + (1/sqrt(snrnodb))*N0;

bpsk_r = sqrt(2) * bpsk_m ./ rayleigh_h;

%% 解调
In = real(bpsk_r);
In(In>0)=1;
In(In<=0)=-1;

%% 计算误码率
recvSignal=zeros(1,N);
err=0;
for i=1:N
    recvSignal(1,i)=In(1,(i-1)*sample_rate+1/2*sample_rate);
    if recvSignal(1,i)~=b3isignalcode(1,i)
       err = err+1; 
    end
end

BER = err/N;
BER_theoretical_awgn  = 1/2*erfc(sqrt(snrnodb));
BER_theoretical_ray  = 1/2.*(1-sqrt(snrnodb./(snrnodb+1)));

end