function c = BDBCH_Chase2(info_bch_esti) 
N = 15;
k = 11;  
qnumber = [2];
% Chase2 decoding
    for chase2_trial=1:length(qnumber)
        qnum = qnumber(chase2_trial);
        y1 = abs(info_bch_esti);%判断不可靠位
        y2 = (1-sign(info_bch_esti))./2;%硬判决
        lq = zeros(1,qnum); %不可靠位的位置
        for i = 1 : qnum
            lq(i) = find(y1 == min(y1));
            y1(lq(i)) = 10;
        end

        tq=zeros(2^qnum,N);%构造测试序列
        for i = 1 : 2^qnum
            tq(i,:) = y2;
            for u = 1 : qnum
                tiu = mod(floor((i-1)/(2^(u-1))),2);
                tq(i,lq(u)) = bitxor(tq(i,lq(u)),tiu);
            end
        end

        cq = zeros(2^qnum,k);%bch码测试序列
        l_yc = zeros(2^qnum,1);%计算欧式距离

        for i=1:2^qnum
            err=0;
            [y,err_bit] = bchdec(gf(tq(i,:)),N,k);
            cq(i,:) = double(y.x);
            if err_bit>2||err_bit==-1%译码失败
                cq(i,:)=tq(1:k);%硬译码
                err=1;
            end
            %判断译码是否合法
            if err==1
                cq(i,:)=zeros(1,k);
            end
            l_yc(i,1) = sum(sqrt((cq(i,:) - y2(1:k)').^2));
        end

        if sum(sum(cq))~=0 %若译码合法
            lc = find(l_yc==min(l_yc)); 
            c = cq(lc(1),1:k);%译码结果为欧式距离最小的序列
        else
            c = bchdec(tq(i,:),N,k);
        end
    end
end
