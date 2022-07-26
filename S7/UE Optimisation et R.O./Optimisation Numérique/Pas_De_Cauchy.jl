@doc doc"""
Approximation de la solution du sous-problème ``q_k(s) = s^{t}g + (1/2)s^{t}Hs`` 
        avec ``s=-t g_k,t > 0,||s||< \delta_k ``


# Syntaxe
```julia
s1, e1 = Pas_De_Cauchy(gradient,Hessienne,delta)
```

# Entrées
 * **gradfk** : (Array{Float,1}) le gradient de la fonction f appliqué au point ``x_k``
 * **hessfk** : (Array{Float,2}) la Hessienne de la fonction f appliqué au point ``x_k``
 * **delta**  : (Float) le rayon de la région de confiance

# Sorties
 * **s** : (Array{Float,1}) une approximation de la  solution du sous-problème
 * **e** : (Integer) indice indiquant l'état de sortie:
        si g != 0
            si on ne sature pas la boule
              e <- 1
            sinon
              e <- -1
        sinon
            e <- 0

# Exemple d'appel
```julia
g1 = [0; 0]
H1 = [7 0 ; 0 2]
delta1 = 1
s1, e1 = Pas_De_Cauchy(g1,H1,delta1)
```
"""
function Pas_De_Cauchy(g,H,delta)

  function q(x) 
      return (g'*x) + (0.5*(x'*H*x))
    end
    
    e = 0
    n = length(g)
    s = zeros(n)
    coeft = 1
    
    if g != zeros(n) 
      s = - (delta/norm(g))*g #est sol pour t = delta/norm gk
      facteur = g'*H*g
      if facteur > 0 
        coeft = min(1, ((norm(g))^3)/(delta*facteur)) 
        #trouve en derivant qk(s) en fonction de t avec s = -tgk (remplace) 
        #donne t = (norm gk)^2 / (gkT Hk gk) à qk'(t) = 0 
        #et encadre 0 < t < delta/ norm gk + mult par norm gk pour avoir s
      end
      s = coeft * s
    end 
    
    if g != zeros(n)
      if coeft < 1
        e = 1
      else 
        e = -1
      end
    else 
      e = 0
    end
    
    return s, e
end
