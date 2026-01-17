%% Information
% Chauhan, Dikshit, Shivani. "Self-adaptive and locally-guided artificial electric field algorithm for global optimization with aggregative learning."
% Knowledge-Based Systems (2025): 113835.
% DOI: https://doi.org/10.1016/j.knosys.2025.113835

clc; clear all;
fhd = str2func('cec17_func');
ElitistCheck=1; Rpower=1;
min_flag=1;
limit = 2;
p = 0.5; k=30;K0=500;alpha=10;
D=30;
N=2*D;
max_fe=4000*D;
max_it=max_fe/(N);
Max_runs=1;
for i=[3]
    for t=1:Max_runs
        ['problem ',num2str(i),'-Dimension ', num2str(D),'-run ',num2str(t)]
        tic;
        [Fbest_LAEFA,BestChart_LAEFA]=LAEFA(fhd,N,D,max_it,max_fe,ElitistCheck,min_flag,Rpower,i,limit,p,k,alpha,K0);Fbest_LAEFA
        t_LAEFA=toc;

    end
end



