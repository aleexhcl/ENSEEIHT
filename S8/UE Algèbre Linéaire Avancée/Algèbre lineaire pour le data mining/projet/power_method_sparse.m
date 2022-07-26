function [r]=power_method_sparse(Q,v,alpha,eps)
% Algorithme de la puissance it?r?e dans le cas "creux"
% Q est la matrice repr?sentative du graphe d'Internet.
% v est le vecteur de personalisation.
% alpha est le param?tre de poids.
% eps est la pr?cision souhait?e (crit?re d'arret).
% r est le vecteur propre assoic?e ? la valeur propre 1.

% Initialisation
    n=length(Q(:,1));
    r=ones(n,1)./n;
    [iq,jq,vect] = find(Q);
    [iq, indiq] = sort(iq);
    jq = jq(indiq);
    vect = vect(indiq);
    [ni, ind] = groupcounts(iq);
    id = sum(Q) == 0;
    rnv = alpha/n * sum(r(id)) + (1-alpha)*v;
    indv = 1;
    for i = iq
        s = 0;
        for j = 1:ni(i)
            s = s + alpha*vect(indv)*r(jq(indv));
            indv = indv + 1;
        end
        rnv(i) = rnv(i) + s;
    end
    k = 0;
    while norm(rnv-r,1) >= eps*norm(r,1) || k>500
        k = k+1;
        r = rnv; 
        rnv = alpha/n * sum(r(id)) + (1-alpha)*v;
        indv = 1;
        for i = iq
            s = 0;
            for j = 1:ni(i)
                s = s + alpha*vect(indv)*r(jq(indv));
                indv = indv + 1;
            end
            rnv(i) = rnv(i) + s;
        end
        rnv = rnv/norm(rnv,1);
    end
end