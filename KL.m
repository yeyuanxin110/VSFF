function finalkl = KL(fenbu1,fenbu2)
fenbu1(fenbu1==0)=1e-50;  
fenbu2(fenbu2==0)=1e-50;  
% Dkl=sum(fenbu1.*log(eps + fenbu1./fenbu2 + eps));
% Dk2=sum(fenbu2.*log(eps + fenbu2./fenbu1 + eps));
Dkl=sum(fenbu1.*log(fenbu1./fenbu2));
Dk2=sum(fenbu2.*log(fenbu2./fenbu1));
finalkl = (Dkl+Dk2)/2;
end