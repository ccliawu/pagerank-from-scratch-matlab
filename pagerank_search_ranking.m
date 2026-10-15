%% MAT 167 Final Project - Google PageRank
% Baseline: Group8_FinalProject_MAT167.pdf.
% The convergence-axis label is corrected to L2; calculations retain the PDF settings.

% Webpage order:
% A B C D E F G H I J K L

G = [0 0 0 1 0 0 0 0 0 0 0 0;
    1/4 0 1/4 0 1/4 1/4 0 0 0 0 0 0;
    1/2 0 0 0 1/2 0 0 0 0 0 0 0;
    0 1/2 0 0 0 1/2 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0;
    0 1/3 0 0 0 0 1/3 1/3 0 0 0 0;
    0 0 0 1/4 0 1/4 0 0 1/4 1/4 0 0;
    0 0 0 0 0 0 1/3 0 1/3 0 0 1/3;
    0 0 0 0 0 0 0 0 0 1 0 0;
    1/2 0 0 0 0 0 0 0 0 0 1/2 0;
    0 0 0 0 0 0 0 0 1/2 0 0 1/2;
    0 0 0 0 0 0 0 1 0 0 0 0];

% Row Sum of G
sum(G, 2)

%% Eigenvalue decomposition of raw Google matrix
[V,D] = eig(G');
% Display all eigenvalues
eigenvalues = diag(D)
% Finding the Max Eigenvalues
[eigenvalue_max, idx] = max(real(diag(D)))

pi_raw = real(V(:,idx))
all(pi_raw >= 0)

%% Fix the dangling webpage E
G(5,:) = 1/12
row_sums_fixed = sum(G,2)

%% Eigendecomposition after fixing dangling page
[V_fixed,D_fixed] = eig(G');
eigenvalues_fixed = diag(D_fixed)

pi_fixed = V_fixed(:,1)
% Check all entries are nonnegative
all(pi_fixed >= 0)

%If not positive, change to positive
if all(pi_fixed <= 0)
    pi_fixed = -pi_fixed;
end

% Normalize the PageRank vector
pi = pi_fixed / norm(pi_fixed,1)
% Check that ||pi||_1 = 1
norm(pi,1)

% Sorted pi-fixed
[sorted_pi, idx_rank] = sort(pi,'descend')
pages = ['A','B','C','D','E','F','G','H','I','J','K','L'];
ranking = pages(idx_rank)

%% Power Method
n=12;
% Initial PageRank vector
pi_old = ones(1,n)/n
% Convergence tolerance
tol = 1e-5;

% Iteration
iter_num = 0;
while true
    pi_new = pi_old * G;
    iter_num = iter_num+1;
    % Stop when consecutive iterations are sufficiently close
    if norm(pi_new - pi_old) <= tol
        break
    end
    pi_old = pi_new;
end
pi_power = pi_new
iter_num
% Check the difference
difference = norm(pi_power' - pi)

%% Construct the teleportation Google matrix
alpha = 0.85;
n = 12;

% Teleportation matrix
E = ones(n,n) / n

% Modified Google matrix
G_tilde = alpha * G + (1 - alpha) * E;
sum(G_tilde,2)

%% Eigendecomposition of G_tilde
[V_tilde, D_tilde] = eig(G_tilde')
eigenvalues_tilde = diag(D_tilde)

pi_tilde_raw = V_tilde(:,1)
if all(pi_tilde_raw <= 0)
    pi_tilde_raw = -pi_tilde_raw;
end
pi_tilde = pi_tilde_raw / norm(pi_tilde_raw,1)

%% Compare rankings from G and G_tilde
[~, rank_G] = sort(pi,'descend')
[~, rank_Gtilde] = sort(pi_tilde,'descend')
same_ranking = isequal(rank_G, rank_Gtilde)

% Display the rankings for G and G_tilde
pages = ['A','B','C','D','E','F','G','H','I','J','K','L'];
ranking_G = pages(rank_G)
ranking_Gtilde = pages(rank_Gtilde)

%% Effect of different alpha values using Power Iteration
alpha_values = [0.50 0.85 0.90];
PageRank_alpha = zeros(12,length(alpha_values));
iter_alpha = zeros(1,length(alpha_values));

for k = 1:length(alpha_values)
    alpha_test = alpha_values(k);
    % Construct modified Google matrix
    G_test = alpha_test*G + (1-alpha_test)*E;
    % Initial PageRank vector
    pi_old = ones(1,12)/12;
    % Power iteration
    iter_num = 0;
    while true
        pi_new = pi_old * G_test;
        iter_num = iter_num + 1;
        if norm(pi_new - pi_old) <= 1e-5
            break
        end
        pi_old = pi_new;
    end
    % Save PageRank scores
    PageRank_alpha(:,k) = pi_new';
    % Save iteration number
    iter_alpha(k) = iter_num;
    % Rank webpages
    [~,rank_test] = sort(pi_new,'descend');
    fprintf('alpha = %.2f\n',alpha_test);
    fprintf('iterations = %d\n',iter_num);
    disp(pages(rank_test));
end

%% Construct the term-document matrix

% Rows: Keywords
% Columns: webpages A-L

terms = ["Ash", "Butternut", "Cherry", "ELM", "Katsura", "Magnolia",...
    "Teak", "Ginkgo", "Eucalyptus", "Fir", "Hickory", "Pine", "Willow",...
    "Redwood", "Sassafras", "Oak", "Spruce", "Aspen"];

T = [1 0 1 0 0 1 1 1 0 0 0 0; %Ash
    1 1 0 1 0 0 1 0 0 0 0 1; %Butternut
    1 0 0 1 1 0 0 1 0 0 1 0; %Cherry
    1 0 1 0 0 0 0 0 1 0 1 1; %Elm
    1 0 1 0 0 0 0 0 1 0 0 1; %Katsura
    1 1 0 0 0 1 0 0 1 1 0 0; %Magnolia
    1 1 0 0 0 1 0 0 1 1 0 0; %Teak
    1 0 1 0 0 1 1 0 0 0 1 1; %Ginkgo
    1 0 1 0 1 0 0 1 1 1 0 0; %Eucalyptus
    0 1 0 1 0 1 0 0 1 0 1 0; %Fir
    0 1 1 0 1 0 0 1 0 0 1 0; %Hickory
    0 1 0 0 1 0 0 0 1 0 0 1; %Pine
    0 1 0 0 1 0 0 1 0 1 0 0; %Willow
    0 1 1 0 1 1 1 1 0 1 1 0; %Redwood
    0 1 0 1 0 1 0 0 1 1 1 1; %Sassafras
    0 0 1 0 1 0 1 0 0 1 0 1; %Oak
    0 0 0 1 0 1 1 0 1 0 0 1; %Spruce
    0 0 0 1 0 1 0 1 0 1 0 1]; %Aspen

%% User Queries

% SINGLE Search: Cherry
q_cherry = [0;0;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
d_cherry = q_cherry' * T; 
responsive_cherry = find(d_cherry == 1) % determine which webpage responsive
% Rank the responsive webpages in order of importance
[~, order] = sort(pi(responsive_cherry),'descend');
final_cherry = responsive_cherry(order);
result_cherry=pages(final_cherry)

% AND Search: Hickory AND Oak
q_and = [0;0;0;0;0;0;0;0;0;0;1;0;0;0;0;1;0;0];
d_and = q_and' * T;
responsive_and = find(d_and == 2)

[~, order_and] = sort(pi(responsive_and),'descend');
final_and = responsive_and(order_and);
result_and = pages(final_and)

% OR Search: Pine OR Willow
q_or = [0;0;0;0;0;0;0;0;0;0;0;1;1;0;0;0;0;0];
d_or = q_or' * T;
responsive_or = find(d_or >= 1)

[~, order_or] = sort(pi(responsive_or),'descend');
final_or = responsive_or(order_or);
result_or = pages(final_or)

% BUT/NOT Search: Redwood BUT NOT Eucalyptus
q_butnot = zeros(18,1);
q_butnot(14) = 1;   % Redwood
q_butnot(9)  = -1;  % Eucalyptus
d_butnot = q_butnot' * T;
responsive_butnot = find(d_butnot == 1);
[~, order_butnot] = sort(pi(responsive_butnot),'descend');
final_butnot = responsive_butnot(order_butnot);
result_butnot = pages(final_butnot)


%% Converges Curve
pi_old = ones(1,n) / n;
tol = 1e-5;
iter_num = 0;
errors = [];

while true

    pi_new = pi_old * G;

    iter_num = iter_num + 1;

    % Compute error
    err = norm(pi_new - pi_old);

    % Store error
    errors(end+1) = err;

    % Check convergence
    if err <= tol
        break
    end

    pi_old = pi_new;

end

figure
semilogy(1:length(errors), errors, '-o')

xlabel('Iteration')
ylabel('||\pi_j - \pi_{j-1}||_2')
title('Convergence of the Power Method')
grid on
