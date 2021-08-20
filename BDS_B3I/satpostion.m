function [satPositions, satClkCorr] = satpostion(transmitTime, prnList, ...
    eph)
%SATPOS Calculation of X,Y,Z satellites coordinates at TRANSMITTIME for
%given ephemeris EPH. Coordinates are calculated for each satellite in the
%list PRNLIST.
%[satPositions, satClkCorr] = satpos(transmitTime, prnList, eph, settings);
%
%   Inputs:
%       transmitTime  - transmission time
%       prnList       - list of PRN-s to be processed
%       eph           - ephemeridies of satellites
%       settings      - receiver settings
%
%   Outputs:
%       satPositions  - positions of satellites (in ECEF system [X; Y; Z;])
%       satClkCorr    - correction of satellites clocks

%% Initialize constants =============================================
numOfSatellites = size(prnList, 2);

% BDS constants
bdsPi        = 3.1415926535898;        % Pi used in BDS coordinates
%--- Constants for satellite position calculation -------------------------
OmegaE       = 7.292115e-5;           % Earth rotation rate, [rad/s]
mu           = 3.986004418e14;         % Earth's universal gravitational parameter,[m^3/s^2]
F            = -4.44280730904398e-10;  % Constant, [sec/(meter)^(1/2)] F=-2*sqrt(mu)/c^2

%% Initialize results ===============================================
satClkCorr   = zeros(1, numOfSatellites);
satPositions = zeros(3, numOfSatellites);

%% Process each satellite ===========================================

for satNr = 1 : numOfSatellites
    
    prn = prnList(satNr);
    
    %% Find initial satellite clock correction ----------------------
    
    %--- Find time difference ---------------------------------------------
    dt = check_t(transmitTime(satNr) - eph(prn).t_oc);
    
    %--- Calculate clock correction ---------------------------------------
    satClkCorr(satNr) = (eph(prn).a2 * dt + eph(prn).a1) * dt + ...
        eph(prn).a0;
    % ����ʹ��B3I�źŵĵ�Ƶ�û�������B3I�źŵ��豸ʱ���Ѻ��ڵ���
    % ���ĵ��Ӳ����a0�У����������������豸ʱ��
    time = transmitTime(satNr) - satClkCorr(satNr);
    
    %% Find satellite's position ------------------------------------
    % ����黯ʱ��tk
    tk = check_t(time - eph(prn).t_oe);

    % ���㳤����
    A = (eph(prn).sqrtA)^2;
    
    % �������ǵ�ƽ���˶�������
    n0  = sqrt(mu / (A^3));
    n = n0 + eph(prn).deltan;

    % �����źŷ���ʱ�̵�ƽ�����M
    M = eph(prn).M_0 + n * tk;
    M = rem(M + 2*bdsPi, 2*bdsPi);
    
    %�����źŷ���ʱ�̵�ƫ�����E
    E = M;
    
    %�Ӳ������У����
    dtr = F * eph(prn).e * eph(prn).sqrtA * sin(E);
    %--- Iteratively compute eccentric anomaly ----------------------------
    for ii = 1:10
        E_old   = E;
        E       = M + eph(prn).e * sin(E);
        dE      = rem(E - E_old, 2*bdsPi);
        
        if abs(dE) < 1e-12
            % Necessary precision is reached, exit from the loop
            break;
        end
    end
    %Reduce eccentric anomaly to between 0 and 360 deg
    E   = rem(E + 2*bdsPi, 2*bdsPi);
    
    % �����źŷ���ʱ�̵�������
    nu   = atan2(sqrt(1 - eph(prn).e^2) * sin(E), cos(E)-eph(prn).e);
    
    % �����źŷ���ʱ�̵�γ�ȷ���
    Phi = nu + eph(prn).omega;
    %Reduce phi to between 0 and 360 deg
    Phi = rem(Phi, 2*bdsPi);
    
    % �����źŷ���ʱ�̵��㶯У����
    %Correct argument of latitude
    u = Phi + ...
        eph(prn).C_uc * cos(2*Phi) + ...
        eph(prn).C_us * sin(2*Phi);
    %Correct radius
    r = A * (1 - eph(prn).e*cos(E)) + ...
        eph(prn).C_rc * cos(2*Phi) + ...
        eph(prn).C_rs * sin(2*Phi);
    %Correct inclination
    i = eph(prn).i_0 + eph(prn).IDOT * tk + ...
        eph(prn).C_ic * cos(2*Phi) + ...
        eph(prn).C_is * sin(2*Phi);
    
    %�����źŷ���ʱ�̵������㾭��
    %Compute the angle between the ascending node and the Greenwich meridian
    Omega1 = eph(prn).Omega_0 + (eph(prn).Omega_dot - OmegaE)*tk - ...
        OmegaE * eph(prn).t_oe;
    %Reduce to between 0 and 360 deg
    Omega1 = rem(Omega1 + 2*bdsPi, 2*bdsPi);
    
    % ���������ڹ��ƽ���ڵ�����
    xk = r * cos(u);
    yk = r * sin(u);
    
    % ����MEO/IGSO������BDCS���ĵع�ֱ������ϵ�е�����
    satPositions(1, satNr) = xk * cos(Omega1) - yk * cos(i) * sin(Omega1);
    satPositions(2, satNr) = xk * sin(Omega1) + yk * cos(i) * cos(Omega1);
    satPositions(3, satNr) = yk * sin(i);
    
    % ����GEO�������Զ�������ϵ�е�����
    Omega2 = eph(prn).Omega_0 + eph(prn).Omega_dot * tk - OmegaE * eph(prn).t_oe;
    X_GK = xk * cos(Omega2) - yk * cos(i) * sin(Omega2);
    Y_GK = xk * sin(Omega2) + yk * cos(i) * cos(Omega2);
    Z_GK = yk * sin(i);
    
    % ����GEO������BDCS����ϵ�е�����
    phi1 = OmegaE*tk;
    phi2 = bdsPi/180*(-5);
    R_Z = [cos(phi1) sin(phi1) 0 ; -sin(phi1) cos(phi1) 0 ; 0 0 1];
    R_X = [1 0 0 ; 0 cos(phi2) sin(phi2) ; 0 -sin(phi2) cos(phi2)]; 
    pos =  R_Z * R_X * [X_GK ; Y_GK ; Z_GK];
    satPositions(1, satNr) = pos(1);
    satPositions(2, satNr) = pos(2);
    satPositions(3, satNr) = pos(3);
    
    satClkCorr(satNr) = (eph(prn).a_2 * dt + eph(prn).a_1) * dt + ...
                               eph(prn).a_0 - eph(prn).T_GDB1Cp + dtr;
end % for satNr = 1 : numOfSatellites
