function Cluster = main_USLC(A,TrueCluster,epsilon,t,reject,rep,delta)


% ========= Initialization ================= %
n = size(A,1); % number of vertices
degvec = sum(A,2);
Dinv = spdiags(1./degvec,0,n,n);
DinvA = Dinv*A;
L = speye(n,n) - DinvA;

avg_comember = zeros(n,n);

for m = 1:rep
    gamma = datasample(1:n,1,'Replace',false);
    Cluster_USLC = main_CS_LCE(A,gamma,0.5*n/10,epsilon,t,reject);
%     cluster_labels = zeros(n,1); 
%     cluster_labels(Cluster_USLC) = 1;
%     avg_labels = avg_labels + cluster_labels/rep;  

    comember = zeros(n,n);
    comember(Cluster_USLC,Cluster_USLC) = 1;
    avg_comember = avg_comember + comember/rep;
end

%figure, spy(avg_comember)
%figure, spy(avg_comember>delta)

% [~,Cluster] = find(avg_comember>delta);
% Cluster = unique(Cluster);
% size(Cluster)

v = datasample(TrueCluster,1,'Replace',false);
Cluster = find(avg_comember(v,:)>delta);

% G = graph(avg_comember>delta);
% Cluster = dfsearch(G,datasample(TrueCluster,1,'Replace',false));

size_v = size(Cluster)

