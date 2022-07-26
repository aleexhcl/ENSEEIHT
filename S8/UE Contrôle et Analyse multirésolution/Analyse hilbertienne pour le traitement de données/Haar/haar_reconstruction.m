function [yr]=haar_reconstruction(cjk,djk,tol)
% Calcul la reconstruction d'un tableaux de pixel de longeur 2**J
% depuis le pixel c0 et les coeffients de details . 
% Sortie : tableaux de pixel de longeur 2**J

p=size(djk,2); 
n=2^p;       
yr=zeros(n,1);     


sqrt2=sqrt(2);
bloc=1/sqrt2*[1,1;1,-1];

yr(1)=cjk(1,1);

ntrunc=0;

% Boucle operant sur les coeffs. de details courants et le pixels calcules.
for j=1:1:p

  % Assemblage du vecteur de donnees et seuillage.
  tmp=zeros(2^(j),1);
  tmp(1:2:end)=yr(1:2^(j-1));
  [tmp(2:2:end),ntruncj]=seuil(djk(1:2^(j-1),j),tol);
  ntrunc=ntrunc+ntruncj;
  
  % Operateur matriciel realisant la reconstruction
  OpR=kron(speye(2^(j-1),2^(j-1)),bloc);  
  
  % Calcul des nouveaux pixels
  yr(1:2^(j))=OpR*tmp;
  
end

disp('Nombre de coeff. tronques')
ntrunc
end

%%%%%%%%%%%%%%%%%%%%%%%%
% Fonction seuil
% Realise le seuillage des valeurs plus petite que la tolerance
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
