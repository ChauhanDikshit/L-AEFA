function [X,V,c1,c2,c3,MR]=Agg_move(X,a1,a2,a3,V,Lbest,iteration,max_it,dis_sort,varmin,varmax,velmin,velmax)
mut_max=0.7; % Maximum mutation coefficient used in the bound constraint handling technique
mut_min=0.1; % Minimum mutation coefficient used in the bound constraint handling technique

[N,dim]=size(X);
mut=mut_max-rand*(mut_max-mut_min)*(iteration/max_it)^2;
 c1=1-rand*(iteration/max_it)^3;
c2=rand*(iteration/max_it)^3;
cc=[c1,c2];
c3=cc(randi(2));
% MR_min=0.1;MR_max=0.9;
% MR=MR_min+(MR_max-MR_min)*iteration./(rand*max_it);
% if MR<MR_min
%     MR=MR_min;
% elseif MR>MR_max
%     MR=rand*(MR_max-MR_min)/2;
% end
MR=mut;
best=dis_sort(1,3);
worst=dis_sort(N,3);
V(worst,:)=V(best,:);
X(worst,:)=X(best,:);
r1=rand;
for i=1:N
    if i~=worst
        if MR<rand
            V(i,:)=rand(1,dim).*V(i,:)+c1*a1(i,:)+c2*(Lbest-X(i,:));
        else
            V(i,:)=rand(1,dim).*V(i,:)+c1*a3(i,:)+c2*(Lbest-X(i,:));
        end
        % Return back the velocity of the particles if going beyond the velocity boundaries
        flag4lbv=V(i,:)<velmin(1,:);
        flag4ubv=V(i,:)>velmax(1,:);
        V(i,:)=V(i,:).*(~(flag4lbv+flag4ubv))+velmin.*flag4lbv+velmax.*flag4ubv;
        X(i,:)=X(i,:)+V(i,:); 
        
        % Return back the position of the particles if going beyond the position boundaries
        flag4lbp=X(i,:)<varmin(1,:);
        flag4ubp=X(i,:)>varmax(1,:);
        varmin_new(1,:)=varmin(1,:)+rand(1,dim).*mut.*(varmax(1,:)-varmin(1,:)); 
        varmax_new(1,:)=varmax(1,:)-rand(1,dim).*mut.*(varmax(1,:)-varmin(1,:)); 
        X(i,:)=X(i,:).*(~(flag4lbp+flag4ubp))+varmin_new.*flag4lbp+varmax_new.*flag4ubp;
    end
end
