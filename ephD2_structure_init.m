function eph= ephD2_structure_init()

%% ===== Decode the first subframe ==================================
% Pnum 1 ----------------------------------------------
eph.SatH1	= [];       %Sat health/1bit
eph.AODC	= [];       %Age of Data,Clock/5bit
eph.URAI	= [];       %User Range Accuracy Index/4bit
eph.WN      = [];       %Week Num/13bit
eph.t_oc	= [];       %钟差参数/17bit 2^3 s
eph.T_GD1	= [];       %星上设备时延差/10bit twosComp 0.1ns
eph.T_GD2	= [];

% Pnum 2 ----------------------------------------------
% The ionospheric parameters ----------------------------------------------
eph.alpha0	= [];       %twosComp 2^-30 8bit
eph.alpha1	= [];       %2^-27
eph.alpha2	= [];       %2^-24
eph.alpha3	= [];       %2^-24
eph.beta0	= [];       %2^11
eph.beta1	= [];       %2^14
eph.beta2	= [];       %2^16
eph.beta3	= [];       %2^16

% Pnum 3 ----------------------------------------------
eph.a0      = [];       %钟差参数/24bit twosComp 2^-33

% Pnum 4 ----------------------------------------------
eph.a1      = [];       %22bit 2^-50
eph.a2      = [];       %11bit 2^-66
eph.AODE    = [];       %Age of Data,Ephemeris/5bit
% The ephmeries parameters ----------------------------------------------
eph.deltan  = [];       %16bit twosComp 2^-43

% Pnum 5 ----------------------------------------------
eph.C_uc    = [];       %18bit twosComp 2^-31
eph.M_0      = [];       %32bit twosComp 2^-31
eph.C_us    = [];       %18bit twosComp 2^-31

% Pnum 6 ----------------------------------------------
eph.e       = [];       %32bit 2^-33
eph.sqrtA   = [];       %32bit 2^-19

% Pnum 7 ----------------------------------------------
eph.C_ic    = [];       %18bit twosComp 2^-31
eph.C_is    = [];       %18bit twosComp 2^-31
eph.t_oe    = [];       %17bit 2^3

% Pnum 8 ----------------------------------------------
eph.i_0     = [];       %32bit twosComp 2^-31
eph.C_rc    = [];       %18bit twosComp 2^-6
eph.C_rs    = [];       %18bit twosComp 2^-6

% Pnum 9 ----------------------------------------------
eph.Omega_dot = [];     %24bit twosComp 2^-43
eph.Omega_0 = [];       %32bit twosComp 2^-31

% Pnum 10 ----------------------------------------------
eph.omega   = [];       %32bit twosComp 2^-31
eph.IDOT    = [];       %14bit twosComp 2^-43
%% ===== Decode the second subframe =================================
% Week No.
eph.WN  = [];
% HOW
eph.HOW  = [];
% IODC
eph.IODC = [];
% IODE
eph.IODE = [];

% --- Ephemeris I ---------------------------------------------------------
% Ephemeris data reference time of week
eph.t_oe        = [];
% Satellite Type
eph.SatType     = [];
% Semi-major axis difference at reference time
eph.deltaA      = [];
% Change rate in semi-major axis
eph.ADot        = [];
% Mean Motion difference from computed value at reference time
eph.delta_n_0   = [];
% IRate of mean motion difference from computed value
eph.delta_n_0Dot= [];
% Mean anomaly at reference time
eph.M_0         = [];
% Eccentricity
eph.e           = [];
% Argument of perigee
eph.omega       = [];

% --- Ephemeris II --------------------------------------------------------
% Longitude of Ascending Node of Orbit Plane at Weekly Epoch
eph.omega_0     = [];
% Inclination angle at reference time
eph.i_0         = [];
% Rate of right ascension difference
eph.omegaDot  = [];
% Rate of inclination angle
eph.i_0Dot      = [];
% Amplitude of the sine harmonic correction term to the angle of inclination
eph.C_is        = [];
% Amplitude of the cosine harmonic correction term to the angle of inclination
eph.C_ic        = [];
% Amplitude of the sine correction term to the orbit radius
eph.C_rs        = [];
% Amplitude of the cosine correction term to the orbit radius
eph.C_rc        = [];
% Amplitude of the sine harmonic correction term to the argument of latitude
eph.C_us        = [];
% Amplitude of the cosine harmonic correction term to the argument of latitude
eph.C_uc        = [];

% --- SV clock error parameters -------------------------------------------
% Clock Data Reference Time of Week
eph.t_oc        = [];
% SV Clock Bias Correction Coefficient
eph.a_0        = [];
% SV Clock Drift Correction Coefficient
eph.a_1        = [];
% SV Clock Drift Rate Correction Coefficient
eph.a_2        = [];

% --- Remaining parts of the second subframe-------------------------------
eph.T_GDB2ap        = [];
eph.ISC_B1Cd        = [];
eph.T_GDB1Cp        = [];


%% ===== Decode the third subframe ==================================
% PageID
eph.PageID1   = [];
eph.PageID3   = [];
% Heath state
eph.HS       = [];
% DIF
eph.DIF      = [];
% SIF
eph.SIF      = [];
% AIF
eph.AIF      = [];
% SISMAI
eph.SISMAI   = [];

% other parts of subframe 3

% The ionospheric parameters ----------------------------------------------
eph.alpha1      = [];
eph.alpha2      = [];
eph.alpha3      = [];
eph.alpha4      = [];
eph.alpha5       = [];
eph.alpha6       = [];
eph.alpha7       = [];
eph.alpha8       = [];
eph.alpha9       = [];

% BDT-UTC -----------------------------------------------------------------
eph.A_0UTC        = [];
eph.A_1UTC        = [];
eph.A_2UTC        = [];
eph.delta_t_LS    = [];
eph.t_ot          = [];
eph.WN_ot         = [];
eph.WN_LSF        = [];
eph.DN            = [];
eph.delta_t_LSF   = [];

% BGTO --------------------------------------------------------------------
% GNSS ID
eph.GNSS_ID   = [];
eph.WN_0BGTO   = [];
eph.t_0BGTO   = [];
eph.A_0BGTO   = [];
eph.A_1BGTO   = [];
eph.A_2BGTO   = [];

% All required B-CNAV1 sub-frame message has been decoded
eph.flag = [];
% Time of Week
eph.TOW = [];

