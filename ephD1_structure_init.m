function eph= ephD1_structure_init()

%% ===== Decode the first subframe ==================================
% Pnum 1 ----------------------------------------------
eph.SatH1	= [];       %Sat health/1bit
eph.AODC	= [];       %Age of Data,Clock/5bit
eph.URAI	= [];       %User Range Accuracy Index/4bit
eph.WN      = [];       %Week Num/13bit
eph.t_oc	= [];       %钟差参数/17bit 2^3 s
eph.T_GD1	= [];       %星上设备时延差/10bit twosComp 0.1ns
eph.T_GD2	= [];
% The ionospheric parameters ----------------------------------------------
eph.alpha0	= [];       %twosComp 2^-30 8bit
eph.alpha1	= [];       %2^-27
eph.alpha2	= [];       %2^-24
eph.alpha3	= [];       %2^-24
eph.beta0	= [];       %2^11
eph.beta1	= [];       %2^14
eph.beta2	= [];       %2^16
eph.beta3	= [];       %2^16

eph.a2      = [];       %11bit 2^-66
eph.a0      = [];       %钟差参数/24bit twosComp 2^-33
eph.a1      = [];       %22bit 2^-50
eph.AODE    = [];       %Age of Data,Ephemeris/5bit

%% ===== Decode the second subframe ==================================
% The ephmeries parameters ----------------------------------------------
eph.deltan  = [];       %16bit twosComp 2^-43
eph.C_uc    = [];       %18bit twosComp 2^-31
eph.M_0      = [];       %32bit twosComp 2^-31
eph.e       = [];       %32bit 2^-33
eph.C_us    = [];       %18bit twosComp 2^-31
eph.C_rc    = [];       %18bit twosComp 2^-6
eph.C_rs    = [];       %18bit twosComp 2^-6
eph.sqrtA   = [];       %32bit 2^-19

%% ===== Decode the third subframe ==================================
eph.t_oe    = [];       %17bit 2^3
eph.i_0     = [];       %32bit twosComp 2^-31
eph.C_ic    = [];       %18bit twosComp 2^-31
eph.Omega_dot = [];     %24bit twosComp 2^-43
eph.C_is    = [];       %18bit twosComp 2^-31
eph.IDOT    = [];       %14bit twosComp 2^-43
eph.Omega_0 = [];       %32bit twosComp 2^-31
eph.omega   = [];       %32bit twosComp 2^-31

%% ===== Decode the fourth subframe ==================================
% The almanac parameters ----------------------------------------------
% eph.pnum
Almanac = struct('');