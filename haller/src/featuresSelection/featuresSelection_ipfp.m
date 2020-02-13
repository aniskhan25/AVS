% code based on:
% M.Leordeanu et al, Labeling the features not the samples: Efficient video
% classification with minimal supervision, AAAI 2016
function sol = featuresSelection_ipfp(samples, k)

% perform features selection
%
% [in] samples  - covariance matrix
% [in] k        - desired number of features
%
% [out] sol     - computed solution => non-zero elements correspond to
%                   selected features

    M = samples' * samples;
    nFeatures = size(M, 1);
    D = zeros(nFeatures, 1);
    sol0 =  ones(nFeatures, 1) / nFeatures;
    epsilon = 1 / k;
    maxSteps = 50;
    
    sol0    = sol0/sum(sol0);
    new_sol = sol0;

    best_score = -1000000000; 
   
    nSteps = 0;

    sol = new_sol;

    while 1

       if nSteps > maxSteps-1
           break
       end
       nSteps =  nSteps + 1; 

       score = new_sol'*M*new_sol + 2*D'*new_sol;

       if score > best_score
           best_score = score;
           sol = new_sol;
       end
   
       old_sol = new_sol;

       xx =  M*old_sol + D;
       x2 = linearL1(xx, epsilon);
       dx = x2 - old_sol;
       k = dx'*M*dx;
   
       if k >= 0
           new_sol = x2;
       else
           c = xx'*dx;
           t = min([1, -c/k]);

           new_sol = old_sol + t*dx;
       end
    end
end

function x = linearL1(a, epsilon)

    if epsilon*length(a) < 1
        epsilon = 1/length(a);
    end

    [~, ind] = sort(-a);

    nEps = floor(1/epsilon);

    x = zeros(length(a),1);

    x(ind(1:nEps)) = epsilon;

    if nEps < length(a)

        x(ind(nEps+1)) = 1 - epsilon*nEps;

    end

end