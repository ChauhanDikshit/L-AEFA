function [Q]=charge(fit,min_flag)

Fmax=max(fit); Fmin=min(fit); Fmean=mean(fit); 
[i, N]=size(fit);

if Fmax==Fmin
   Q=ones(N,1);
else
    
   if min_flag==1 
      best=Fmin;worst=Fmax; 
   else 
      best=Fmax;worst=Fmin; 
   end
  
   Q=exp((fit-worst)./(best-worst)); 

end

Q=Q./sum(Q); 