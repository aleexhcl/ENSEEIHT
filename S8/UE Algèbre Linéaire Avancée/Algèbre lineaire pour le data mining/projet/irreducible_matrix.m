function [A,err]=irreducible_matrix(P,alpha,v)
% Modification de rang 1 d'une matrice colonne stochastique afin de la rendre
% irr?ductible
% P est la matrice colonne stochastique.
% alpha est le param?tre de poids (0<alpha<1).
% v est le vecteur de personalisation (vi>0 et ||v||1=1)
% A est la matrice irr?ductible
% err vaut 1 si alpha et v ne respectent pas les contraintes.

% Initialisation
    n=length(P(:,1));
    bool = true;
    for i = 1:n
        if v(i) <= 0
            bool = false;
        end
    end

% Tests sur alpha et v
    if (alpha < 1) && (alpha > 0) && (norm(v,1) == 1) && bool
% Calcul de A
        [i,j,coef] = find(P); 
        A = sparse(i,j,alpha*coef,n,n);
        A = A + (1-alpha)*v;
        err=0;
    else 
        err = 1;
    end

end