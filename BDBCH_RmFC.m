Hbd = [1 1 1 1 0 1 0 1 1 0 0 1 0 0 0;...
       0 1 1 1 1 0 1 0 1 1 0 0 1 0 0;...
       0 0 1 1 1 1 0 1 0 1 1 0 0 1 0;...
       1 1 1 0 1 0 1 1 0 0 1 0 0 0 1];

tg_bd = tanner_graph(Hbd);
figure
plot(tg_bd)
HECF = rref(Hbd);
HECF(HECF == 2) = 0;
HECF(HECF == -1) = 1;
tg_bd_ecf = tanner_graph(HECF);
plot(tg_bd_ecf)

H = [1 0 0 1 1 0 1;...
     0 1 0 1 0 1 1;...
     0 0 1 0 1 1 1];% Example in Iterative-Decoding
A2 = blkdiag(H*H.',H.'*H);
tg = tanner_graph(H);
plot(tg)

H = [1 0 0 0 1 1 0 1 1;...
     0 1 0 1 0 1 1 0 0;...
     0 0 1 0 1 1 1 1 0];%Example in Sum-Product
tg = tanner_graph(H);
plot(tg)