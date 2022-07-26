@doc doc"""
Résolution des problèmes de minimisation sous contraintes d'égalités

# Syntaxe
```julia
Lagrangien_Augmente(algo,fonc,contrainte,gradfonc,hessfonc,grad_contrainte,
			hess_contrainte,x0,options)
```

# Entrées
  * **algo** 		   : (String) l'algorithme sans contraintes à utiliser:
    - **"newton"**  : pour l'algorithme de Newton
    - **"cauchy"**  : pour le pas de Cauchy
    - **"gct"**     : pour le gradient conjugué tronqué
  * **fonc** 		   : (Function) la fonction à minimiser
  * **contrainte**	   : (Function) la contrainte [x est dans le domaine des contraintes ssi ``c(x)=0``]
  * **gradfonc**       : (Function) le gradient de la fonction
  * **hessfonc** 	   : (Function) la hessienne de la fonction
  * **grad_contrainte** : (Function) le gradient de la contrainte
  * **hess_contrainte** : (Function) la hessienne de la contrainte
  * **x0** 			   : (Array{Float,1}) la première composante du point de départ du Lagrangien
  * **options**		   : (Array{Float,1})
    1. **epsilon** 	   : utilisé dans les critères d'arrêt
    2. **tol**         : la tolérance utilisée dans les critères d'arrêt
    3. **itermax** 	   : nombre maximal d'itération dans la boucle principale
    4. **lambda0**	   : la deuxième composante du point de départ du Lagrangien
    5. **mu0,tho** 	   : valeurs initiales des variables de l'algorithme

# Sorties
* **xmin**		   : (Array{Float,1}) une approximation de la solution du problème avec contraintes
* **fxmin** 	   : (Float) ``f(x_{min})``
* **flag**		   : (Integer) indicateur du déroulement de l'algorithme
   - **0**    : convergence
   - **1**    : nombre maximal d'itération atteint
   - **(-1)** : une erreur s'est produite
* **niters** 	   : (Integer) nombre d'itérations réalisées

# Exemple d'appel
```julia
using LinearAlgebra
f(x)=100*(x[2]-x[1]^2)^2+(1-x[1])^2
gradf(x)=[-400*x[1]*(x[2]-x[1]^2)-2*(1-x[1]) ; 200*(x[2]-x[1]^2)]
hessf(x)=[-400*(x[2]-3*x[1]^2)+2  -400*x[1];-400*x[1]  200]
algo = "gct" # ou newton|gct
x0 = [1; 0]
options = []
contrainte(x) =  (x[1]^2) + (x[2]^2) -1.5
grad_contrainte(x) = [2*x[1] ;2*x[2]]
hess_contrainte(x) = [2 0;0 2]
output = Lagrangien_Augmente(algo,f,contrainte,gradf,hessf,grad_contrainte,hess_contrainte,x0,options)
```
"""

include("Pas_De_Cauchy.jl")
include("Gradient_Conjugue_Tronque.jl")
include("Algorithme_De_Newton.jl")
include("Regions_De_Confiance.jl")

function Lagrangien_Augmente(algo,fonc::Function,contrainte::Function,contraite_ineg::Function,gradfonc::Function,
	hessfonc::Function,grad_contrainte::Function,hess_contrainte::Function,grad_contraite_ineg::Function,hess_contraite_ineg::Function,x0,options)

	if options == []
		epsilon = 1e-8
		tol = 1e-5
		itermax = 1000
		lambda0 = 2
		mu0 = 100
		tho = 2
	else
		epsilon = options[1]
		tol = options[2]
		itermax = options[3]
		lambda0 = options[4]
		mu0 = options[5]
		tho = options[6]
	end
	
	n_max_iter = 100
  Tol_abs = epsilon
  Tol_rel = tol
	option_newton = [n_max_iter, Tol_abs, Tol_rel]
	
	deltaMax = 10
	gamma1 = 0.5
	gamma2 = 2.00
	eta1 = 0.25
	eta2 = 0.75
	delta0 = 2
	c_max_iter = 1000
	option_conf = [deltaMax,gamma1,gamma2,eta1,eta2,delta0,c_max_iter,Tol_abs,Tol_rel]
	
  n = length(x0)
  xmin = zeros(n)
	fxmin = 0
	flag = -1
	iter = 0
	
	xk = x0
	xkun = x0
	lambdak = lambda0
	muk = mu0
	mukun = muk
	
	function LA(x, lambda, mu)
	  cx = contrainte(x)
	  return (fonc(x) + (lambda'*cx)[1] + (mu/2) * (norm(cx))^2)[1]
	end 
	
	function gradxLA(x, lambda, mu) 
	  gradfx = gradfonc(x)
	  gradcx = grad_contrainte(x)
	  cx = contrainte(x)[1]
	  return gradfx + lambda'*gradcx + mu*(cx'*gradcx)
	end
	
	function hessxLA(x, lambda, mu)
	  hessfx = hessfonc(x)
	  hesscx = hess_contrainte(x)
	  gradcx = grad_contrainte(x)
	  cx = contrainte(x)[1]
	  return hessfx + lambda'*hesscx + mu*(cx'*hesscx + gradcx*gradcx')
	end
	
	function calcul_xkun(algo, x, lambda, mu)
	  res = zero(n)
	  
	  function LA_algo(t)
	    return LA(t,lambda,mu)
	  end 
	  function gradxLA_algo(t)
	    return gradxLA(t,lambda,mu)
	  end 
	  function hessxLA_algo(t)
	    return hessxLA(t,lambda,mu)
	  end 
	  
	  if algo == ("newton")
	    res, f_min,flag,nb_iters = Algorithme_De_Newton(LA_algo, gradxLA_algo, hessxLA_algo, x, option_newton)
	  else
	    res, fxmin,flag,nb_iters = Regions_De_Confiance(algo, LA_algo, gradxLA_algo, hessxLA_algo, x, option_conf)
	  end
	  return res
	end
	
	nu_0 = 0.1258925
	alpha = 0.1
	beta = 0.9
	eps0 = 1.0/mu0
	epsk = eps0
	nuk = nu_0 / (muk^alpha)
	normgradla0 = norm(gradxLA(x0,lambda0,0))
	normc0 = norm(contrainte(x0))
	
	recherche = true 
	
	if (norm(gradxLA(xk,lambdak,0)) <= max(Tol_rel*normgradla0, Tol_abs)) && 
	    (norm(contrainte(xk)) <= max(Tol_rel*normc0, Tol_abs))
	  recherche = false
	  flag = 0
	end 
	
	while recherche
	
	  iter = iter + 1
	  muk = mukun
	  xk = xkun 
	  xc = xk
	  while (norm(gradxLA(xc, lambdak, muk)) > epsk)
	    xc = calcul_xkun(algo,xc,lambdak,muk)
	    n = norm(gradxLA(xc, lambdak, muk))
	  end 
	  xkun = xc 
	  
	  if (norm(gradxLA(xk,lambdak,0)) <= max(Tol_rel*normgradla0, Tol_abs)) && 
	      (norm(contrainte(xk)) <= max(Tol_rel*normc0, Tol_abs))
	    recherche = false
	    flag = 0
	  elseif iter > itermax
	    recherche = false 
	    flag = 1
	  end
	  
	  if recherche 
	    if norm(contrainte(xkun)) <= nuk 
	      lambdak = lambdak + muk * contrainte(xkun)
	      mukun = muk
	      espk = epsk / muk
	      nuk = nuk / (muk^beta)
      else 
        mukun = tho * muk
        epsk = eps0 / mukun
        nuk = nu_0 / (mukun^alpha)
      end
    end
	end
	
	xmin = xkun
	fxmin = fonc(xkun) 
	
	return xmin,fxmin,flag,iter
end
