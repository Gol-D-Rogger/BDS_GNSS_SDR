function codeout = BDBCH_Chase2(x,H)
N = 15;
k = 11;
qnumber = 2;

% Chase2 decoding
for i_qnumber=1:length(qnumber)

    qnum = qnumber(i_qnumber);
    y1 = abs(x);%判断不可靠位
    y2 = pskdemod(x,2);%硬判决
    rxbpsk = 1 - 2*y2;
    leastReliablePos = zeros(1,qnum); %不可靠位的位置
    for i = 1 : qnum
        leastReliablePos(i) = find(y1 == min(y1));
        y1(leastReliablePos(i)) = 10;
    end
    
    tq=zeros(2^qnum,N);%构造测试序列
    for i = 1 : 2^qnum
        tq(i,:) = y2;
        for u = 1 : qnum
            tiu = mod(floor((i-1)/(2^(u-1))),2);
            tq(i,leastReliablePos(u)) = bitxor(tq(i,leastReliablePos(u)),tiu);
        end
    end
    
    testSeq = zeros(2^qnum,N);%bch码测试序列
    d_eu = zeros(2^qnum,1);%计算欧式距离
    s_d = zeros(2^qnum,4);
    
    for i=1:2^qnum
%         testSeq(i,:) = BCH15_4Decode((tq(i,:)));
        [~,~,ccode] = bchdec(gf(tq(i,:)),N,k);
        testSeq(i,:) = double(ccode.x);
        symdrome = gf(testSeq(i,:))*gf(H)';
        s_d(i,:) = double(symdrome.x);
        if any(symdrome.x ~= 0)%译码失败
%             testSeq(i,:)=y2;%硬译码
            testSeq(i,:)=zeros(1,N);
        end
        %判断译码是否合法

        d_eu(i,1) = sum(sqrt((testSeq(i,:) - y2).^2));%计算欧氏距离
    end
    
    lc = find(d_eu==min(d_eu));
    codeout = testSeq(lc(1),:);%译码结果为欧式距离最小的序列
        
%     if sum(sum(testSeq))~=0 %若译码合法
%         lc = find(d_eu==min(d_eu));
%         codeout = testSeq(lc(1),:);%译码结果为欧式距离最小的序列
%     else
%         codeout = BCH15_4Decode(y2);
%     end
end

end


