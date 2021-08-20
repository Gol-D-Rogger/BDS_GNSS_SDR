D1Data = initSimD1Data();
navmsg = strcat(D1Data.Pre,D1Data.Rev,D1Data.FraID,D1Data.SOW,D1Data.SatH1,...
                D1Data.AODC,D1Data.URAI,D1Data.WN,D1Data.Toc,D1Data.TGD1,...
                D1Data.TGD2,D1Data.alpha0,D1Data.alpha1,D1Data.alpha2,...
                D1Data.alpha3,D1Data.beta0,D1Data.beta1,D1Data.beta2,...
                D1Data.beta3,D1Data.a2,D1Data.a0,D1Data.a1,D1Data.AODE);

navmsg = (double(navmsg) - '0');

% navmsg = rand(1,224);
% navmsg(navmsg>0.5) = 1;
% navmsg(navmsg<=0.5) = 0;
navbch(1:15) = navmsg(1:15);
for i = 1 :19
    navbch(15*(i-1)+16 : 15*i+15) = BCH15_4Encode(navmsg(11*(i-1)+16 : 11*i+16-1));
end
navdata(1:30) = navbch(1:30);
for j = 2:10
	navdata(30*(j-1)+1 : 30*j) = interleave(navbch(30*(j-1)+1 : 30*j));
end

subframe(1:30) = navdata(1:30); 
for j = 2:10
    subframe(30*(j-1)+1 : 30*j) = deinterleave(navdata(30*(j-1)+1 : 30*j));
end

% oridata = [subframe(1:26)];

a=isequal(navbch,subframe)