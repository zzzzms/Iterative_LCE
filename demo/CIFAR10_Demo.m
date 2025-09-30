clear, close all, format compact, warning off

addpath(genpath('../CS_LCE'))
addpath(genpath('../SSLC'))
addpath(genpath('../Utilities'))


load("CIFAR10.mat")


% ============ Parameters ============= %qa 
epsilon_LCE = 0.8;
reject_LCE = 0.1;

num_sizes = 1; num_trials = 1;
k = 10;  %number of clusters
n = size(A,1);

% =========== Find the ground truth clusters ======== %
TrueClusters = cell(k,1);
n0vec = zeros(k,1);

for a = 1:k
    Ctemp = find(y== a-1);
    TrueClusters{a} = Ctemp;
    n0vec(a) = length(Ctemp);    
end

num_seeds = 3; 
n0_equal = n/10; Gamma = cell(k,num_sizes); 

time_LCE_mat = zeros(k,num_sizes,num_trials);
Cluster_LCE_mat = cell(k,num_sizes,num_trials);
InterLength_LCE_mat = zeros(k,num_sizes,num_trials);
Precision_LCE_mat=zeros(k,num_sizes,num_trials);
Recall_LCE_mat=zeros(k,num_sizes,num_trials);
F1_LCE_mat=zeros(k,num_sizes,num_trials);
results_LCE_mat=zeros(k,num_sizes,num_trials);

for m = 1:num_trials
    for j = 1:num_sizes
        for i = 1:k
            Gamma{i,j} = datasample(TrueClusters{i},num_seeds,'Replace',false);
            Cluster_LCE_mat{i,j} = main_SSLC(A,Gamma{i,j},n0_equal,epsilon_LCE,3,reject_LCE,50,0.5);
            

            Precision_LCE_mat(i,j,m) = length(intersect(Cluster_LCE_mat{i,j},TrueClusters{i}))/length(Cluster_LCE_mat{i,j});
            Recall_LCE_mat(i,j,m) = length(intersect(Cluster_LCE_mat{i,j},TrueClusters{i}))/length(TrueClusters{i});
            results_LCE_mat(i,j,m) = 2*Precision_LCE_mat(i,j,m)*Recall_LCE_mat(i,j,m)/(Precision_LCE_mat(i,j,m)+Recall_LCE_mat(i,j,m));
            
        end
    end
end

mean_results = mean(results_LCE_mat,[1,3])

