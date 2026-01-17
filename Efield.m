function [a1,a2,a3] = Efield(Q,X,K,Rnorm,Rpower,ElitistCheck,iteration,max_it, ...
                             dis_sort,diskbestnow2,neighbors,r_max,k)
%EFIELD  Electric-field like acceleration components (cleaned version)
% Note: r_max is not used in this function (kept for interface compatibility).

[N,dim] = size(X);

% ---- kbest selection ----
final_per = min(2, N);

if ElitistCheck == 1
    kbest = round(N * exp(-k * diskbestnow2 * iteration / max_it));
else
    kbest = N;
end

kbest = max(kbest, final_per);

% Ensure we don't index beyond available lists
kbest = min([kbest, N, size(dis_sort,1), numel(neighbors)]);

% ---- sort by mass (descending) ----
[~, ds] = sort(Q, 'descend');
if numel(ds) < N
    ds = (1:N).';
end

% Precompute avg(G(ds(1:ii))) for ii = 1..kbest
g_sorted = K(ds(1:kbest));
avgK = cumsum(g_sorted) ./ (1:kbest);

% ---- outputs ----
a1 = zeros(N,dim);
a2 = zeros(N,dim);
a3 = zeros(N,dim);

% ---- main accumulation ----
for i = 1:N
    E1 = zeros(1,dim);
    E2 = zeros(1,dim);
    E3 = zeros(1,dim);

    xi = X(i,:);

    for ii = 1:kbest
        Kbar = avgK(ii);

        % --- Field 1: mass-ranked agents ---
        j = ds(ii);
        if j ~= i
            R = norm(xi - X(j,:), Rnorm);
            E1 = E1 + rand(1,dim) .* Q(j) .* ((X(j,:) - xi) ./ (R^Rpower + eps));
            a1(i,:) = a1(i,:) + Kbar .* E1;
        end

        % --- Field 2: dis_sort-ranked agents ---
        j2 = dis_sort(ii, 3);
        if j2 ~= i
            R2 = norm(xi - X(j2,:), Rnorm);
            E2 = E2 + rand(1,dim) .* Q(j2) .* ((X(j2,:) - xi) ./ (R2^Rpower + eps));
            a2(i,:) = a2(i,:) + Kbar .* E2;
        end

        % --- Field 3: nearest neighbors list ---
        j3 = neighbors(ii);
        if j3 ~= i
            R3 = norm(xi - X(j3,:), Rnorm);
            E3 = E3 + rand(1,dim) .* Q(j3) .* ((X(j3,:) - xi) ./ (R3^Rpower + eps));
            a3(i,:) = a3(i,:) + Kbar .* E3;
        end
    end
end

end
