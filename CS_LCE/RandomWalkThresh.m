function Omega = RandomWalkThresh(A,Gamma,n0_hat,epsilon,t)

% =========================== Initialization ========================== %
n = size(A,1);
Dtemp = sum(A,2);
Dinv = spdiags(Dtemp.^(-1),0,n,n);
v0 = sparse(Gamma,1,Dtemp(Gamma),n,1);
P = A*Dinv;

% ===================== Random Walk and Threshold ===================== %
v = v0;
for i = 1:t
    v = P*v;
end

% figure, 
% h1 = bar(v);
% hold on
% v2 = zeros(n,1); v2(Gamma) = v(Gamma);
% h2 = bar(v2);
% h2.FaceColor = 'red';
% 
% figure, 
% histogram(v,50);

[w,IndsThresh] = sort(v,'descend');
FirstZero = find(w==0, 1, 'first');
if ~isempty(FirstZero) && FirstZero < ceil((1+epsilon)*(n0_hat))
    warning('the size of Omega is smaller than (1+delta) times the user specified cluster size. Try a larger value of k')
    T = FirstZero;
else
    T = ceil((1+epsilon)*(n0_hat));
end
Omega = union(IndsThresh(1:T),Gamma);

