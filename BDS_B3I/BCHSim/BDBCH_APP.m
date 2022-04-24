function [ber,per] = BDBCH_APP(ebno_vec)


% 参数初始化
% K = 224;
K = 11;
N = 15;
R = K/N;%code rate
max_runs = 1e5;
resolution = 10;
MaxIter = 10;
qnumber = 2;
num_bit_err_chase = zeros(length(ebno_vec), 1);
num_bit_err = zeros(length(ebno_vec), 1);
num_bit_err_spa = zeros(length(ebno_vec), 1);
num_bit_err_spa2 = zeros(length(ebno_vec), 1);
num_bit_err_spa3 = zeros(length(ebno_vec), 1);
num_pack_err = zeros(length(ebno_vec), 1);
num_pack_err_spa = zeros(length(ebno_vec), 1);
num_pack_err_spa2 = zeros(length(ebno_vec), 1);
num_pack_err_spa3 = zeros(length(ebno_vec), 1);
num_pack_err_chase = zeros(length(ebno_vec), 1);
num_runs = zeros(length(ebno_vec), 1);

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
dec = comm.BCHDecoder(15,11,'X^4 + X + 1');


for i_run = 1 : max_runs
    if  mod(i_run, max_runs/resolution) == 1
        disp(' ');
        disp(['Sim iteration running = ' num2str(i_run)]);
        disp(['N = ' num2str(N) ' K = ' num2str(K)]);
        disp('The first column is the Eb/N0');
        disp('The second column is the PER of BCH.');
        disp('The third columns is the BER of BCH');
        disp(num2str([ebno_vec'  num_bit_err./num_runs/K num_bit_err_spa./num_runs/K num_pack_err./num_runs num_pack_err_chase./num_runs]));
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
    noise = randn(N,1);
    for i_ebno = 1 : length(ebno_vec)
        sigma = 1/sqrt(2 * R) * 10^(-ebno_vec(i_ebno)/20);
        y = bpsk + sigma * noise;
        llr = 2/sigma^2*y;
        llr_RmFC = llr;
        llr_RmFC(end+1) = 0;%打孔比特LLR置零
        llr_RmFC2 = llr;
        llr_RmFC2(end+1) = 0;
        llr_RmFC2(end+1) = 0;
        
        num_runs(i_ebno) = num_runs(i_ebno) + 1;

        
        % 解调AWGN
        info_bch_esti = real(y);
        hard_decision = zeros(1,length(info_bch_esti));
        hard_decision(info_bch_esti<=0)=1;
        hard_decision(info_bch_esti>0)=0;  %硬判决
        
        % 解调Rayleigh
%         info_bch_esti2 = real(rx2);
%         hard_decision2 = zeros(1,length(info_bch_esti2));
%         hard_decision2(info_bch_esti2<=0)=1;
%         hard_decision2(info_bch_esti2>0)=0;  %硬判决
%         
%         datapack_ICD = BCH15_4Decode(hard_decision);
        datapack_ICD = step(dec,hard_decision');
%         datapack_SPA = LdpcDecode_SPA(llr',H74,MaxIter);
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
        
        if any(datapack_ICD ~= info)
            num_pack_err(i_ebno) =  num_pack_err(i_ebno) + 1; 
            num_bit_err(i_ebno) = num_bit_err(i_ebno) + sum(datapack_ICD(1:K) ~= info);
        end 
        
        
%         if any(datapack_SPA ~= info)
%             num_pack_err_spa(i_ebno) =  num_pack_err_spa(i_ebno) + 1;   
%             num_bit_err_spa(i_ebno) = num_bit_err_spa(i_ebno) + sum(datapack_SPA(1:K) ~= info');
%         end 
%         if any(datapack_SPARmFC ~= info)
%             num_pack_err_spa2(i_ebno) =  num_pack_err_spa2(i_ebno) + 1;   
%             num_bit_err_spa2(i_ebno) = num_bit_err_spa2(i_ebno) + sum(datapack_SPARmFC(1:K) ~= info');
%         end 
%         if any(datapack_SPARmFC2 ~= info)
%             num_pack_err_spa3(i_ebno) =  num_pack_err_spa3(i_ebno) + 1;   
%             num_bit_err_spa3(i_ebno) = num_bit_err_spa3(i_ebno) + sum(datapack_SPARmFC2(1:K) ~= info');
%         end 
    end
end


ber = num_bit_err./num_runs/K;
ber_spa = num_bit_err_spa./num_runs/K;
ber_spa2 = num_bit_err_spa2./num_runs/K;
ber_spa3 = num_bit_err_spa3./num_runs/K;
ber_chase = num_bit_err_chase./num_runs/K;

per = num_pack_err./num_runs;
per_spa = num_pack_err_spa./num_runs;
per_chase = num_pack_err_chase./num_runs;