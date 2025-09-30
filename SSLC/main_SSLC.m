function Cluster = main_SSLC(A,Gamma,n0,epsilon,t,reject,rep,delta)


% ========= Initialization ================= %
n = size(A,1); % number of vertices
degvec = sum(A,2);
Dinv = spdiags(1./degvec,0,n,n);
DinvA = Dinv*A;
L = speye(n,n) - DinvA;

% ============ Call the subroutines ============= %
Cluster_LCE = main_CS_LCE(A,Gamma,n0,epsilon,t,reject);
%Cluster_LCE2 = main_CS_LCE2(A,Gamma,n0,epsilon,t,reject);

Gamma_SSLC = Gamma;

for repetition = 1:rep
    gamma = datasample(1:n,1,'Replace',false); 
    Cluster_LCE_temp = main_CS_LCE(A,gamma,n0/10,epsilon,3,reject);
    %Cluster_LCE2_temp = main_CS_LCE2(A,gamma,n0/10,epsilon,3,reject);
            
    if length(intersect(Cluster_LCE,Cluster_LCE_temp))>delta*length(Cluster_LCE_temp)
        Gamma_SSLC = union(Gamma_SSLC,gamma);
    end
end

%size(Gamma_SSLC)

% Omega = RandomWalkThresh(A,Gamma_SSLC,n0,epsilon,t);
% [Cluster,~] = CS_LCE2(A,Gamma_SSLC,Omega,n0,reject);

Cluster = main_CS_LCE(A,Gamma_SSLC,n0,epsilon,t,reject);
%Cluster = main_CS_LCE2(A,Gamma_SSLC,n0,epsilon,t,reject);
end