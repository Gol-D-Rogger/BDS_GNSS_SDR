function recvSignal = basicChannel(b3isignalcode)

%% ������ʼ��������������˥���ŵ�����
SNR = 3;
b3isignalcode = b3isignalcode';
m = length(b3isignalcode);
sample_rate = 8; % һ����Ԫ��128������
N = sample_rate * m; %���泤��
n = 1:1:N;
N0 = 1/sqrt(2)*(randn(1,N) + 1j*randn(1,N)); 
rayleigh_h = 1/sqrt(2)*(randn(1,N) + 1j*randn(1,N)); %��˹�ŵ��������ŵ�����
snrnodb = 10^(SNR/10);

%% �����ź�

bpsk_m = zeros(1,N);
jj = 1; k = 1;
origPhase = 0; %��ʼ��λ
stepPhase = 2*pi/sample_rate; %������λ
for i = 1:N
    if (jj == (sample_rate+1))
        jj=1;
        k=k+1;
    end
    bpsk_m(1,i) = b3isignalcode(1,k)*sin(stepPhase*i+origPhase) + ...
                    b3isignalcode(1,k)*cos(stepPhase*i + origPhase);
    jj=jj+1;
end

bpsk_m = rayleigh_h .* bpsk_m + (1/sqrt(snrnodb))*N0;

bpsk_m = sqrt(2) * bpsk_m ./ rayleigh_h;
bpsk_m1 = bpsk_m .* sin(stepPhase*n + origPhase);
bpsk_m2 = bpsk_m .* cos(stepPhase*n + origPhase); %������·�ź�
real_x = real(bpsk_m1);
real_x1 = real(bpsk_m2);

%% ���
In = real_x + real_x1; % ��ֻȡһ·������ȡ����·֮��
In(In>0)=1;
In(In<=0)=-1;

%% ����������
recvSignal=zeros(1,m);
err=0;
for i=1:m
    recvSignal(1,i)=In(1,(i-1)*sample_rate+1/2*sample_rate);
    if recvSignal(1,i)~=b3isignalcode(1,i)
       err = err+1; 
    end
end

BER = err/m;
BER_theoretical_awgn  = 1/2*erfc(sqrt(snrnodb));
BER_theoretical_ray  = 1/2.*(1-sqrt(snrnodb./(snrnodb+1)));

end

L = 16;
ak = rand(N,1)>0.5;
[s_bb,t]= bpsk_mod(ak,L);

function [s_bb,t] = bpsk_mod(ak,L)
%BPSK modulated baseband signal
%Function to modulate an incoming binary stream using BPSK(baseband)
%ak - input binary data stream (0's and 1's) to modulate
%L - oversampling factor (Tb/Ts)
%s_bb - BPSK modulated signal(baseband)
%t - generated time base for the modulated signal
N = length(ak); %number of symbols
a = 2*ak-1; %BPSK modulation
ai=repmat(a,1,L).'; %bit stream at Tb baud with rect pulse shape
ai = ai(:).';%serialize
t=0:N*L-1; %time base
s_bb = ai;
end