% close all;
% clear all; 
N = 100000; 
u = -0.932; 
sigma1 = 0.376; 
z = 0 :0.01: 5000;
pdf=1./(z*sigma1*sqrt(2*pi)).*exp(-(log(z)-u).^2/(2*sigma1.^2)); %lognormal概率密度函数
pdf_max = max(pdf); 
U = rand(1,N)*20; 
pdf_U = 1./(U*sigma1*sqrt(2*pi)).*exp(-(log(U)-u).^2/(2*sigma1.^2)); 
V = rand(1,N)*pdf_max; 
n = 0; 
for i = 1:N 
    if pdf_U(i)>V(i) 
        n=n+1; 
        R_lognormal(n)=pdf_U(i); 
    end
end 
FR = rand(1,n); 
sigma0 = 0.158; 
R_Rayleigh = sqrt(-2*sigma0*log(1-FR)); 
R_Loo = R_Rayleigh+R_lognormal; 
Loo_hist_number = hist(R_Loo,100); 
R_step = max(R_Loo)/100; 
R_label = (1:100)*R_step; 
for i = 1:100 
    dz=0.001; 
    z=(1:2000)*dz; 
%       syms z
%       Loo_pdf_theory(i)=int(R_label(i)/(sigma0.^2*sigma1*sqrt(2*pi))./z.*exp(-(R_label(i)^2+z.^2)/(2*sigma0.^2)-(log(z)-u).^2/(2*sigma1.^2)).*besseli(0,R_label(i)*z/sigma0.^2),0,inf);  
    Loo_pdf_theory(i)=sum(R_label(i)/(sigma0.^2*sigma1*sqrt(2*pi))./z.*exp(-(R_label(i).^2+z.^2)/(2*sigma0.^2)-(log(z)-u).^2/(2*sigma1.^2)).*besseli(0,R_label(i)*z/sigma0.^2)*dz);
end 
figure 
plot(R_label,Loo_pdf_theory) 
grid on
 set(gca,'GridlineStyle',':','GridColor','k','GridAlpha',1)
axis([0 3 0 2])
xlabel('信号包络r') 
ylabel('概率密度fr(r)') 
legend('\sigma0=0.158,\sigma1=0.376,u=--0.932')
