function X_sat_rot = e_r_corr(traveltime, X_sat)
%直角坐标系(X,Y,Z)绕Z轴旋转θ后变为另一直角坐标系，此处用于校正地球自转
%
%X_sat_rot = e_r_corr(traveltime, X_sat);
%
%   Inputs:
%       travelTime  - signal travel time
%       X_sat       - satellite's ECEF coordinates
%
%   Outputs:
%       X_sat_rot   - rotated satellite's coordinates (ECEF)

Omegae_dot = 7.292115147e-5;           %  rad/sec

%--- Find rotation angle --------------------------------------------------
omegatau   = Omegae_dot * traveltime;

%--- Make a rotation matrix -----------------------------------------------
R3 = [ cos(omegatau)    sin(omegatau)   0;
      -sin(omegatau)    cos(omegatau)   0;
       0                0               1];

%--- Do the rotation ------------------------------------------------------
X_sat_rot = R3 * X_sat;