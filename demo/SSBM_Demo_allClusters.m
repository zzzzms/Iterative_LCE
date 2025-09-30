clear, clc, close all, format compact, warning off

addpath(genpath('../CS_LCE'))
addpath(genpath('../SSLC'))
addpath(genpath('../Utilities'))

% ============== Parameters ================= %
a = 5;
b = 1;
k = 3;
num_sizes = 5;                      
num_trials = 10;  
Cluster_sizes = 200*[1:num_sizes];  


% ============ Parameters ========== %
epsilon_LCE = 0.8;   
reject_LCE = 0.1;


% ============== Define all matrices of interest =========== %
time_SSLC_mat = zeros(num_trials,num_sizes,k);
Jaccard_SSLC_mat = zeros(num_trials,num_sizes,k);

for j = 1:num_sizes
    n1 = Cluster_sizes(j);
    n0vec = n1*[1,1,1];
    [~,k] = size(n0vec);
    n = sum(n0vec);
    
    % for non-scattered case 
    P = [a*log(n)/n,b*log(n)/n,b*log(n)/n;
        b*log(n)/n,a*log(n)/n,b*log(n)/n;
        b*log(n)/n,b*log(n)/n,a*log(n)/n;];

    
    for i = 1:num_trials
        A = generateA2(n0vec,P);
        %Im1 = mat2gray(full(A));
        perm = 1:n;
        %perm = randperm(n);
        A = A(perm,perm);
        
        % =============== Find ground truth Cluster ================ %
        [~,permInv] = sort(perm);
        TrueClusters = cell(k,1); 
        TrueClusters{1} = permInv(1:n1); 
        TrueClusters{2} = permInv(n1+1:2*n1); 
        TrueClusters{3} = permInv(2*n1+1:3*n1);
        Gamma_cell = cell(k,1);

        % SSLC
        for s=1:k
            Gamma_cell{s} = datasample(TrueClusters{s},1,'Replace',false);
        end
        
        tic
        Cluster_SSLC = main_SSLC_allClusters(A,Gamma_cell,n1,epsilon_LCE,3,reject_LCE,60,0.6);
        time_SSLC_mat(i,j) = toc;

        for s=1:k
            Jaccard_SSLC_mat(i,j,s) = Jaccard_Score(TrueClusters{s},Cluster_SSLC{s})
        end
        
        
    end
end

% ======= Plot all for comparison ======== %
figure,
plot(200*[1:num_sizes],mean(Jaccard_SSLC_mat,[1,3]),'LineWidth',3, 'color', 'k')
legend({'SSLC'},'FontSize',14)
ylabel('Jaccard Index')
xlabel('Size of Target Cluster')
set(gca, 'FontSize',14)

% ======= Plot all for times comparison ======== %
figure,
plot(200*[1:num_sizes],log(mean(time_SSLC_mat,[1,3])),'LineWidth',3 ,'color', 'k')
legend({'SSLC'},'FontSize',14)
ylabel('logarithm of run time')
xlabel('Size of Target Cluster')
set(gca, 'FontSize',14)


