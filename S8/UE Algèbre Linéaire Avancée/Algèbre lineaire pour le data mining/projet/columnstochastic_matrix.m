function [P]=columnstochastic_matrix(Q)
% Modification par une matrice de rang 1 afin d'obtenir une matrice
% stochastique par colonne
% Q est la matrice carr?e du graphe d'internet. 
% P est la matrice carr?e du graphe d'internet modifi?.

% Initialisation
    n=length(Q(:,1));
    [i,j,v] = find(Q);
    P = sparse(i,j,v,n,n);
    
    ind = sum(Q) == 0;
    P(:,ind) = 1/n;
end