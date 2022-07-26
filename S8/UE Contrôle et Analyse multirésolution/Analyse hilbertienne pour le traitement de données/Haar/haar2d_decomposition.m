function Acd=haar2d_decomposition(AJ)
% Decomposition de l'image AJ (tableau 2D) sur la base de Haar
% Sortie : tableau 2D contenant les coefficients de details et le pixel C0. 

n=size(AJ,1);
p=fix(log(n)/log(2));

if((n-2^p)>=eps*n)
   disp('erreur les donnees ne sont pas de longeur 2**p')
   return
end

Acd=AJ;

sqrt2=sqrt(2);
for j=p:-1:1
    %Assemblage de l'operateur calculant les pixels 1D
    OpDM=kron(speye(2^(j-1),2^(j-1)),[1/sqrt2,1/sqrt2]);
    %Assemblage de l'operateur calculant les details 1D
    OpDD=kron(speye(2^(j-1),2^(j-1)),[1/sqrt2,-1/sqrt2]); 
    
    %Calculs de pixels et details (1D) sur les lignes  des pixels 2D.
    Acd(1:2^(j),1:2^(j))=[OpDM;OpDD]*(Acd(1:2^(j),1:2^(j)).');
    %Calculs des pixles et coefficients de details.
    Acd(1:2^(j),1:2^(j))=[OpDM;OpDD]*(Acd(1:2^(j),1:2^(j)).');
end
  
end
