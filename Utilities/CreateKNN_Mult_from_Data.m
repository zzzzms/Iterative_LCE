function A = CreateKNN_Mult_from_Data(Data,k,r)


[n,d] = size(Data);
[IDX,D] = knnsearch(Data,Data,'K',k,'NSMethod','kdtree');
Scales = D(:,r);  % find local scaling parameters
Dists = reshape(D',[],1);
I = reshape(ones(k, 1) * (1:n), [], 1);
J = reshape(IDX',[],1);
Sigmas = Scales(I).*Scales(J);
%%Sigmas = Scales(I).^2;
S = exp(-Dists.^2./Sigmas);
%%S = exp(-4*Dists.^2./Sigmas);
Atemp = sparse(I,J,S,n,n);
A = Atemp'*Atemp;
%%A = Atemp' + Atemp;
end

    
    