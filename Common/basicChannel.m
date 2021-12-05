% function recvSignal = basicChannel(b3isignalcode)
clear all;clc;

% 参数初始化
ebno_vec = 1:9;
K = 224;
N = 15;
max_runs = 1e4;
resolution = 10;
num_bit_err = zeros(length(ebno_vec), 1);
num_pack_err = zeros(length(ebno_vec), 1);
num_runs = zeros(length(ebno_vec), 1);

enc = comm.BCHEncoder(15,11,'X^4 + X + 1');
bpskModulator = comm.BPSKModulator;

tic
for i_run = 1 : max_runs
    if  mod(i_run, max_runs/resolution) == 1
        disp(' ');
        disp(['Sim iteration running = ' num2str(i_run)]);
        disp(['N = ' num2str(N) ' K = ' num2str(K)]);
        disp('The first column is the Eb/N0');
        disp('The second column is the PER of BCH.');
        disp('The third columns is the BER of BCH');
        disp(num2str([ebno_vec'  num_pack_err./num_runs  num_bit_err./num_runs/K]));
        disp(' ');
    end
    
    info  = rand(1, K) > 0.5;
    info_bch(1:15) = info(1:15);
    for ii = 1 : 19
        info_bch(15*(ii-1)+16 : 15*ii+15) = step(enc, info(11*(ii-1)+16 : 11*ii+16-1).');
    end  %模拟北斗D1电文中一帧的数据作为一个数据包
    
    bpsk = bpskModulator(info_bch');  % 调制
    for i_ebno = 1 : length(ebno_vec)
%         N0 = 1/sqrt(2)*(randn(1,N) + 1j*randn(1,N)); 
%         rayleigh_h = 1/sqrt(2)*(randn(1,N) + 1j*randn(1,N)); %高斯信道和瑞利信道函数
%         bpsk_m = rayleigh_h .* bpsk + (1/sqrt(ebno_vec(i_ebno)))*N0;
%         bpsk_r = sqrt(2) * bpsk_m ./ rayleigh_h;
        bpsk_r = awgn(bpsk,ebno_vec(i_ebno));
        num_runs(i_ebno) = num_runs(i_ebno) + 1;
        
        % 解调
        info_bch_esti = real(bpsk_r);
        hard_decision = zeros(1,length(info_bch_esti));
        hard_decision(info_bch_esti<=0)=1;
        hard_decision(info_bch_esti>0)=0;  %硬判决

        info_bch_decode(1:15) = hard_decision(1:15);
        for jj = 1 :19
            codeout = BCH15_4Decode(hard_decision(15*jj+1 : 15*jj+15));
            info_bch_decode(15+11*(jj-1)+1 : 15+11*jj) = (double(codeout(1:11)'))';%codeout;
        end
        
        % 计算误码率
        if any(info_bch_decode ~= info)
            num_pack_err(i_ebno) =  num_pack_err(i_ebno) + 1;
            num_bit_err(i_ebno) = num_bit_err(i_ebno) + sum(info_bch_decode ~= info);
        end        
        
        
    end
end
toc

ber = num_bit_err./num_runs/K;
per = num_pack_err./num_runs;
ber_theoretical_bpsk = berawgn(ebno_vec,'psk',2,'nondiff');

% pd = makedist('Rayleigh','b',3);
% x = 0:.1:4;
% y = pdf(pd,x);
% plot(x,y,'LineWidth',2);
% 
% pd = makedist('Rician');
% x = 0:.05:2.5;
% y = pdf(pd,x);
% plot(x,y,'LineWidth',2);

p = semilogy(ebno_vec, per);
grid on
p(1).Marker = 'o';
p(1).Color = 'r';

p(1).MarkerSize = 8;
p(1).LineWidth = 1.1;

l.Location = 'SouthWest';

xlabel('E_b/N_0 (dB)')
ylabel('BER')
set(gca, 'fontname', 'times new roman', 'fontsize', 11);
set(gca,'XTick',(1:9));