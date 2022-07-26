# TP2 HPC-BigData : script d'evaluation des modeles : cross validation

library(MASS)

data=read.table(file="DataTP.txt",header=TRUE)

RMSE=function(obs,pr){
return(sqrt(mean((pr-obs)^2)))}

# Choix automatique de predicteurs a partir du modele complet sans puis avec interactions
regbic=stepAIC(lm(O3o~.,data),k=log(nrow(data)),trace=0)
regbicint=stepAIC(lm(O3o~.*.,data),k=log(nrow(data)),trace=0)


k=100 # nb iterations

tab=matrix(nrow=k,ncol=8)

for (i in 1:k) {

nappr=ceiling(0.8*nrow(data))
ii=sample(1:nrow(data),nappr)
jj=setdiff(1:nrow(data),ii)
datatest=data[jj,]
datapp=data[ii,]

# Estimation des modeles
regsimple=lm(O3o~O3p,datapp)
regbic=lm(formula(regbic),datapp)
regbicint=lm(formula(regbicint),datapp)
regsurap=lm(O3o~.*.*.,datapp) # modele volontairement sur-apprenti (interactions d'ordre 3), sans selection automatique des predicteurs

# Scores sur apprentissage
tab[i,1]=RMSE(datapp$O3o,predict(regsimple))
tab[i,2]=RMSE(datapp$O3o,predict(regbic))
tab[i,3]=RMSE(datapp$O3o,predict(regbicint))
tab[i,4]=RMSE(datapp$O3o,predict(regsurap))

# Scores sur test
tab[i,5]=RMSE(datatest$O3o,predict(regsimple,datatest))
tab[i,6]=RMSE(datatest$O3o,predict(regbic,datatest))
tab[i,7]=RMSE(datatest$O3o,predict(regbicint,datatest))
tab[i,8]=RMSE(datatest$O3o,predict(regsurap,datatest))

}

x11()
boxplot(tab,col=c(rep("blue",4),rep("red",4)),xlab="bleu=apprentissage - rouge=test",
names=c("ASsimp","ASbic","ASbicint","AScomplexe","ASsimp","ASbic","ASbicint","AScomplexe"),main=("Modele lineaire gaussien - Score RMSE"))

# modele qui generalise le mieux n'est pas le plus complx
# asbicint > modele le plus bas, meilleure estim