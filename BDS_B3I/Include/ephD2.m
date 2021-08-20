function [eph, SOW] = ephemeris_D2(bits)
%% Check if there is enough data ==========================================
% if length(bits) < 1500
%     error('The parameter BITS must contain 1500 bits!');
% end

%% Check if the parameters are strings ====================================


% Pi used in the GPS coordinate system
bdsPi = 3.1415926535898;

preamble_bits = [1,1,1,0,0,0,1,0,0,1,0];
eph = ephD2_structure_init();
%% Decode all 5 sub-frames ================================================
for i = 1 : 5
    
    %--- "Cut" one sub-frame's bits ---------------------------------------
    subframe_ori = bits(300*(i-1)+1 : 300*i);
%     if ((preamble_bits*subframe(1:11)) < 5 )
%         subframe = ~subframe;
%     end
    %--- Correct polarity of the data bits in all 10 words ----------------

    subframe(1:30) = subframe_ori(1:30);
    for j = 2:10
        subframe(30*(j-1)+1 : 30*j) = deinterleave(subframe_ori(30*(j-1)+1 : 30*j));
    end
    subframe = num2str(subframe')';
    %--- Decode the sub-frame id ------------------------------------------

    subframeID = bin2dec(subframe(16:18));
    if subframeID >5 || subframeID <1  
    	error('Wrong subframe ID , Data is not reliable!');
    end
    %--- Decode sub-frame based on the sub-frames id ----------------------
    SOW = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
    if subframeID == 1 %--- It is subframe 1 -------------------------------------
        
        pnum = bin2dec(subframe(47:50));
        switch pnum
            case 1
                eph.SatH1      = bin2dec(subframe(51));
                eph.AODC        = bin2dec(subframe(52:56));
                eph.URAI        = bin2dec(subframe(61:64));
                eph.WN  = bin2dec([subframe(65:71) subframe(76:81)]);
                eph.t_oc        = bin2dec([subframe(82:86) subframe(91:101) subframe(106)]) * 2^3;
                eph.T_GD1       = twosComp2dec(subframe(107:116)) * 10^(-10);
                eph.T_GD2       = twosComp2dec(subframe(121:130)) * 10^(-10);
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            case 2
                eph.alpha0      = twosComp2dec([subframe(51:56) subframe(61:62)]) * 2^(-30);
                eph.alpha1      = twosComp2dec(subframe(63:70)) * 2^(-27);
                eph.alpha2      = twosComp2dec([subframe(71) subframe(76:82)]) * 2^(-24);
                eph.alpha3      = twosComp2dec([subframe(83:86) subframe(91:94)]) * 2^(-24);
                eph.beta0       = twosComp2dec([subframe(95:101) subframe(106)]) * 2^11;
                eph.beta1       = twosComp2dec(subframe(107:114)) * 2^14;
                eph.beta2       = twosComp2dec([subframe(115:116) subframe(121:126)]) * 2^16;
                eph.beta3       = twosComp2dec([subframe(127:131) subframe(136:138)]) * 2^16;
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            case 3
                eph.a0          = twosComp2dec([subframe(101) subframe(106:116) subframe(121:131) subframe(136)]) * 2^(-33);
                a1_MSB          = subframe(137:140);
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            case 4
                eph.a1          = twosComp2dec([a1_MSB subframe(51:56) subframe(61:71) subframe(76)]) * 2^(-50);
                eph.a2          = twosComp2dec([subframe(77:86) subframe(91)]) * 2^(-66);
                eph.AODE        = bin2dec(subframe(92:96));
                eph.deltan      = twosComp2dec([subframe(97:101) subframe(106:116)]) * 2^(-43) * bdsPi;
                C_uc_MSB        = [subframe(121:131) subframe(136:138)];
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            case 5
                eph.C_uc        = twosComp2dec([C_uc_MSB subframe(51:54)]) * 2^(-31);
                eph.M_0         = twosComp2dec([subframe(55:56) subframe(61:71) subframe(76:86) subframe(91:98)]) * 2^(-31) * bdsPi;
                eph.C_us        = twosComp2dec([subframe(99:101) subframe(106:116) subframe(121:124)]) * 2^(-31);
                e_MSB           = [subframe(125:131) subframe(136:138)];
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            case 6
                eph.e           = bin2dec([e_MSB subframe(51:56) subframe(61:71) subframe(76:80)]) * 2^(-33);
                eph.sqrtA       = bin2dec([subframe(81:86) subframe(91:101) subframe(106:116) subframe(121:124)]) * 2^(-19);
                C_ic_MSB        = [subframe(125:131) subframe(136:138)];
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            case 7
                eph.C_ic        = twosComp2dec([C_ic_MSB subframe(51:56) subframe(61:62)]) * 2^(-31);
                eph.C_is        = twosComp2dec([subframe(63:71) subframe(76:84)]) * 2^(-31);
                eph.t_oe        = bin2dec([subframe(85:86) subframe(91:101) subframe(106:109)]) * 2^3;
                i_0_MSB         = [subframe(110:116) subframe(121:131) subframe(136:138)];
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            case 8
                eph.i_0         = twosComp2dec([i_0_MSB subframe(51:56) subframe(61:65)]) * 2^(-31) * bdsPi;
                eph.C_rc        = twosComp2dec([subframe(66:71) subframe(76:86) subframe(91)]) * 2^(-6);
                eph.C_rs        = twosComp2dec([subframe(92:101) subframe(106:113)]) * 2^(-6);
                Omega_dot_MSB   = [subframe(114:116) subframe(121:131) subframe(136:140)];
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            case 9
                eph.Omega_dot   = twosComp2dec([Omega_dot_MSB subframe(51:55)]) * 2^(-43) * bdsPi;
                eph.Omega_0     = twosComp2dec([subframe(56) subframe(61:71) subframe(76:86) subframe(91:99)]) * 2^(-31) * bdsPi;
                omega_MSB       = [subframe(100:101) subframe(106:116) subframe(121:131) subframe(136:138)];
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            case 10
                eph.omega       = twosComp2dec([omega_MSB subframe(51:55)]) * 2^(-31) * bdsPi;
                eph.IDOT        = twosComp2dec([subframe(56) subframe(61:71) subframe(76:77)]) * 2^(-43) * bdsPi;
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
        end %switch pnum
    elseif subframeID == 2%--- It is subframe 2 -------------------------------------      
            pnum = bin2dec(subframe(48:51));

        switch pnum 
            case 1
                eph.SatH2      = bin2dec(subframe(51));
                eph.AODC        = bin2dec(subframe(52:56));
                eph.URAI        = bin2dec(subframe(61:64));
                eph.weekNumber  = bin2dec([subframe(65:71) subframe(76:81)]);
                eph.t_oc        = bin2dec([subframe(82:86) subframe(91:101) subframe(106)]) * 2^3;
                eph.T_GD1       = twosComp2dec(subframe(107:116)) * 10^(-10);
                eph.T_GD2       = twosComp2dec(subframe(121:130)) * 10^(-10);
                SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]); 
        end
    end % switch subframeID ...
    
end % for all 5 sub-frames ...
%                   eph.a1          = twosComp2dec([eph.a1_MSB e.pha1_LSB]) * 2^(-50);
%                   eph.C_uc        = twosComp2dec([eph.C_uc_MSB eph.C_uc_LSB]) * 2^(-31);
%                   eph.e           = bin2dec([eph.e_MSB eph.e_LSB]) * 2^(-33);
%                   eph.C_ic        = twosComp2dec([eph.C_ic_MSB eph.C_ic_LSB]) * 2^(-31);
%                   eph.i_0         = twosComp2dec([eph.i_0_MSB eph.i_0_LSB]) * 2^(-31) * bdsPi;
%                   eph.omega_dot   = twosComp2dec([eph.omega_dot_MSB eph.omega_dot_LSB]) * 2^(-43) * bdsPi;
%                   eph.omega       = twosComp2dec([eph.omega_MSB eph.omega_LSB]) * 2^(-31) * bdsPi;


%% Compute the time of week (TOW) of the first sub-frames in the array ====
% Also correct the TOW. The transmitted TOW is actual TOW of the next
% subframe and we need the TOW of the first subframe in this data block
% (the variable subframe at this point contains bits of the last subframe).

