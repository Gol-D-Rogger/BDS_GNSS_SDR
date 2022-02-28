ebno_vec = 2:1:8;
max_runs = 1000;
N=255;
k=239;  
qnumber=[2,4];%最不可靠位数
Eb=1;
a=zeros(max_runs,length(ebno_vec));
ber_m=zeros(length(qnumber),length(ebno_vec));
ber_m0=zeros(1,length(ebno_vec));%硬译码
ber_m1=zeros(1,length(ebno_vec));%bch译码
for i_runs = 1 : max_runs
    msg=round(rand(1,k)); %生成信号
    s=bchenc(gf(msg),N,k);%编成bch码
    s0=s.x;
    bit_s=0;              %奇偶校验位
    for i=1:1:k
        bit_s=bitxor(bit_s,s0(i));
    end
    s1=1-double([s0,bit_s])*2;      %带奇偶校验位的bch码
    n1=randn(1,N+1)+1j.*randn(1,N+1);%初始噪声
    
    ber_v=zeros(length(qnumber),length(ebno_vec));
    ber_v0=zeros(1,length(ebno_vec));
    ber_v1=zeros(1,length(ebno_vec));
    for i_ebno=1 : length(ebno_vec)
        snr_dB=ebno_vec(i_ebno);
        snr1=10.^(snr_dB./10)/(k/(N+1));
        N01=Eb./snr1;
        sgma1=sqrt(N01./2);       %计算噪声大小
        y0=sqrt(Eb).*s1+sgma1.*n1;%接收的原始序列
        y1=(1-sign(real(y0)))./2; %译码
        
%         y0 = awgn(bpsk,ebno_vec(i_ebno));
        
        %硬译码误码率
        error_bit0=biterr(msg, y1(1:k));
        ber_v0(i_ebno)=error_bit0./k;
        
        c0=pbchdec(y1,N,k);
        %bch译码误码率
        error_bit1 = biterr(msg, c0(1:k));
        ber_v1(i_ebno) = error_bit1/k;
        
        %进行chase2译码
        for v=1:1:length(qnumber)
            qnum=qnumber(v);
            y2=abs(real(y0));%判断不可靠位
            leastReliablePos=zeros(1,qnum); %不可靠位的位置
            for i=1:qnum
                leastReliablePos(i)=find(y2==min(y2));
                y2(leastReliablePos(i))=10;
            end
        
            testSeq=zeros(2^qnum,N+1);%构造测试序列
            for i=1:2^qnum
                testSeq(i,:)=y1;
                for u=1:qnum
                    tiu=mod(floor((i-1)/(2^(u-1))),2);
                    testSeq(i,leastReliablePos(u))=bitxor(testSeq(i,leastReliablePos(u)),tiu);
                end
            end
        
            cq=zeros(2^qnum,k);%bch码测试序列
            d_eu=zeros(2^qnum,1);%计算欧式距离
            y3=(1-real(y0))./2;
            for i=1:2^qnum
                [cq(i,:),err]=pbchdec(testSeq(i,:),N,k);
                %判断译码是否合法
                if err==1
                    cq(i,:)=zeros(1,k);
                end
                d_eu(i,1)=sum(sqrt((cq(i,:)-y3(1:k)).^2));
            end
            
            if sum(sum(cq))==0  %如果全部不合法
                %按bch译码计算误码率
                error_bit=biterr(msg, c0(1:k));
                ber_v(v,i_ebno)=error_bit/k;
            else %译码合法
                lc=find(d_eu==min(d_eu)); 
                c=cq(lc(1),1:k);%译码结果为欧式距离最小的序列
                %chase译码误码率
                error_bit=biterr(msg, c);
                ber_v(v,i_ebno) =error_bit/k;
            end
        end
    end
    ber_m0=ber_m0+ber_v0;
    ber_m1=ber_m1+ber_v1;
    ber_m=ber_m+ber_v;
end
ber0=ber_m0./max_runs;
ber1=ber_m1./max_runs;
ber=ber_m./max_runs;

%画误码率曲线
figure
p = semilogy(ebno_vec,ber0,'-r',ebno_vec,ber1,'-b',ebno_vec,ber(1,:),'-g',ebno_vec,ber(2,:),'-y');
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
    p(k).MarkerSize = 9;
    p(k).LineWidth = 1.1;
end
l = legend('hard decision','bch decoding','chase2 qnum=2','chase2 qnum=4');
l.Location = 'SouthWest';

xlabel('E_b/N_0 (dB)')
ylabel('BER')
set(gca, 'fontname', 'times new roman', 'fontsize', 11);
set(gca,'XTick',(1:0.5:4));

function [y,err]=pbchdec(x,N,k)
    bit_z=x(N+1);%取出奇偶校验位
    z1=x(1:N);
    z2=gf(z1);
    [z3,err_bit]=bchdec(z2,N,k);
    y=double(z3.x);%bch译码
    for i=1:1:k
        bit_z=bitxor(bit_z,y(i));
    end
    err=0;
    if bit_z==1||err_bit>2||err_bit==-1%译码失败
        y=x(1:k);%硬译码
        err=1;
    end
end
