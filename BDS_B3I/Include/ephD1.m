function [eph, SOW] = ephD1(bits)
%% Check if there is enough data ==========================================
% if length(bits) < 1500
%     error('The parameter BITS must contain 1500 bits!');
% end

%% Check if the parameters are strings ====================================
% if ~ischar(navBitsBin)
%     error('The parameter BITS must be a character array!');
% end
bdsPi = 3.1415926535898;

preamble_bits = [1,1,1,0,0,0,1,0,0,1,0];
% eph = ephD1_structure_init();
%% Decode all 5 sub-frames ================================================
for i = 1 : length(bits)/300
    
    %--- "Cut" one sub-frame's bits ---------------------------------------
    subframe_ori = bits(300*(i-1)+1 : 300*i);
%     if (subframe(1:11)*preamble_bits < 5)
%         subframe = ~subframe;
%     end
%     [subframe(16:30),~] = BCH(subframe(16:30)');
    %--- deinterleave --------------------------
    subframe = zeros(1,300);
    subframe(1:30) = subframe_ori(1:30);
    for j = 2:10
        subframe(30*(j-1)+1 : 30*j) = deinterleave(subframe_ori(30*(j-1)+1 : 30*j));
    end
    %---- BCH Decode -------------------------------------------
    for jj = 2 :20
        codeout = BCH15_4Decode(subframe(15*(jj-1)+1 : 15*jj));
        subframe(15*(jj-1)+1 : 15*jj) = (double(codeout'))';%codeout;
    end
    subframe = num2str(subframe')';
    %--- Decode the sub-frame id ------------------------------------------
    subframeID = bin2dec(subframe(16:18));
    if subframeID >5 || subframeID <1  
        error('Wrong subframe ID , Data is not reliable!');
    end
    %--- Decode sub-frame based on the sub-frames id ----------------------
    switch subframeID 
        case 1  %--- It is subframe 1 -------------------------------------
            SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            eph.SatH1       = bin2dec(subframe(47));
            eph.AODC        = bin2dec(subframe(48:52));
            eph.URAI        = bin2dec(subframe(53:56));
            eph.WN          = bin2dec([subframe(61:71) subframe(76:77)]);
            eph.t_oc        = bin2dec([subframe(78:86) subframe(91:98)]) * 2^3;
            eph.T_GD1       = twosComp2dec([subframe(99:101) subframe(106:112)]) * 0.1;
            eph.T_GD2       = twosComp2dec([subframe(113:116) subframe(121:126)]) * 0.1;
            eph.alpha0      = twosComp2dec([subframe(127:131) subframe(136:138)]) * 2^(-30);
            eph.alpha1      = twosComp2dec(subframe(139:146)) * 2^(-27);
            eph.alpha2      = twosComp2dec(subframe(151:158)) * 2^(-24);
            eph.alpha3      = twosComp2dec([subframe(159:161) subframe(166:170)]) * 2^(-24);
            eph.beta0       = twosComp2dec([subframe(171:176) subframe(181:182)]) * 2^11;
            eph.beta1       = twosComp2dec(subframe(183:190)) * 2^14;
            eph.beta2       = twosComp2dec([subframe(191) subframe(196:202)]) * 2^16;
            eph.beta3       = twosComp2dec([subframe(203:206) subframe(211:214)]) * 2^16;
            eph.a2          = twosComp2dec([subframe(215:221) subframe(226:229)]) * 2^(-66);
            eph.a0          = twosComp2dec([subframe(230:236) subframe(241:251) subframe(256:261)]) * 2^(-33);
            eph.a1          = twosComp2dec([subframe(262:266) subframe(271:281) subframe(286:291)]) * 2^(-50);
            eph.AODE        = bin2dec(subframe(292:296));
        case 2  %--- It is subframe 2 -------------------------------------
            SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            eph.deltan      = twosComp2dec([subframe(47:56) subframe(61:66)]) * 2^(-43) * bdsPi;
            eph.C_uc        = twosComp2dec([subframe(67:71) subframe(76:86) subframe(91:92)]) * 2^(-31);
            eph.M_0         = twosComp2dec([subframe(93:101) subframe(106:116) subframe(121:131) subframe(136)]) * 2^(-31) * bdsPi;
            eph.e           = bin2dec([subframe(137:146) subframe(151:161) subframe(166:176)]) * 2^(-33);
            eph.C_us        = twosComp2dec([subframe(181:191) subframe(196:202)]) * 2^(-31);
            eph.C_rc        = twosComp2dec([subframe(203:206) subframe(211:221) subframe(226:228)]) * 2^(-6);
            eph.C_rs        = twosComp2dec([subframe(229:236) subframe(241:250)]) * 2^(-6);
            eph.sqrtA       = bin2dec([subframe(251) subframe(256:266) subframe(271:281) subframe(286:294)]) * 2^(-19);
            t_oe_MSB        = subframe(295:296);
        case 3  %--- It is subframe 3 -------------------------------------
            SOW             = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            eph.t_oe        = bin2dec([t_oe_MSB subframe(47:56) subframe(61:65)]) * 2^3;
            eph.i_0         = twosComp2dec([subframe(66:71) subframe(76:86) subframe(91:101) subframe(106:109)]) * 2^(-31) * bdsPi;
            eph.C_ic        = twosComp2dec([subframe(110:116) subframe(121:131)]) * 2^(-31);
            eph.Omega_dot   = twosComp2dec([subframe(136:146) subframe(151:161) subframe(166:167)]) * 2^(-43) * bdsPi;
            eph.C_is        = twosComp2dec([subframe(168:176) subframe(181:189)]) * 2^(-31);
            eph.IDOT        = twosComp2dec([subframe(190:191) subframe(196:206) subframe(211)]) * 2^(-43) * bdsPi;
            eph.Omega_0     = twosComp2dec([subframe(212:221) subframe(226:236) subframe(241:251)]) * 2^(-31) * bdsPi;
            eph.omega       = twosComp2dec([subframe(256:266) subframe(271:281) subframe(286:295)]) * 2^(-31) * bdsPi;
        case 4  %--- It is subframe 4 -------------------------------------
            Pnum       = bin2dec(subframe(48:54));
            AmEpID     = subframe(295:296);
            if ~strcmp(AmEpID ,'11')
                continue
            end
            eph(Pnum).Almanac.SOW       = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
            eph(Pnum).Almanac.sqrtA     = bin2dec([subframe(55:56) subframe(61:71) subframe(76:86)]) * 2^(-11);
            eph(Pnum).Almanac.a1        = twosComp2dec(subframe(91:101)) * 2^(-38);
            eph(Pnum).Almanac.a0        = twosComp2dec(subframe(106:116)) * 2^(-20);
            eph(Pnum).Almanac.Omega_0   = twosComp2dec([subframe(121:131) subframe(136:146) subframe(151:152)]) * 2^(-23) * bdsPi;
            eph(Pnum).Almanac.e         = twosComp2dec([subframe(153:161) subframe(166:173)]) * 2^(-21);
            eph(Pnum).Almanac.delta_i   = twosComp2dec([subframe(174:176) subframe(181:191) subframe(196:197)]) * 2^(-19) * bdsPi;
            eph(Pnum).Almanac.t_oa      = bin2dec(subframe(196:205)) * 2^12;
            eph(Pnum).Almanac.Omega_dot = twosComp2dec([subframe(206) subframe(211:221) subframe(226:230)]) * 2^(-38) * bdsPi;
            eph(Pnum).Almanac.omega     = twosComp2dec([subframe(231:236) subframe(241:251) subframe(256:262)]) * 2^(-23) * bdsPi;
            eph(Pnum).Almanac.M_0       = twosComp2dec([subframe(263:266) subframe(271:281) subframe(286:294)]) * 2^(-23);
        case 5  %--- It is subframe 5 -------------------------------------
            Pnum            = bin2dec(subframe(48:54));
            if Pnum >= 1 && Pnum <= 6
                AmEpID(Pnum)    = subframe(295:296);
               
                Pnum_Offset = 24;
                Pnum = Pnum + Pnum_Offset;
                
                eph(Pnum).Almanac.SOW       = bin2dec([subframe(19:26) subframe(31:41) subframe(46)]);
                eph(Pnum).Almanac.sqrtA     = bin2dec([subframe(55:56) subframe(61:71) subframe(76:86)]) * 2^(-11);
                eph(Pnum).Almanac.a1        = twosComp2dec(subframe(91:101)) * 2^(-38);
                eph(Pnum).Almanac.a0        = twosComp2dec(subframe(106:116)) * 2^(-20);
                eph(Pnum).Almanac.Omega_0   = twosComp2dec([subframe(121:131) subframe(136:146) subframe(151:152)]) * 2^(-23) * bdsPi;
                eph(Pnum).Almanac.e         = twosComp2dec([subframe(153:161) subframe(166:173)]) * 2^(-21);
                eph(Pnum).Almanac.delta_i   = twosComp2dec([subframe(174:176) subframe(181:191) subframe(196:197)]) * 2^(-19) * bdsPi;
                eph(Pnum).Almanac.t_oa      = bin2dec(subframe(196:205)) * 2^12;
                eph(Pnum).Almanac.Omega_dot = twosComp2dec([subframe(206) subframe(211:221) subframe(226:230)]) * 2^(-38) * bdsPi;
                eph(Pnum).Almanac.omega     = twosComp2dec([subframe(231:236) subframe(241:251) subframe(256:262)]) * 2^(-23) * bdsPi;
                eph(Pnum).Almanac.M_0       = twosComp2dec([subframe(263:266) subframe(271:281) subframe(286:294)]) * 2^(-23);
            else
                switch Pnum
                    case 7
                end
            end
    end % switch subframeID ...
    
end % for all 5 sub-frames ...
