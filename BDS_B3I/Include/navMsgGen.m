preamble_bits = [1 1 1 0 0 0 1 0 0 1 0];
rev = [0 0 0 0];
FraID = [[0 0 1] ;[0 1 0] ;[0 1 1] ;[1 0 0] ;[1 0 1]];

nav = double(rand(1,206) < 0.5);

navmsg = cat(preamble_bits,rev,FraID(1,:));

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