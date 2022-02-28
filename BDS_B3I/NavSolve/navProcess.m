function subframe = navProcess(subframe_ori)
% 对300bit的导航电文进行解调与解交织

subframe = zeros(1,224);
subframe(1:15) = subframe_ori(1:15);
subframe_undecode(1:30) = subframe_ori(1:30);
for j = 2:10
    subframe_undecode(30*(j-1)+1 : 30*j) = deinterleave(subframe_ori(30*(j-1)+1 : 30*j));
end
%---- BCH Decode -------------------------------------------
for jj = 2 :20
    codeout = BCH15_4Decode(subframe_undecode(15*(jj-1)+1 : 15*jj));
    subframe(11*(jj-1)+5 : 11*jj+4) = (double(codeout(1:11)));%codeout;
end
subframe = num2str(subframe')'; 

end