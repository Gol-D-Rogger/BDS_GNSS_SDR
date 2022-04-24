SNR=(2:1:8);
N_trials=10000;
N=255;
k=239;  
qnumber=[2,4];%最不可靠位数
Eb=1;
a=zeros(N_trials,length(SNR));
ber_m=zeros(length(qnumber),length(SNR));
ber_m0=zeros(1,length(SNR));%硬译码
ber_m1=zeros(1,length(SNR));%bch译码
parfor trial=1:N_trials
    msg=round(rand(1,k)); %生成信号
    s=bchenc(gf(msg),N,k);%编成bch码
    s0=s.x;
    s1=1-double(s0)*2;      %带奇偶校验位的bch码
    n1=randn(1,N)+1j.*randn(1,N);%初始噪声
    
    ber_v=zeros(length(qnumber),length(SNR));
    ber_v0=zeros(1,length(SNR));
    ber_v1=zeros(1,length(SNR));
    for w=1:1:length(SNR)
        snr_dB=SNR(w);
        snr1=10.^(snr_dB./10)/(k/(N));
        N01=Eb./snr1;
        sgma1=sqrt(N01./2);       %计算噪声大小
        y0=sqrt(Eb).*s1+sgma1.*n1;%接收的原始序列
        y1=(1-sign(real(y0)))./2; %译码
        
        %硬译码误码率
        error_bit0=sum(abs(msg-y1(1:k)));
        ber_v0(w)=error_bit0./k;
        
        c0=pbchdec(y1,N,k);
        %bch译码误码率
        error_bit1=sum(abs(msg-c0(1:k)));
        ber_v1(w)=error_bit1./k;
        
        %进行chase2译码
        for v=1:1:length(qnumber)
            qnum=qnumber(v);
            y2=abs(real(y0));%判断不可靠位
            lq=zeros(1,qnum); %不可靠位的位置
            for i=1:qnum
                lq(i)=find(y2==min(y2));
                y2(lq(i))=10;
            end
        
            tq=zeros(2^qnum,N);%构造测试序列
            for i=1:2^qnum
                tq(i,:)=y1;
                for u=1:qnum
                    tiu=mod(floor((i-1)/(2^(u-1))),2);
                    tq(i,lq(u))=bitxor(tq(i,lq(u)),tiu);
                end
            end
        
            cq=zeros(2^qnum,k);%bch码测试序列
            l_yc=zeros(2^qnum,1);%计算欧式距离
            y3=(1-real(y0))./2;
            for i=1:2^qnum
                [cq(i,:),err]=pbchdec(tq(i,:),N,k);
                %判断译码是否合法
                if err==1
                    cq(i,:)=zeros(1,k);
                end
                l_yc(i,1)=sum(sqrt((cq(i,:)-y3(1:k)).^2));
            end
            
            if sum(sum(cq))==0  %如果全部不合法
                %按bch译码计算误码率
                error_bit=sum(abs(msg-c0(1:k)));
                ber_v(v,w)=error_bit./k;
            else %译码合法
                lc=find(l_yc==min(l_yc)); 
                c=cq(lc(1),1:k);%译码结果为欧式距离最小的序列
                %chase译码误码率
                error_bit=sum(abs(msg-c));
                ber_v(v,w) =error_bit./k;
            end
        end
    end
    ber_m0=ber_m0+ber_v0;
    ber_m1=ber_m1+ber_v1;
    ber_m=ber_m+ber_v;
end
ber0=ber_m0./N_trials;%硬
ber1=ber_m1./N_trials;%bch
ber=ber_m./N_trials;%chase

%画误码率曲线
% semilogy(SNR,ber0,'-r',SNR,ber1,'-b',SNR,ber(1,:),'-g');
% xlabel('E_b/N_0(dB)');
% ylabel('BER');
% legend('硬译码','bch译码','chase2译码qnum=2');

semilogy(SNR,ber0,'-r',SNR,ber1,'-b',SNR,ber(1,:),'-g',SNR,ber(2,:),'-y');
xlabel('E_b/N_0(dB)');
ylabel('BER');
legend('硬译码','bch译码','chase2译码qnum=2','chase2译码qnum=4');

function [y,err]=pbchdec(x,N,k)
    z1=x(1:N);
    z2=gf(z1);
    [z3,err_bit]=bchdec(z2,N,k);
    y=double(z3.x);%bch译码
    err=0;
    if err_bit>2||err_bit==-1%译码失败
        y=x(1:k);%硬译码
        err=1;
    end
end

% qLevels = 2^nbits;
% %     xQuantiz8 = quantizn(x,qLevels);
% %     rseq = zeros(1,length(xQuantiz8));
% %     for i = 1 : length(xQuantiz8)
% %         if xQuantiz8(i) > 2^(nbits-1)-1
% %             rseq(i) = xQuantiz8(i) - (2^(nbits-1)-1);
% %         else 
% %             rseq(i) = (2^(nbits-1)-1) - xQuantiz8(i);
% %         end
% %     end
% 
% function xQuantiz = quantizn(x,qLevels)
% xStep = (max(x)-min(x))/qLevels;
% xLow = min(x);
% xHigh = max(x);
% partition = xLow+xStep : xStep :xHigh-xStep;
% % for i = xLow : xStep : xHigh
% %    for j = 1:length(x)
% %       if ((i-xStep/2)<x(j))&&(x(j)<(i+xStep/2))
% %           xQuantiz(j) = i;
% %       end
% %    end
% % end
% xQuantiz = quantiz(x,partition);
% end