function b3isignalcode = D1NavMsgEncode(PRN,pb3i)
global settings;
D1Data = initSimD1Msg();
sub1 = strcat(D1Data.sub1.Pre,D1Data.sub1.Rev,D1Data.sub1.FraID,D1Data.sub1.SOW,D1Data.sub1.SatH1,...
                D1Data.sub1.AODC,D1Data.sub1.URAI,D1Data.sub1.WN,D1Data.sub1.Toc,D1Data.sub1.TGD1,...
                D1Data.sub1.TGD2,D1Data.sub1.alpha0,D1Data.sub1.alpha1,D1Data.sub1.alpha2,...
                D1Data.sub1.alpha3,D1Data.sub1.beta0,D1Data.sub1.beta1,D1Data.sub1.beta2,...
                D1Data.sub1.beta3,D1Data.sub1.a2,D1Data.sub1.a0,D1Data.sub1.a1,D1Data.sub1.AODE);
sub2 = strcat(D1Data.sub2.Pre,D1Data.sub2.Rev,D1Data.sub2.FraID,D1Data.sub2.SOW,...
	            D1Data.sub2.deltan,D1Data.sub2.C_uc,D1Data.sub2.M_0,D1Data.sub2.e,D1Data.sub2.C_us,...
	            D1Data.sub2.C_rc,D1Data.sub2.C_rs,D1Data.sub2.sqrtA,D1Data.sub2.t_oe_MSB);
sub3 = strcat(D1Data.sub3.Pre,D1Data.sub3.Rev,D1Data.sub3.FraID,D1Data.sub3.SOW,...
	            D1Data.sub3.t_oe_LSB,D1Data.sub3.i_0,D1Data.sub3.C_ic,D1Data.sub3.Omega_dot,...
	            D1Data.sub3.C_is,D1Data.sub3.IDOT,D1Data.sub3.Omega_0,D1Data.sub3.omega,D1Data.sub3.Rev_end);
navmsg = strcat(sub1,sub2,sub3);

fs = settings.codeFreqBasis;      
fnh = settings.codeFreqBasis/settings.codeLength;        % NH码率
fnav = fnh/20;        % 导航电文码率

% fs = 2.55e5;      
% fnh = fs/255;        % NH码率
% fnav = fnh/20; 

navmsg = (double(navmsg) - '0');

%% BCH编码与交织
navdata = zeros(1,length(navmsg));
for i = 1 : length(navmsg)/224
	subframe = navmsg(224*(i-1)+1 : 224*i);

	navbch(1:15) = subframe(1:15);
	for ii = 1 : 19
	    navbch(15*(ii-1)+16 : 15*ii+15) = BCH15_4Encode(subframe(11*(ii-1)+16 : 11*ii+16-1));
	end
	navdata_sub(1:30) = navbch(1:30);
	for j = 2 : 10
		navdata_sub(30*(j-1)+1 : 30*j) = interleave(navbch(30*(j-1)+1 : 30*j));
	end
	navdata(300*(i-1)+1 : 300*i) = navdata_sub;
end
% navdata = num2str(navdata')';

%% 二次编码
code = b3iCodeGen(PRN);
NH = [0,0,0,0,0,1,0,0,1,1,0,1,0,1,0,0,1,1,1,0]';
t   = (1/fs:1/fs:length(navdata)/50).';%length(navdata)/50

% pnSequence = comm.PNSequence('Polynomial',[8 2 0], ...
%     'SamplesPerFrame',255,'InitialConditions',[0 0 0 0 0 0 0 1]);
% code = pnSequence();
% b3isignalcode = navdata(ceil(t*fnav))' .* NH(mod(floor(t*fnh),20)+1).*...
%     code(mod(floor(t*fs),255)+1);

% amp = 10^((pb3i+3)/20);
b3isignalcode = navdata(ceil(t*fnav))' .* NH(mod(floor(t*fnh),20)+1).*...
    code(mod(floor(t*settings.codeFreqBasis),settings.codeLength)+1);
end

% genpoly = bchgenpoly(N,K,'D^4 + D^3 + 1');
% bchEncoder = comm.BCHEncoder(N,K,genpoly);
