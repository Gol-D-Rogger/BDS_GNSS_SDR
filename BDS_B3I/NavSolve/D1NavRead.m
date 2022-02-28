function eph = D1NavRead(bits)
%% Check if there is enough data ==========================================
% if length(bits) < 1500
%     error('The parameter BITS must contain 1500 bits!');
% end

%% Check if the parameters are strings ====================================
% if ~ischar(navBitsBin)
%     error('The parameter BITS must be a character array!');
% end
bdsPi = 3.1415926535898;

preamble_bits = [1 1 1 0 0 0 1 0 0 1 0];
global ephNum;
ephNum = 0;
% eph = ephD1_structure_init();
%% Decode all 5 sub-frames ================================================
for i = 1 : length(bits)/300
    
    %--- "Cut" one sub-frame's bits ---------------------------------------
    subframe_ori = bits(300*(i-1)+1 : 300*i);
    subframe_ori = subframe_ori - '0';
    if (subframe_ori(1:11) * preamble_bits' < 5)%确认电文是否反相
        subframe_ori = ~subframe_ori;
    end
   
    subframe = navProcess(subframe_ori);
    %--- Decode the sub-frame id ------------------------------------------
    subframeID = bin2dec(subframe(16:18));
    if subframeID >5 || subframeID <1  
        error('Wrong subframe ID , Data is not reliable!');
    end
    %--- Decode sub-frame based on the sub-frames id ----------------------
    
    switch subframeID 
        case 1  %--- It is subframe 1 ------------------------------------
            ephNum = ephNum + 1;
            eph(ephNum).Sub1.SOW         = bin2dec(subframe(19:38));
            eph(ephNum).Sub1.SatH1       = bin2dec(subframe(39));
            eph(ephNum).Sub1.AODC        = bin2dec(subframe(40:44));
            eph(ephNum).Sub1.URAI        = bin2dec(subframe(45:48));
            eph(ephNum).Sub1.WN          = bin2dec(subframe(49:61));
            eph(ephNum).Sub1.t_oc        = bin2dec(subframe(62:78)) * 2^3;
            eph(ephNum).Sub1.T_GD1       = twosComp2dec(subframe(79:88)) * 0.1;
            eph(ephNum).Sub1.T_GD2       = twosComp2dec(subframe(89:98)) * 0.1;
            eph(ephNum).Sub1.alpha0      = twosComp2dec(subframe(99:106)) * 2^(-30);
            eph(ephNum).Sub1.alpha1      = twosComp2dec(subframe(107:114)) * 2^(-27);
            eph(ephNum).Sub1.alpha2      = twosComp2dec(subframe(115:122)) * 2^(-24);
            eph(ephNum).Sub1.alpha3      = twosComp2dec(subframe(123:130)) * 2^(-24);
            eph(ephNum).Sub1.beta0       = twosComp2dec(subframe(131:138)) * 2^11;
            eph(ephNum).Sub1.beta1       = twosComp2dec(subframe(139:146)) * 2^14;
            eph(ephNum).Sub1.beta2       = twosComp2dec(subframe(147:154)) * 2^16;
            eph(ephNum).Sub1.beta3       = twosComp2dec(subframe(155:162)) * 2^16;
            eph(ephNum).Sub1.a2          = twosComp2dec(subframe(163:173)) * 2^(-66);
            eph(ephNum).Sub1.a0          = twosComp2dec(subframe(174:197)) * 2^(-33);
            eph(ephNum).Sub1.a1          = twosComp2dec(subframe(198:219)) * 2^(-50);
            eph(ephNum).Sub1.AODE        = bin2dec(subframe(220:224));
        case 2  %--- It is subframe 2 -------------------------------------
            eph(ephNum).Sub2.SOW         = bin2dec(subframe(19:38));
            eph(ephNum).Sub2.deltan      = twosComp2dec(subframe(39:54)) * 2^(-43) * bdsPi;
            eph(ephNum).Sub2.C_uc        = twosComp2dec(subframe(55:72)) * 2^(-31);
            eph(ephNum).Sub2.M_0         = twosComp2dec(subframe(73:104)) * 2^(-31) * bdsPi;
            eph(ephNum).Sub2.e           = bin2dec(subframe(105:136)) * 2^(-33);
            eph(ephNum).Sub2.C_us        = twosComp2dec(subframe(137:154)) * 2^(-31);
            eph(ephNum).Sub2.C_rc        = twosComp2dec(subframe(155:172)) * 2^(-6);
            eph(ephNum).Sub2.C_rs        = twosComp2dec(subframe(173:190)) * 2^(-6);
            eph(ephNum).Sub2.sqrtA       = bin2dec(subframe(191:222)) * 2^(-19);
            t_oe_MSB        = subframe(223:224);
        case 3  %--- It is subframe 3 -------------------------------------
            eph(ephNum).Sub3.SOW         = bin2dec(subframe(19:38));
            eph(ephNum).Sub3.t_oe        = bin2dec([t_oe_MSB subframe(39:53)]) * 2^3;
            eph(ephNum).Sub3.i_0         = twosComp2dec(subframe(54:85)) * 2^(-31) * bdsPi;
            eph(ephNum).Sub3.C_ic        = twosComp2dec(subframe(86:103)) * 2^(-31);
            eph(ephNum).Sub3.Omega_dot   = twosComp2dec(subframe(104:127)) * 2^(-43) * bdsPi;
            eph(ephNum).Sub3.C_is        = twosComp2dec(subframe(128:145)) * 2^(-31);
            eph(ephNum).Sub3.IDOT        = twosComp2dec(subframe(146:159)) * 2^(-43) * bdsPi;
            eph(ephNum).Sub3.Omega_0     = twosComp2dec(subframe(160:191)) * 2^(-31) * bdsPi;
            eph(ephNum).Sub3.omega       = twosComp2dec(subframe(192:223)) * 2^(-31) * bdsPi;
        case 4  %--- It is subframe 4 -------------------------------------
            Pnum       = bin2dec(subframe(40:46));
            AmEpID     = subframe(223:224);
            eph(ephNum).Sub4.Pnum      = Pnum;
            eph(ephNum).Sub4.SatID     = Pnum;
            eph(ephNum).Sub4.AmEpID    = AmEpID;
            eph(ephNum).Sub4.SOW       = bin2dec(subframe(19:38));
            eph(ephNum).Sub4.sqrtA     = bin2dec(subframe(47:70)) * 2^(-11);
            eph(ephNum).Sub4.a1        = twosComp2dec(subframe(71:81)) * 2^(-38);
            eph(ephNum).Sub4.a0        = twosComp2dec(subframe(82:92)) * 2^(-20);
            eph(ephNum).Sub4.Omega_0   = twosComp2dec(subframe(93:116)) * 2^(-23) * bdsPi;
            eph(ephNum).Sub4.e         = twosComp2dec(subframe(117:133)) * 2^(-21);
            eph(ephNum).Sub4.delta_i   = twosComp2dec(subframe(134:149)) * 2^(-19) * bdsPi;
            eph(ephNum).Sub4.t_oa      = bin2dec(subframe(150:157)) * 2^12;
            eph(ephNum).Sub4.Omega_dot = twosComp2dec(subframe(158:174)) * 2^(-38) * bdsPi;
            eph(ephNum).Sub4.omega     = twosComp2dec(subframe(175:198)) * 2^(-23) * bdsPi;
            eph(ephNum).Sub4.M_0       = twosComp2dec(subframe(199:222)) * 2^(-23);
        case 5  %--- It is subframe 5 -------------------------------------
            Pnum            = bin2dec(subframe(40:46));
            
            if Pnum >= 1 && Pnum <= 6
                AmEpID     = subframe(223:224);
                eph(ephNum).Sub5.AmEpID    = AmEpID;
               
                Pnum_Offset = 24;
                eph(ephNum).Sub5.SatID     = Pnum + Pnum_Offset;
                eph(ephNum).Sub5.Pnum      = Pnum;
                
                eph(ephNum).Sub5.SOW       = bin2dec(subframe(19:38));
                eph(ephNum).Sub5.sqrtA     = bin2dec(subframe(47:70)) * 2^(-11);
                eph(ephNum).Sub5.a1        = twosComp2dec(subframe(71:81)) * 2^(-38);
                eph(ephNum).Sub5.a0        = twosComp2dec(subframe(82:92)) * 2^(-20);
                eph(ephNum).Sub5.Omega_0   = twosComp2dec(subframe(93:116)) * 2^(-23) * bdsPi;
                eph(ephNum).Sub5.e          = twosComp2dec(subframe(117:133)) * 2^(-21);
                eph(ephNum).Sub5.delta_i   = twosComp2dec(subframe(134:149)) * 2^(-19) * bdsPi;
                eph(ephNum).Sub5.t_oa      = bin2dec(subframe(150:157)) * 2^12;
                eph(ephNum).Sub5.Omega_dot = twosComp2dec(subframe(158:174)) * 2^(-38) * bdsPi;
                eph(ephNum).Sub5.omega     = twosComp2dec(subframe(175:198)) * 2^(-23) * bdsPi;
                eph(ephNum).Sub5.M_0       = twosComp2dec(subframe(199:222)) * 2^(-23);
            elseif Pnum >= 11 && Pnum <= 23
                
%                 if ~strcmp(AmEpID ,'11')
%                     continue
%                 end
                AmID = subframe(223:224);
                if strcmp(AmID ,'01')
                    Pnum_Offset = 20;
                    eph(ephNum).Sub5.SatID     = Pnum + Pnum_Offset;
                elseif strcmp(AmID,'10')
                    Pnum_Offset = 33;
                    eph(ephNum).Sub5.SatID     = Pnum + Pnum_Offset;
                elseif strcmp(AmID,'11')
                    Pnum_Offset = 46;
                    eph(ephNum).Sub5.SatID     = Pnum + Pnum_Offset;
                end 
                eph(ephNum).Sub5.Pnum      = Pnum;
                eph(ephNum).Sub5.SOW       = bin2dec(subframe(19:38));
                eph(ephNum).Sub5.sqrtA     = bin2dec(subframe(47:70)) * 2^(-11);
                eph(ephNum).Sub5.a1        = twosComp2dec(subframe(71:81)) * 2^(-38);
                eph(ephNum).Sub5.a0        = twosComp2dec(subframe(82:92)) * 2^(-20);
                eph(ephNum).Sub5.Omega_0   = twosComp2dec(subframe(93:116)) * 2^(-23) * bdsPi;
                eph(ephNum).Sub5.e         = twosComp2dec(subframe(117:133)) * 2^(-21);
                eph(ephNum).Sub5.delta_i   = twosComp2dec(subframe(134:149)) * 2^(-19) * bdsPi;
                eph(ephNum).Sub5.t_oa      = bin2dec(subframe(150:157)) * 2^12;
                eph(ephNum).Sub5.Omega_dot = twosComp2dec(subframe(158:174)) * 2^(-38) * bdsPi;
                eph(ephNum).Sub5.omega     = twosComp2dec(subframe(175:198)) * 2^(-23) * bdsPi;
                eph(ephNum).Sub5.M_0       = twosComp2dec(subframe(199:222)) * 2^(-23);
            else
                switch Pnum
                    case 7
                        eph(ephNum).Sub5.Pnum       = 7;
                        eph(ephNum).Sub5.SOW        = bin2dec(subframe(19:38));
                        eph(ephNum).Sub5.Hea1       = bin2dec(subframe(47:55));
                        eph(ephNum).Sub5.Hea2       = bin2dec(subframe(56:64));
                        eph(ephNum).Sub5.Hea3       = bin2dec(subframe(65:73));
                        eph(ephNum).Sub5.Hea4       = bin2dec(subframe(74:82));
                        eph(ephNum).Sub5.Hea5       = bin2dec(subframe(83:91));
                        eph(ephNum).Sub5.Hea6       = bin2dec(subframe(92:100));
                        eph(ephNum).Sub5.Hea7       = bin2dec(subframe(101:109));
                        eph(ephNum).Sub5.Hea8       = bin2dec(subframe(110:118));
                        eph(ephNum).Sub5.Hea9       = bin2dec(subframe(119:127));
                        eph(ephNum).Sub5.Hea10      = bin2dec(subframe(128:136));
                        eph(ephNum).Sub5.Hea11      = bin2dec(subframe(137:145));
                        eph(ephNum).Sub5.Hea12      = bin2dec(subframe(146:154));
                        eph(ephNum).Sub5.Hea13      = bin2dec(subframe(155:163));
                        eph(ephNum).Sub5.Hea14      = bin2dec(subframe(164:172));
                        eph(ephNum).Sub5.Hea15      = bin2dec(subframe(173:181));
                        eph(ephNum).Sub5.Hea16      = bin2dec(subframe(182:190));
                        eph(ephNum).Sub5.Hea17      = bin2dec(subframe(191:199));
                        eph(ephNum).Sub5.Hea18      = bin2dec(subframe(200:208));
                        eph(ephNum).Sub5.Hea19      = bin2dec(subframe(209:217));
                    case 8
                        eph(ephNum).Sub5.Pnum        = 8;
                        eph(ephNum).Sub5.SOW         = bin2dec(subframe(19:38));
                        eph(ephNum).Sub5.Hea20       = bin2dec(subframe(47:55));
                        eph(ephNum).Sub5.Hea21       = bin2dec(subframe(56:64));
                        eph(ephNum).Sub5.Hea22       = bin2dec(subframe(65:73));
                        eph(ephNum).Sub5.Hea23       = bin2dec(subframe(74:82));
                        eph(ephNum).Sub5.Hea24       = bin2dec(subframe(83:91));
                        eph(ephNum).Sub5.Hea25       = bin2dec(subframe(92:100));
                        eph(ephNum).Sub5.Hea26       = bin2dec(subframe(101:109));
                        eph(ephNum).Sub5.Hea27       = bin2dec(subframe(110:118));
                        eph(ephNum).Sub5.Hea28       = bin2dec(subframe(119:127));
                        eph(ephNum).Sub5.Hea29       = bin2dec(subframe(128:136));
                        eph(ephNum).Sub5.Hea30       = bin2dec(subframe(137:145));
                        eph(ephNum).Sub5.WNa         = bin2dec(subframe(146:153));
                        eph(ephNum).Sub5.t_oa        = bin2dec(subframe(154:161));
                    case 9
                        eph(ephNum).Sub5.Pnum         = 9;
                        eph(ephNum).Sub5.SOW          = bin2dec(subframe(19:38));
                        eph(ephNum).Sub5.A_0GPS       = twosComp2dec(subframe(77:90)) * 0.1;
                        eph(ephNum).Sub5.A_1GPS       = twosComp2dec(subframe(91:106)) * 0.1;
                        eph(ephNum).Sub5.A_0Gal       = twosComp2dec(subframe(107:120)) * 0.1;
                        eph(ephNum).Sub5.A_1Gal       = twosComp2dec(subframe(121:136)) * 0.1;
                        eph(ephNum).Sub5.A_0GLO       = twosComp2dec(subframe(137:150)) * 0.1;
                        eph(ephNum).Sub5.A_1GLO       = twosComp2dec(subframe(151:166)) * 0.1;
                    case 10
                        eph(ephNum).Sub5.Pnum        = 10;
                        eph(ephNum).Sub5.SOW         = bin2dec(subframe(19:38));
                        eph(ephNum).Sub5.deltat_LS   = twosComp2dec(subframe(47:54));
                        eph(ephNum).Sub5.deltat_LSF  = twosComp2dec(subframe(55:62));
                        eph(ephNum).Sub5.WN_LSF      = bin2dec(subframe(63:70));
                        eph(ephNum).Sub5.A_0UTC      = twosComp2dec(subframe(71:102)) * 2^(-30);
                        eph(ephNum).Sub5.A_1UTC      = twosComp2dec(subframe(103:126)) * 2^(-50);
                        eph(ephNum).Sub5.DN          = bin2dec(subframe(127:134));
                    case 24
                        eph(ephNum).Sub5.Pnum        = 24;
                        eph(ephNum).Sub5.SOW         = bin2dec(subframe(19:38));
                        eph(ephNum).Sub5.Hea31       = bin2dec(subframe(47:55));
                        eph(ephNum).Sub5.Hea32       = bin2dec(subframe(56:64));
                        eph(ephNum).Sub5.Hea33       = bin2dec(subframe(65:73));
                        eph(ephNum).Sub5.Hea34       = bin2dec(subframe(74:82));
                        eph(ephNum).Sub5.Hea35       = bin2dec(subframe(83:91));
                        eph(ephNum).Sub5.Hea36       = bin2dec(subframe(92:100));
                        eph(ephNum).Sub5.Hea37       = bin2dec(subframe(101:109));
                        eph(ephNum).Sub5.Hea38       = bin2dec(subframe(110:118));
                        eph(ephNum).Sub5.Hea39       = bin2dec(subframe(119:127));
                        eph(ephNum).Sub5.Hea40       = bin2dec(subframe(128:136));
                        eph(ephNum).Sub5.Hea41       = bin2dec(subframe(137:145));
                        eph(ephNum).Sub5.Hea42       = bin2dec(subframe(146:154));
                        eph(ephNum).Sub5.Hea43       = bin2dec(subframe(155:163));
                        eph(ephNum).Sub5.AmID        = bin2dec(subframe(164:165));
                end
            end
    end % switch subframeID ...
    
end % for all 5 sub-frames ...
