function [cjk,djk]=haar_decomposition(cJ)
% Calcul la decomposition en ondelettes rapide d'un 
% tableaux de pixel de longeur 2**J
% Sortie : matrices creuses (taille 2**(J-1) x J) contenant les pixels (cjk)
% et coefficients de details (djk)

n=length(cJ);
p=fix(log(n)/log(2));

cjk=sparse(2^(p-1),p);
djk=sparse(2^(p-1),p);

if((n-2^p)>=eps*n)
   disp('erreur les donnees ne sont pas de longeur 2**p')
   return
end

% Calcul des coeff. par formules de recurrence
sqrt2=sqrt(2);

% Operateur matriciel calculant les pixels 
OpDM=kron(speye(2^(p-1),2^(p-1)),[1/sqrt2,1/sqrt2]);
% Operateur matriciel calculant les coeff. de details. 
OpDD=kron(speye(2^(p-1),2^(p-1)),[1/sqrt2,-1/sqrt2]);

size(OpDM)
size(cJ)
% Niveau J-1
cjk(1:2^(p-1),p)=OpDM*cJ';
djk(1:2^(p-1),p)=OpDD*cJ';
% Boucle sur tous les niveaux
for j=p-1:-1:1
  cjk(1:2^(j-1),j)=OpDM(1:2^(j-1),1:2^(j))*cjk(1:2^(j),j+1);
  djk(1:2^(j-1),j)=OpDD(1:2^(j-1),1:2^(j))*cjk(1:2^(j),j+1);
end


end
