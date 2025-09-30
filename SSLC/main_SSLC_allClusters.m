function Cluster_LCE2 = main_SSLC_allClusters(A,Gamma_cell,n0,epsilon,t,reject,rep,delta)


% ========= Initialization ================= %
n = size(A,1); % number of vertices
degvec = sum(A,2);
Dinv = spdiags(1./degvec,0,n,n);
DinvA = Dinv*A;
L = speye(n,n) - DinvA;

% ============ Call the subroutines ============= %
[k,~] = size(Gamma_cell); Gamma_SSLC = Gamma_cell; Cluster_LCE2 = cell(k,1);
for s =1:k
    Cluster_LCE2{s} = main_CS_LCE(A,Gamma_cell{s},n0,epsilon,t,reject);
end

for repetition = 1:rep
    gamma = datasample(1:n,1,'Replace',false); 
    Cluster_LCE2_temp = main_CS_LCE(A,gamma,n0/10,epsilon,3,reject);
    
    for s=1:k
        if length(intersect(Cluster_LCE2{s},Cluster_LCE2_temp))>delta*length(Cluster_LCE2_temp)
            Gamma_SSLC{s} = union(Gamma_SSLC{s},gamma);
            %%Cluster_LCE2{s} = main_CS_LCE2(A,Gamma_SSLC{s},n0,epsilon,t,reject);
        end
    end
    
end

for s =1:k
    Cluster_LCE2{s} = main_CS_LCE(A,Gamma_SSLC{s},n0,epsilon,t,reject);
end

size(Gamma_SSLC)

end