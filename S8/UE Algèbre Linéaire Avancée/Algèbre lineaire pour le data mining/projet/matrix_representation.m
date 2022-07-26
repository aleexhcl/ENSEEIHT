function [Q]=matrix_representation(A,n)
% Représentation sous forme de matrice du graphe Internet
% A contient les arcs du graphe orienté.
% n représente le nombre de sommets.
% Q est la matrice du graphe Internet.

    % Initialisation
    Q=sparse(n,n);
    N = zeros(n,1);
    [ni, ind] = groupcounts(A(:,1));
    N(ind) = 1 ./ ni; 
    Q = sparse(A(:,2), A(:,1), N(A(:,1)'), n,n); 
end
