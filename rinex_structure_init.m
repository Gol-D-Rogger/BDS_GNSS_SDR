function rinex= rinex_structure_init()
%-----SV /EPOCH /SV CLK -------------------------------------
rinex.PRN = [];
rinex.yyyy	= [];       
rinex.mm	= [];      
rinex.dd	= [];    
rinex.hh      = [];      
rinex.mi	= [];      
rinex.ss	= [];       
rinex.a_f0	= [];       %SV clock bias
rinex.a_f1	= [];       %SV clock drift
rinex.a_f2	= [];       %SV clock drift rate
%-----BROADCAST ORBIT 每 1 ------------------------------------
rinex.AODE  = [];       %Age of Data,Ephemeris
rinex.C_rs	= [];       
rinex.deltan= [];       
rinex.M_0	= [];       
%-----BROADCAST ORBIT 每 2 ------------------------------------
rinex.C_uc	= [];
rinex.e     = [];       %Eccentricity
rinex.C_us	= [];       
rinex.sqrtA = [];     
%-----BROADCAST ORBIT 每 3 ------------------------------------
rinex.t_oe  = [];       %Time of Ephemeris(sec of BDT week)
rinex.C_ic  = [];     
rinex.Omega_0     = [];
rinex.C_is  = [];       
%-----BROADCAST ORBIT 每 4 ------------------------------------
rinex.i_0   = [];      
rinex.C_rc  = [];       
rinex.omega = [];       
rinex.Omega_dot = [];
%-----BROADCAST ORBIT 每 5 ------------------------------------
rinex.IDOT  = [];  
rinex.Spare1 = [];
rinex.BDTWeek = [];
rinex.Spare2 = [];
%-----BROADCAST ORBIT 每 6 ------------------------------------
rinex.accuracy = [];      %SV accuracy
rinex.SatH1 = [];         
rinex.T_GD1    = [];       
rinex.T_GD2    = [];     
%-----BROADCAST ORBIT 每 7 ------------------------------------
rinex.Trans_t = [];     %Transmission time of message(sec of BDT week)
rinex.AODC = [];       %32bit twosComp 2^-31
rinex.omega   = [];       %32bit twosComp 2^-31
