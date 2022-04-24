% function recvSignal = basicChannel(b3isignalcode)


% ������ʼ��
% ebno_vec = 3:0.5:8;
ebno_vec = 1:15;
K = 224;
N = 15;
max_runs = 1e4;
resolution = 10;
qnumber = 2;
num_bit_err_ICD_AWGN = zeros(length(ebno_vec), 1);
num_pack_err_ICD_AWGN = zeros(length(ebno_vec), 1);
num_bit_err_ICD_Rayleigh = zeros(length(ebno_vec), 1);
num_pack_err_ICD_Rayleigh = zeros(length(ebno_vec), 1);
num_bit_err_chase = zeros(length(ebno_vec), 1);
num_pack_err_chase = zeros(length(ebno_vec), 1);
num_runs = zeros(length(ebno_vec), 1);

enc = comm.BCHEncoder(15,11,'X^4 + X + 1');


tic
for i_run = 1 : max_runs
    if  mod(i_run, max_runs/resolution) == 1
        disp(' ');
        disp(['Sim iteration running = ' num2str(i_run)]);
        disp(['N = ' num2str(N) ' K = ' num2str(K)]);
        disp('The first column is the Eb/N0');
        disp('The second column is the PER of BCH.');
        disp('The third columns is the BER of BCH');
%         disp(num2str([ebno_vec'  num_bit_err_ICD_AWGN./num_runs/K num_bit_err_chase./num_runs/K num_pack_err./num_runs num_pack_err_chase./num_runs]));
        disp(' ');
    end
    
    info  = rand(1, K) > 0.5;
    info(1:15) = [1 1 1 0 0 0 1 0 0 1 0 0 0 0 0];
    info_bch(1:15) = info(1:15);
    for ii = 1 : 19
        info_bch(15*(ii-1)+16 : 15*ii+15) = step(enc, info(11*(ii-1)+16 : 11*ii+16-1).');
    end  %ģ�ⱱ��D1������һ֡��������Ϊһ�����ݰ�
    
    bpsk = 1 - 2 * info_bch';  % bpsk����
    for i_ebno = 1 : length(ebno_vec)
        rayleigh_h = (1/sqrt(2)*(randn(1,length(bpsk)) + 1j*randn(1,length(bpsk))))'; %��˹�ŵ��������ŵ�����
        hs = abs(rayleigh_h).*bpsk;
        
        tx1 = add_awgn_noise(bpsk,ebno_vec(i_ebno));
        tx2 = add_awgn_noise(hs,ebno_vec(i_ebno));
        rx2 = tx2./abs(rayleigh_h);
        
        num_runs(i_ebno) = num_runs(i_ebno) + 1;

        
        % ���AWGN
        hd_awgn = pskdemod(tx1,2);
        % ���Rayleigh
        hd_rayleigh = pskdemod(rx2,2);
        
        ICD_Codeout_AWGN(1:15) = hd_awgn(1:15);
        for jj = 1 :19%ICD����
            codeout = BCH15_4Decode(hd_awgn(15*jj+1 : 15*jj+15));
            ICD_Codeout_AWGN(15+11*(jj-1)+1 : 15+11*jj) = (double(codeout(1:11)'))';%codeout;
        end
        
        ICD_Codeout_Rayleigh(1:15) = hd_rayleigh(1:15);
        for jj = 1 :19%ICD����
            codeout = BCH15_4Decode(hd_rayleigh(15*jj+1 : 15*jj+15));
            ICD_Codeout_Rayleigh(15+11*(jj-1)+1 : 15+11*jj) = (double(codeout(1:11)'))';%codeout;
        end
        
%         Chase2_Codeout_AWGN(1:15) = hd_awgn(1:15);
%         for jj = 1 :19
%             codeout = BDBCH_Chase2(info_bch_esti(15*jj+1 : 15*jj+15));
%             Chase2_Codeout_AWGN(15+11*(jj-1)+1 : 15+11*jj) = (double(codeout(1:11)'))';%codeout;
%         end
        
%         num_bit_err2(i_ebno) = num_bit_err2(i_ebno) + biterr(chase2codeout, info);

        
        % ����������
%         num_bit_err_chase(i_ebno) = num_bit_err_chase(i_ebno) + biterr(Chase2_Codeout_AWGN, info);
%         if any(Chase2_Codeout_AWGN ~= info)
%             num_pack_err_chase(i_ebno) =  num_pack_err_chase(i_ebno) + 1;   
%         end        
        
        num_bit_err_ICD_AWGN(i_ebno) = num_bit_err_ICD_AWGN(i_ebno) + biterr(ICD_Codeout_AWGN, info);
        if any(ICD_Codeout_AWGN ~= info)
            num_pack_err_ICD_AWGN(i_ebno) =  num_pack_err_ICD_AWGN(i_ebno) + 1;   
        end 
        num_bit_err_ICD_Rayleigh(i_ebno) = num_bit_err_ICD_Rayleigh(i_ebno) + biterr(ICD_Codeout_Rayleigh, info);
        if any(ICD_Codeout_Rayleigh ~= info)
            num_pack_err_ICD_Rayleigh(i_ebno) =  num_pack_err_ICD_Rayleigh(i_ebno) + 1;   
        end
    end
end
toc

ber_ICD_AWGN = num_bit_err_ICD_AWGN./num_runs/K;
per_ICD_AWGN = num_pack_err_ICD_AWGN./num_runs;
ber_ICD_Rayleigh = num_bit_err_ICD_Rayleigh./num_runs/K;
per_ICD_Rayleigh = num_pack_err_ICD_Rayleigh./num_runs;
ber_chase = num_bit_err_chase./num_runs/K;
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
% p = semilogy(ebno_vec, [per_chase';ber_chase';ber';per']);
% grid on
% p(1).Marker = 's';
% p(1).Color = [0.04 0.58 0.68];%blue[0 0.447 0.741]
% p(1).LineStyle = '-';
% p(2).Marker = '^';
% p(2).Color = [0.466 0.674 0.188];%red[0.9261 0.1211 0.1409]
% p(2).LineStyle = '-';
% 
% p(3).Marker = '<';
% p(3).Color = [0.203 0.338 0.6476];
% p(3).LineStyle = '-';
% 
% p(4).Marker = 'x';
% p(4).Color = [0 0.447 0.741];
% p(4).LineStyle = '-';
% 
% for k = 1 : 4
%     p(k).MarkerSize = 8;
%     p(k).LineWidth = 1.1;
% end
% 
% l = legend('per_chase','ber_chase', 'ber', 'per');
% l.Location = 'SouthWest';
% 
% xlabel('E_b/N_0 (dB)')
% ylabel('BER')
% set(gca, 'fontname', 'times new roman', 'fontsize', 11);
% set(gca,'XTick',(1:0.5:4));