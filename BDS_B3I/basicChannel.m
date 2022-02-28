% function recvSignal = basicChannel(b3isignalcode)


% 参数初始化
ebno_vec = 3:0.5:8;
K = 224;
N = 15;
max_runs = 1e3;
resolution = 10;
qnumber = 2;
num_bit_err_chase = zeros(length(ebno_vec), 1);
num_bit_err = zeros(length(ebno_vec), 1);
num_pack_err = zeros(length(ebno_vec), 1);
num_pack_err_chase = zeros(length(ebno_vec), 1);
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
        disp(num2str([ebno_vec'  num_bit_err./num_runs/K num_bit_err_chase./num_runs/K num_pack_err./num_runs num_pack_err_chase./num_runs]));
        disp(' ');
    end
    
    info  = rand(1, K) > 0.5;
    info(1:15) = [1 1 1 0 0 0 1 0 0 1 0 0 0 0 0];
    info_bch(1:15) = info(1:15);
    for ii = 1 : 19
        info_bch(15*(ii-1)+16 : 15*ii+15) = step(enc, info(11*(ii-1)+16 : 11*ii+16-1).');
    end  %模拟北斗D1电文中一帧的数据作为一个数据包
    
    bpsk = bpskModulator(info_bch');  % 调制
    for i_ebno = 1 : length(ebno_vec)
%         y = bpsk + N0;
%         sigma = 1/sqrt(2 * 11/15) * 10^(-ebno_vec(i_ebno)/20);
%         y = bpsk + sigma * noise;
        rx1 = awgn(bpsk,ebno_vec(i_ebno));
        
        N0 = (1/sqrt(2)*(randn(1,length(bpsk)) + 1j*randn(1,length(bpsk))))'; 
        rayleigh_h = (1/sqrt(2)*(randn(1,length(bpsk)) + 1j*randn(1,length(bpsk))))'; %高斯信道和瑞利信道函数
        tx2 = rayleigh_h .* bpsk + (1/sqrt(ebno_vec(i_ebno)))*N0;
        rx2 = sqrt(2) * tx2 ./ rayleigh_h;
%         rayleighchan = comm.RayleighChannel();
%         rx2 = rayleighchan(bpsk);
        
        num_runs(i_ebno) = num_runs(i_ebno) + 1;

        
        % 解调AWGN
        info_bch_esti = real(rx1);
        hard_decision = zeros(1,length(info_bch_esti));
        hard_decision(info_bch_esti<=0)=1;
        hard_decision(info_bch_esti>0)=0;  %硬判决
        
        % 解调Rayleigh
%         info_bch_esti2 = real(rx2);
%         hard_decision2 = zeros(1,length(info_bch_esti2));
%         hard_decision2(info_bch_esti2<=0)=1;
%         hard_decision2(info_bch_esti2>0)=0;  %硬判决
%         
        hard_decision2 = pskdemod(rx2,2);
        
        info_bch_decode(1:15) = hard_decision(1:15);
        for jj = 1 :19%ICD译码
            codeout = BCH15_4Decode(hard_decision(15*jj+1 : 15*jj+15));
            info_bch_decode(15+11*(jj-1)+1 : 15+11*jj) = (double(codeout(1:11)'))';%codeout;
        end
        
%         info_bch_decode2(1:15) = hard_decision2(1:15);
%         for jj = 1 :19
%             codeout = BCH15_4Decode(hard_decision2(15*jj+1 : 15*jj+15));
%             info_bch_decode2(15+11*(jj-1)+1 : 15+11*jj) = (double(codeout(1:11)'))';%codeout;
%         end
        
        chase2codeout(1:15) = hard_decision(1:15);
        for jj = 1 :19
            codeout = BDBCH_Chase2(info_bch_esti(15*jj+1 : 15*jj+15));
            chase2codeout(15+11*(jj-1)+1 : 15+11*jj) = (double(codeout(1:11)'))';%codeout;
        end
        
%         num_bit_err2(i_ebno) = num_bit_err2(i_ebno) + biterr(chase2codeout, info);

        
        % 计算误码率
        num_bit_err_chase(i_ebno) = num_bit_err_chase(i_ebno) + biterr(chase2codeout, info);
        if any(chase2codeout ~= info)
            num_pack_err_chase(i_ebno) =  num_pack_err_chase(i_ebno) + 1;   
        end        
        
        num_bit_err(i_ebno) = num_bit_err(i_ebno) + biterr(info_bch_decode, info);
        if any(info_bch_decode ~= info)
            num_pack_err(i_ebno) =  num_pack_err(i_ebno) + 1;   
        end 
    end
end
toc

ber = num_bit_err./num_runs/K;
ber_chase = num_bit_err_chase./num_runs/K;
per = num_pack_err./num_runs;
per_chase = num_pack_err_chase./num_runs;
ber_theoretical_bpsk = berawgn(ebno_vec,'psk',2,'nondiff');
% ber_theoretical_bch  = bercoding(ebno_vec,'block','hard',15,11,3);
% ber_theoretical_ray = 1/2.*(1-sqrt(ebno_vec./(ebno_vec+1)));
ber_theoretical_ray = [0.14645,0.12673,0.10848,0.091913,0.077137,0.064183,0.052999,0.043474,0.035459,0.028782,0.023269,0.018748,0.015065,0.012078,0.009665,0.007723];%0:15
unionBound = [9.420800e-01;5.622630e-01;3.247000e-01;...
              1.813140e-01;9.778770e-02;5.083800e-02;...
              2.539770e-02;1.213870e-02;5.517730e-03;...
              2.368010e-03;9.511270e-04;3.539060e-04;...
              1.205600e-04;3.709320e-05;1.014890e-05;...
              2.426228e-06;4.968457e-07];% 0:0.5:8
unionBoundComp = unionBound(ebno_vec(1)*2+1 : ebno_vec(end)*2+1);  

figure()
p = semilogy(ebno_vec, [per_chase';ber_chase';ber';per']);
grid on
p(1).Marker = 's';
p(1).Color = [0.04 0.58 0.68];%blue[0 0.447 0.741]
p(1).LineStyle = '-';
p(2).Marker = '^';
p(2).Color = [0.466 0.674 0.188];%red[0.9261 0.1211 0.1409]
p(2).LineStyle = '-';

p(3).Marker = '<';
p(3).Color = [0.203 0.338 0.6476];
p(3).LineStyle = '-';

p(4).Marker = 'x';
p(4).Color = [0 0.447 0.741];
p(4).LineStyle = '-';

for k = 1 : 4
    p(k).MarkerSize = 8;
    p(k).LineWidth = 1.1;
end

l = legend('per_chase','ber_chase', 'ber', 'per');
l.Location = 'SouthWest';

xlabel('E_b/N_0 (dB)')
ylabel('BER')
set(gca, 'fontname', 'times new roman', 'fontsize', 11);
% set(gca,'XTick',(1:0.5:4));