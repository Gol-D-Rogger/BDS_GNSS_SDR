% function recvSignal = basicChannel(b3isignalcode)


% 参数初始化
ebno_vec = 1:1:10;
% K = 224;
K = 11;
N = 15;
R = K/N;%code rate
max_runs = 1e4;
resolution = 10;
MaxIter = 10;
qnumber = 2;
num_bit_err_ICD_AWGN = zeros(length(ebno_vec), 1);
num_pack_err_ICD_AWGN = zeros(length(ebno_vec), 1);
num_bit_err_ICD_Rayleigh = zeros(length(ebno_vec), 1);
num_pack_err_ICD_Rayleigh = zeros(length(ebno_vec), 1);

num_bit_err_chase2_AWGN = zeros(length(ebno_vec), 1);
num_pack_err_chase2_AWGN = zeros(length(ebno_vec), 1);
num_bit_err_chase2_Rayleigh = zeros(length(ebno_vec), 1);
num_pack_err_chase2_Rayleigh = zeros(length(ebno_vec), 1);

num_bit_err_spa_AWGN = zeros(length(ebno_vec), 1);
num_pack_err_spa_AWGN = zeros(length(ebno_vec), 1);
num_bit_err_spa_Rayleigh = zeros(length(ebno_vec), 1);
num_pack_err_spa_Rayleigh = zeros(length(ebno_vec), 1);

num_bit_err_spa2 = zeros(length(ebno_vec), 1);
num_bit_err_spa3 = zeros(length(ebno_vec), 1);
num_pack_err_spa2 = zeros(length(ebno_vec), 1);
num_pack_err_spa3 = zeros(length(ebno_vec), 1);

num_runs = zeros(length(ebno_vec), 1);

nbits = 3; % 8bit量化


Hbd = [1 1 1 1 0 1 0 1 1 0 0 1 0 0 0;...
       0 1 1 1 1 0 1 0 1 1 0 0 1 0 0;...
       0 0 1 1 1 1 0 1 0 1 1 0 0 1 0;...
       1 1 1 0 1 0 1 1 0 0 1 0 0 0 1];
   
H74 = [1 1 1 0 1 0 0;...
        0 1 1 1 0 1 0;...
        0 0 1 1 1 0 1];
H74_RmFC = [1 0 0 0 1 0 0 1;...
      0 0 0 1 0 1 0 1;...
      0 0 1 1 1 0 1 0;...
      0 1 1 0 0 0 0 1];
HM = [1 0 0 0 1 0 0 1 0;...
      0 0 0 1 0 1 0 1 0;...
      0 0 1 1 1 0 1 0 0;...
      0 1 1 0 0 0 0 1 0;
      0 1 0 0 1 0 0 0 1;...
      1 0 1 0 0 0 0 0 1;...
      1 1 0 1 0 0 1 0 0;...
      0 0 0 0 0 1 1 0 1];

% enc = comm.BCHEncoder(7,4,'X^3 + X + 1');
% dec = comm.BCHDecoder(7,4,'X^3 + X + 1');
enc = comm.BCHEncoder(15,11,'X^4 + X + 1');
% dec = comm.BCHDecoder(15,11,'X^4 + X + 1');


for i_run = 1 : max_runs
    if  mod(i_run, max_runs/resolution) == 1
        disp(' ');
        disp(['Sim iteration running = ' num2str(i_run)]);
        disp(['N = ' num2str(N) ' K = ' num2str(K)]);
        disp('The first column is the Eb/N0');
        disp('The second column is the PER of BCH.');
        disp('The third columns is the BER of BCH');
%         disp(num2str([ebno_vec'  num_bit_err./num_runs/K num_bit_err_spa./num_runs/K num_pack_err./num_runs num_pack_err_chase./num_runs]));
        disp(' ');
    end
    
%     info  = rand(1, K) > 0.5;
%     info(1:15) = [1 1 1 0 0 0 1 0 0 1 0 0 0 0 0];
%     info_bch(1:15) = info(1:15);
%     for ii = 1 : 19
%         info_bch(15*(ii-1)+16 : 15*ii+15) = step(enc, info(11*(ii-1)+16 : 11*ii+16-1).');
%     end  %模拟北斗D1电文中一帧的数据(300bit)作为一个数据包
    
    info = rand(K, 1) > 0.5;
%     x = BCH15_4Encode(info');
    x = step(enc, info);
    bpsk = 1 - 2 * x;  % 调制
    noise = randn(N, 1);
    for i_ebno = 1 : length(ebno_vec)
        sigma = 1/sqrt(2 * R) * 10^(-ebno_vec(i_ebno)/20);
        h = (1/sqrt(2)*(randn(1,length(bpsk)) + 1j*randn(1,length(bpsk))))'; %高斯信道和瑞利信道函数
        
        tx1 = bpsk + sigma * noise;
        tx2 = abs(h).*bpsk + sigma*(randn(1,length(bpsk))+1j*randn(1,length(bpsk)))';
        rx2 = tx2./abs(h);
        

        
        llr_AWGN = 2/sigma^2*tx1;
        llr_Rayleigh = 2/sigma^2*rx2;
        llr_RmFC = llr_AWGN;
        llr_RmFC(end+1) = 0;%打孔比特LLR置零
        llr_RmFC2 = llr_AWGN;
        llr_RmFC2(end+1) = 0;
        llr_RmFC2(end+1) = 0;
        
        num_runs(i_ebno) = num_runs(i_ebno) + 1;

        
        % 解调AWGN
        hd_awgn = pskdemod(tx1,2);
        % 解调Rayleigh
        hd_rayleigh = pskdemod(rx2,2);
        
%         datapack_ICD = BCH15_4Decode(hard_decision);
        datapack_ICD_AWGN = BCH15_4Decode(hd_awgn');
        datapack_ICD_Rayleigh = BCH15_4Decode(hd_rayleigh');
%         datapack_SPA_AWGN = LdpcDecode_SPA(llr_AWGN',Hbd,MaxIter);
%         datapack_SPA_Rayleigh = LdpcDecode_SPA(llr_Rayleigh',Hbd,MaxIter);
        datapack_chase2_AWGN = BDBCH_Chase2(tx1',Hbd);
%         datapack_SPARmFC = LdpcDecode_SPA(llr_RmFC',H74_RmFC,MaxIter);
%         datapack_SPARmFC2 = LdpcDecode_SPA(llr_RmFC2',HM,MaxIter);
%         datapack_SPARmFC2(end) = [];datapack_SPARmFC2(end) = [];
%         datapack_SPARmFC(end) = [];
        
%         datapack_SPA = BDBCH_SPA(hard_decision,H74,llr);
        
%         datapack_ICD(1:15) = hard_decision(1:15);
%         for jj = 1 :19%ICD译码
%             codeout = BCH15_4Decode(hard_decision(15*jj+1 : 15*jj+15));
%             datapack_ICD(15+11*(jj-1)+1 : 15+11*jj) = (double(codeout(1:11)'))';
%         end
%         
%         datapack_SPA(1:15) = hard_decision(1:15);
%         for jj = 1 :19%SPA译码
% %             codeout = BDBCH_SPA(real(rx1(15*jj+1 : 15*jj+15))',Hbd,ebno_vec(i_ebno));
%             codeout = LdpcDecode_SPA(real(rx1(15*jj+1 : 15*jj+15))',Hbd,ebno_vec(i_ebno));
%             datapack_SPA(15+11*(jj-1)+1 : 15+11*jj) = (double(codeout(1:11)'))';
%         end
        
%         chase2codeout(1:15) = hard_decision(1:15);
%         for jj = 1 :19
%             codeout = BDBCH_Chase2(info_bch_esti(15*jj+1 : 15*jj+15));
%             chase2codeout(15+11*(jj-1)+1 : 15+11*jj) = (double(codeout(1:11)'))';%codeout;
%         end
        
%         num_bit_err2(i_ebno) = num_bit_err2(i_ebno) + biterr(chase2codeout, info);
% 
%         
%         % 计算误码率
%         num_bit_err_chase(i_ebno) = num_bit_err_chase(i_ebno) + biterr(chase2codeout, info);
%         if any(chase2codeout ~= info)
%             num_pack_err_chase(i_ebno) =  num_pack_err_chase(i_ebno) + 1;   
%         end        
        
        if any(datapack_ICD_AWGN(1:K) ~= info')
            num_pack_err_ICD_AWGN(i_ebno) =  num_pack_err_ICD_AWGN(i_ebno) + 1; 
            num_bit_err_ICD_AWGN(i_ebno) = num_bit_err_ICD_AWGN(i_ebno) + sum(datapack_ICD_AWGN(1:K) ~= info');
        end 
        if any(datapack_ICD_Rayleigh(1:K) ~= info')
            num_pack_err_ICD_Rayleigh(i_ebno) =  num_pack_err_ICD_Rayleigh(i_ebno) + 1; 
            num_bit_err_ICD_Rayleigh(i_ebno) = num_bit_err_ICD_Rayleigh(i_ebno) + sum(datapack_ICD_Rayleigh(1:K) ~= info');
        end
        
        
%         if any(datapack_SPA_AWGN(1:K) ~= info')
%             num_pack_err_spa_AWGN(i_ebno) =  num_pack_err_spa_AWGN(i_ebno) + 1;   
%             num_bit_err_spa_AWGN(i_ebno) = num_bit_err_spa_AWGN(i_ebno) + sum(datapack_SPA_AWGN(1:K) ~= info');
%         end 
%         if any(datapack_SPA_Rayleigh(1:K) ~= info')
%             num_pack_err_spa_Rayleigh(i_ebno) =  num_pack_err_spa_Rayleigh(i_ebno) + 1;   
%             num_bit_err_spa_Rayleigh(i_ebno) = num_bit_err_spa_Rayleigh(i_ebno) + sum(datapack_SPA_Rayleigh(1:K) ~= info');
%         end
        
        if any(datapack_chase2_AWGN(1:K) ~= info')
            num_pack_err_chase2_AWGN(i_ebno) =  num_pack_err_chase2_AWGN(i_ebno) + 1;   
            num_bit_err_chase2_AWGN(i_ebno) = num_bit_err_chase2_AWGN(i_ebno) + sum(datapack_chase2_AWGN(1:K) ~= info');
        end
        % if any(datapack_SPARmFC ~= info)
        %     num_pack_err_spa2(i_ebno) =  num_pack_err_spa2(i_ebno) + 1;   
        %     num_bit_err_spa2(i_ebno) = num_bit_err_spa2(i_ebno) + sum(datapack_SPARmFC(1:4) ~= info');
        % end 
        % if any(datapack_SPARmFC2 ~= info)
        %     num_pack_err_spa3(i_ebno) =  num_pack_err_spa3(i_ebno) + 1;   
        %     num_bit_err_spa3(i_ebno) = num_bit_err_spa3(i_ebno) + sum(datapack_SPARmFC2(1:4) ~= info');
        % end 
    end
end


ber_ICD_AWGN = num_bit_err_ICD_AWGN./num_runs/K;
per_ICD_AWGN = num_pack_err_ICD_AWGN./num_runs;
ber_ICD_Rayleigh = num_bit_err_ICD_Rayleigh./num_runs/K;
per_ICD_Rayleigh = num_pack_err_ICD_Rayleigh./num_runs;

ber_spa_AWGN = num_bit_err_spa_AWGN./num_runs/K;
per_spa_AWGN = num_pack_err_spa_AWGN./num_runs;
ber_spa_Rayleigh = num_bit_err_spa_Rayleigh./num_runs/K;
per_spa_Rayleigh = num_pack_err_spa_Rayleigh./num_runs;

ber_chase2_AWGN = num_bit_err_chase2_AWGN./num_runs/K;
per_chase2_AWGN = num_pack_err_chase2_AWGN./num_runs;
ber_chase2_Rayleigh = num_bit_err_chase2_Rayleigh./num_runs/K;
per_chase2_Rayleigh = num_pack_err_chase2_Rayleigh./num_runs;

ber_spa2 = num_bit_err_spa2./num_runs/K;
ber_spa3 = num_bit_err_spa3./num_runs/K;
ber_chase = num_bit_err_chase./num_runs/K;

per_spa = num_pack_err_spa./num_runs;
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



% figure()
% p = semilogy(ebno_vec, [per_spa';ber_spa';ber';per']);
% grid on
% p(1).Marker = 's';
% p(1).Color = [0.04 0.58 0.68];%blue[0 0.447 0.741]
% p(1).LineStyle = '-';
% p(2).Marker = '^';
% p(2).Color = [0.466 0.674 0.188];%red[0.9261 0.1211 0.1409]
% p(2).LineStyle = '-';

% p(3).Marker = '<';
% p(3).Color = [0.203 0.338 0.6476];
% p(3).LineStyle = '-';

% p(4).Marker = 'x';
% p(4).Color = [0 0.447 0.741];
% p(4).LineStyle = '-';

% for k = 1 : 4
%     p(k).MarkerSize = 8;
%     p(k).LineWidth = 1.1;
% end

% l = legend('per_chase','ber_chase', 'ber', 'per');
% l.Location = 'SouthWest';

% xlabel('E_b/N_0 (dB)')
% ylabel('BER')
% set(gca, 'fontname', 'times new roman', 'fontsize', 11);
% set(gca,'XTick',(1:0.5:4));