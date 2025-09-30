function A = CreateKNN2(X,K,r)
%        
%
% ======== Compute Nearest Neighbours ========= %
n = size(X,1);
[N,D] = knnsearch(X,X,'K',K); %can change distance
%[N,D] = knnsearch(X,X,'K',K,'Distance','correlation');
SigVec = D(:,r);
disp(['Finished computing Nearest Neighbours!','\n'])

% ======== Reshape to vectors ============ %
Jtemp1 = N(:,1:end);
Jtemp2 = Jtemp1';
J = Jtemp2(:);
clear Jtemp1 JTemp2

Itemp1 = ones(K,n);
v = 1:n;
Itemp2 = Itemp1.*v;
I = Itemp2(:);
clear Itemp1 Itemp2

Dtemp1 = D(:,1:end);
Dtemp2 = Dtemp1';
Dtemp3 = Dtemp2(:);
%Dtemp3 = Dtemp3.^5./(10^4);
clear Dtemp1 Dtemp2
disp(['Finished reshaping matrices to vectors!','\n'])

% ======== Create vector of scaled distances ======= %
Sig1 = SigVec(I); 
Sig2 = SigVec(J);
Sig3 = Sig1.*Sig2;
D2 = exp(-Dtemp3.^2./Sig3);
%D2 = exp(-Dtemp3./Sig3);

% ======= Create Sparse Array ============== %
disp('Last thing - creating Sparse Matrix...')
Atemp = sparse(I,J,D2,n,n);
A = Atemp'*Atemp;          % change here to change adjacency matrix A
%A = max(Atemp', Atemp); 
%A = (Atemp'+Atemp)/2; 
end

