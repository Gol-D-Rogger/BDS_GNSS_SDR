format long;
%%%%%%%%
[filename,filepath]=uigetfile('*.*','读取多系统导航星历文件');
fid=fopen(strcat(filepath,filename),'rt');
if(fid==-1)
   msgbox('输入的文件或者路径不正确,无法正确打开文件','警告信息');
   return;
end
  
while 1
    tline=fgets(fid);           
    if strfind(tline, 'END OF HEADE')>1        
        break;
    end
end  
i=1;
while ~feof(fid)  
    line = fgets(fid);
    if strcmp(line(1:3), 'C01') == 0
        continue;
    end
%     rinex(i) = rinex_structure_init();
    
    %-----SV /EPOCH /SV CLK -------------------------------------
    rinex(i).PRN= line(1:3);
    rinex(i).yyyy= str2double(line(5:8));
    rinex(i).mm= str2double(line(9:11));
    rinex(i).dd= str2double(line(12:14));
    rinex(i).hh= str2double(line(15:17));
    rinex(i).mi= str2double(line(18:20));
    rinex(i).ss= str2double(line(21:23));
    rinex(i).a_f0        = str2double(line(24:43));
    rinex(i).a_f1        = str2double(line(44:62));
    rinex(i).a_f2        = str2double(line(63:81));
    %-----BROADCAST ORBIT – 1 ------------------------------------
    line = fgets(fid);
    rinex(i).AODE        = str2double(line(5:23));
    rinex(i).C_rs        = str2double(line(24:42));
    rinex(i).deltan      = str2double(line(43:61));
    rinex(i).M_0         = str2double(line(62:81));
    %-----BROADCAST ORBIT – 2 ------------------------------------
    line = fgets(fid);
    rinex(i).C_uc        = str2double(line(5:23));
    rinex(i).e           = str2double(line(24:42));
    rinex(i).C_us        = str2double(line(44:62));
    rinex(i).sqrtA       = str2double(line(62:81));
    %-----BROADCAST ORBIT – 3 ------------------------------------
    line = fgets(fid);
    rinex(i).t_oe        = str2double(line(5:23));
    rinex(i).C_ic        = str2double(line(24:42));
    rinex(i).Omega_0     = str2double(line(43:61));
    rinex(i).C_is        = str2double(line(62:81));
    %-----BROADCAST ORBIT – 4 ------------------------------------
    line = fgets(fid);
    rinex(i).i_0         = str2double(line(5:23));
    rinex(i).C_rc        = str2double(line(24:42));
    rinex(i).omega       = str2double(line(43:61));
    rinex(i).Omega_dot   = str2double(line(62:81));
    %-----BROADCAST ORBIT – 5 ------------------------------------
    line = fgets(fid);
    rinex(i).IDOT        = str2double(line(5:23));
    rinex(i).Spare1      = str2double(line(24:42));
    rinex(i).BDTWeek     = str2double(line(43:61));
    rinex(i).Spare2      = str2double(line(62:81));
    %-----BROADCAST ORBIT – 6 ------------------------------------
    line = fgets(fid);
    rinex(i).accuracy    = str2double(line(5:23));
    rinex(i).SatH1       = str2double(line(24:42));
    rinex(i).T_GD1       = str2double(line(43:61));
    rinex(i).T_GD2       = str2double(line(62:81));
    %-----BROADCAST ORBIT – 7 ------------------------------------
    line = fgets(fid);
    rinex(i).Trans_t     = str2double(line(5:23));
    rinex(i).AODC        = str2double(line(24:42));
    
    i=i+1;
    save('rinex');
end
fclose(fid);