function clust = classification_spectrale(S, k, sigma)
    [n,p] = size(S);
    A = zeros(n,n);
    for i = 1:n
        for j = i+1:n
            A(i,j) = exp(-(norm(S(i,:) - S(j,:))^2)/(2*sigma^2));
            A(j,i) = A(i,j);
        end
    end
    Dr = diag(1./sqrt(sum(A)));
    L = Dr*A*Dr;
    [vep, vap] = eigs(L,k);
    [~, ind] = sort(diag(vap),'descend');
    X = vep(:,ind);
    Y = zeros(n,k);
    for i = 1:n
        som = sqrt(sum(X(i,:).^2));
        Y(i,:) = X(i,:)/som;
    end 
    clust = kmeans(Y,k);
end

