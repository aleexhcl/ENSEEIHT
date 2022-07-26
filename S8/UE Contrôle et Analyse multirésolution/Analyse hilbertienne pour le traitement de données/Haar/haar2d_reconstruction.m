function [AJ]=haar2d_reconstruction(Acd,tol)
% Reconstruction de l'image AJ (tableau 2D) sur la base de Haar
% depuis les coefficients de details et le pixel 0 (tableau 2D Acd).
% Sortie : tableau 2D contenant l'image reconstruite.


n=size(Acd,1);
p=fix(log(n)/log(2));

if((n-2^p)>=eps*n)
   disp('erreur les donnees ne sont pas de longeur 2**p')
   return
end


AJ=Acd;
sqrt2=sqrt(2);
bloc=1/sqrt2*[1,1;1,-1];
ntrunc=0;
for j=1:1:p
   
  %% Colonnes de LLj,HLj,LHj,HHj  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
  % Preparation des donnees  
  tmp=zeros(2^(j),2^(j));
  
  % Pixels 
  tmp(1:2:end,1:2^(j-1))=AJ(1:2^(j-1),1:2^(j-1));
  % Details horizontaux  
  [tmp(2:2:end,1:2^(j-1)),ntruncj]=seuil(AJ(1+2^(j-1):2^j,1:2^(j-1)),tol);
  ntrunc=ntrunc+ntruncj;  
  % Details verticaux  
  [tmp(1:2:end,1+2^(j-1):2^j),ntruncj]=seuil(AJ(1:2^(j-1),1+2^(j-1):2^j),tol);
   ntrunc=ntrunc+ntruncj;
  % Details obliques
  [tmp(2:2:end,1+2^(j-1):2^j),ntruncj]=seuil(AJ(1+2^(j-1):2^j,1+2^(j-1):2^j),tol);
   ntrunc=ntrunc+ntruncj;
  % Fin preparation des donnees%
   
  % Assemblage de l'operateur de reconstruction
  OpR=kron(speye(2^(j-1),2^(j-1)),bloc);  
  
  % Reoncstruction 1D sur les colones
  AJ(1:2^(j),1:2^(j))=OpR*tmp;
  
  % Lignes
  %%%%%%%%%%%%
  
  % Preparation des donnees 
  tmp=zeros(2^(j),2^(j));
    
  AJ=AJ';  
  tmp(1:2:end,1:2^(j))=AJ(1:2^(j-1),1:2^(j));
  tmp(2:2:end,1:2^(j))=AJ(1+2^(j-1):2^j,1:2^(j));

 % Reoncstruction 1D sur les lignes
  AJ(1:2^(j),1:2^(j))=OpR*tmp;
  AJ=AJ';
end
  
disp('Nombre de coeff. tronques')
ntrunc
  
end

%%%%%%%%%%%%%%%%%%%%%%%%
% Fonction seuil
function [ts,ntrunc]=seuil(t,tol)
   ts=t;
   tmp=find(abs(t)<tol);
   ntrunc=0;
   if(isempty(tmp)==0)
      ts(tmp)=0.;
      ntrunc=length(tmp);
   end
  
   return  
end
