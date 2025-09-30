function [C,v] = CS_LCE(L,Gamma_a,Omega_a,n_a,reject)
             
Phi = L(:,Omega_a);
n = size(L,1);
yg = sum(Phi,2);
% size(Omega_a)
% size(Phi'*yg)
% size(n_a)
[~,I]=mink(abs(Phi')*abs(yg),floor(n_a/5));
Phi = L;
Phi(:,Omega_a(I)) = 0;
yg = sum(Phi,2);
g = length(Gamma_a);
sparsity = ceil(4*n_a/5);

% Phi = A(:,Omega_a);
% n = size(A,1);
% yg = sum(Phi,2);
% [~,I]=maxk(Phi'*yg,floor(n_a/5));
% degvec = sum(A,2);
% Dinv = spdiags(1./degvec,0,n,n);
% DinvA = Dinv*A;
% L = speye(n,n) - DinvA;
% Phi = L;
% Phi(:,Omega_a(I)) = 0;
% yg = sum(Phi,2);
% g = length(Gamma_a);
% sparsity = ceil(4*n_a/5);

if sparsity <= 0
    C = union(Omega_a,Gamma_a);
    v = zeros(n,1);
else
    v = subspacepursuit(Phi,yg,sparsity,1e-10,ceil(log(5*n)));
    Lambda_a = v > reject;
    G = [1:n];
    C = union(G(Lambda_a), Omega_a(I));
    C = union(C,Gamma_a);
end
end
