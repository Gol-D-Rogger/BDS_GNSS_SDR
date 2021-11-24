nav = round(rand(1,110000));
navBch = [];
for i = 1 : length(nav)/11
    navBch = [navBch BCH15_4Encode(nav(i*11-10 : i*11))];
end
tic
codeout = [];
for i = 1 : length(navBch)/15
    codeout = [codeout BCH15_4Decode(navBch(i*15-14 : i*15))];
    codeout = [codeout BCH15_4DecodeParallel(navBch(i*15-14 : i*15))];
end
toc