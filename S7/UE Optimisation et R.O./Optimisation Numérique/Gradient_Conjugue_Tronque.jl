@doc doc"""
Minimise le problème : ``min_{||s||< \delta_{k}} q_k(s) = s^{t}g + (1/2)s^{t}Hs``
                        pour la ``k^{ème}`` itération de l'algorithme des régions de confiance

# Syntaxe
```julia
sk = Gradient_Conjugue_Tronque(fk,gradfk,hessfk,option)
```

# Entrées :   
   * **gradfk**           : (Array{Float,1}) le gradient de la fonction f appliqué au point xk
   * **hessfk**           : (Array{Float,2}) la Hessienne de la fonction f appliqué au point xk
   * **options**          : (Array{Float,1})
      - **delta**    : le rayon de la région de confiance
      - **max_iter** : le nombre maximal d'iterations
      - **tol**      : la tolérance pour la condition d'arrêt sur le gradient


# Sorties:
   * **s** : (Array{Float,1}) le pas s qui approche la solution du problème : ``min_{||s||< \delta_{k}} q(s)``

# Exemple d'appel:
```julia
gradf(x)=[-400*x[1]*(x[2]-x[1]^2)-2*(1-x[1]) ; 200*(x[2]-x[1]^2)]
hessf(x)=[-400*(x[2]-3*x[1]^2)+2  -400*x[1];-400*x[1]  200]
xk = [1; 0]
options = []
s = Gradient_Conjugue_Tronque(gradf(xk),hessf(xk),options)
```
"""
function Gradient_Conjugue_Tronque(gradfk,hessfk,options)

    "# Si option est vide on initialise les 3 paramètres par défaut"
    if options == []
        deltak = 2
        max_iter = 100
        tol = 1e-6
    else
        deltak = options[1]
        max_iter = options[2]
        tol = options[3]
    end
    
    function q(x) 
      return (gradfk'*x) + (0.5*(x'*hessfk*x))
    end
    
    function sig(pj,sj,deltak)
          sigj = 0
          a = norm(pj)^2
          b = 2*(pj'*sj)
          c = (norm(sj)^2)-(deltak^2)
          d = b^2 - (4*a*c)
          if d > 0
            sig1 = (- b + sqrt(d)) / (2*a)
            sig2 = (- b - sqrt(d)) / (2*a)
            q1 = q(sj + sig1*pj)
            q2 = q(sj + sig2*pj)
            sigj = 0
            if q1 < q2
              sigj = sig1
            else 
              sigj = sig2
            end
          elseif d==0 
            sigj = - b / (2*a)
          end 
          return sigj
   end 


   n = length(gradfk)
   s = zeros(n)
   sj = s
   sjun = s
   gj = gradfk
   gjun = gj
   pj = -gradfk
   pjun = pj
   j = 0
   norm_go = norm(gradfk)
   recherche = true
   
  if norm(gjun) == 0 
      recherche = false
  end
   
   while recherche 

      j = j + 1
      gj = gjun
      sj = sjun
      pj = pjun
 
      kj = pj'*(hessfk*pj)
      kj = kj[1]
 
      if (kj <= 0) 
         sigj = sig(pj,sj,deltak)
         s = sj + (sigj * pj)
         return s
      end
      
      alphj = (norm(gj)^2) /kj
      
      if (norm(sj + alphj*pj) >= deltak) 
          sigj = sig(pj,sj,deltak)
          s = sj + (sigj * pj)
          return s
      end
      
      sjun = sj + (alphj * pj)
      gjun = gj + (alphj * (hessfk * pj))
      betaj = (norm(gjun)^2) / (norm(gj)^2)
      pjun = - gjun + (betaj * pj)
      
      if norm(gjun) <= (tol*norm_go)
          s = sjun
          recherche = false
      elseif norm(gjun) == 0 
          s = sjun
          recherche = false
      elseif norm(pjun) <= (tol*norm_go)
          s = sjun
          recherche = false
      elseif norm(pjun) == 0 
          s = sjun
          recherche = false
      elseif j > max_iter
          recherche = false
      end  
   end 
   return s
end
