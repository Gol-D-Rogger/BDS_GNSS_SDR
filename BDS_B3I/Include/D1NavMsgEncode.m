function navdata = D1NavMsgEncode(PRN,pb3i)
%global settings;
D1Data = initSimD1Msg();
navmsg = strcat(D1Data.Pre,D1Data.Rev,D1Data.FraID,D1Data.SOW,D1Data.SatH1,...
                D1Data.AODC,D1Data.URAI,D1Data.WN,D1Data.Toc,D1Data.TGD1,...
                D1Data.TGD2,D1Data.alpha0,D1Data.alpha1,D1Data.alpha2,...
                D1Data.alpha3,D1Data.beta0,D1Data.beta1,D1Data.beta2,...
                D1Data.beta3,D1Data.a2,D1Data.a0,D1Data.a1,D1Data.AODE);
% fs = settings.codeFreqBasis;      
% fnh = settings.codeFreqBasis/settings.codeLength;        % NH码率
% fnav = fnh/20;        % 导航电文码率

navmsg = (double(navmsg) - '0');
navbch(1:15) = navmsg(1:15);
for i = 1 :19
    navbch(15*(i-1)+16 : 15*i+15) = BCH15_4Encode(navmsg(11*(i-1)+16 : 11*i+16-1));
end
navdata(1:30) = navbch(1:30);
for j = 2:10
	navdata(30*(j-1)+1 : 30*j) = interleave(navbch(30*(j-1)+1 : 30*j));
end

% code = b3iCodeGen(PRN);
% NH = [-1,-1,-1,-1,-1, 1,-1,-1, 1, 1,...
%       -1, 1,-1, 1,-1,-1, 1, 1, 1,-1]';
% t   = (1/fs:1/fs:length(navEncoded)/50).';
% % amp = 10^((pb3i+3)/20);
% b3i = navEncoded(ceil(t*fnav)) .* NH(mod(floor(t*fnh),20)+1).*...
%     code(mod(floor(t*settings.codeFreqBasis),settings.codeLength)+1); %.* cos(2*pi*settings.carrFreqBasis*t);
% % navData = reshape(repmat(navD',1,20*10230),1,[]);
% % NHData = reshape(repmat(NH,1,10230),1,[]);
end

% genpoly = bchgenpoly(N,K,'D^4 + D^3 + 1');
% bchEncoder = comm.BCHEncoder(N,K,genpoly);
