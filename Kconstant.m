function [K,count_list,success_list,ratio,K_flag] = Kconstant(iteration,max_it,N,count_list,success_list,limit,p,a,alpha,K0)

alfa=alpha;
K_flag = zeros(1,500);
K = zeros(N,1);
for i = 1:1
    % Calcualtion the exponential gravitational constant
    K(i) = K0*exp(-alfa*iteration/max_it);
    int = count_list(i) > limit;
    suc = success_list(i) > limit;
    pro = rand < p;
    flag1 = suc & pro; % success case
    flag = int & pro;% failure case
    
    % Calculate the ratio of adjusted amplitude.
    temp_a = sqrt(sum(a(i,:).^2,2));
    if  temp_a == 0
        ratio = 1 / rand;
    else
        ratio = abs((log(K(i))-log(temp_a)));
    end
    if ratio < 1
        ratio = 1 / ratio;
    end
    
    if flag
        K(i) = K(i) .* ratio; % abs((log(G(i))-log(temp_a)));
        count_list(i) = 0;
        K_flag(i) = 1;
    end
    if flag1
        K(i) = K(i) .*ratio; % abs((log(G(i))-log(temp_a)));
        success_list(i) = 0;
        K_flag(i) = 2;
    end
   % The boundary control of G.
    if K(i) > K0
        K(i)= K0;
    end
    
end


