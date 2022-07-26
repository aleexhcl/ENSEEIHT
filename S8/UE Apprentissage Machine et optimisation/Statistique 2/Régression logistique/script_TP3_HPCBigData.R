# Script TP3 HPC-BigData : Regression logistique


#####################
#1-Phase preliminaire
#####################

data=read.table(file="DataTP.txt",header=TRUE)
library(MASS)
library(veirification)


# creation du predictand et de la prevision brute de depassement de seuil 
data$OCC=as.factor(as.numeric(data$O3o>180))
data$OCCp=as.factor(as.numeric(data$O3p>180))
summary(data)

source("scores.R")


########################
#2-Regression logistique
########################

?glm

# On exclut O3o qui n'est pas un predicteur exploitable (mesures du lendemain, indisponible au moment du calcul de la prevision 
# qqstatistique en conditions operationnelles)
glm.out=glm(OCC~.,data[,-2],family=binomial)
summary(glm.out)

# Modele selectionne en utilisant le critere BIC, permet d'estimer des la phase d'apprentissage un modele parcimonieux
glm.outBIC=stepAIC(glm.out,k=log(nrow(data))) 
formula(glm.outBIC)
# le modele BIC n'utilise que 3 predicteurs : O3p, TEMPE et RMH2O
summary(glm.outBIC)


# Calcul des scores sur apprentissage
# Attention le Taux Global n'est pas adapte en cas de phenomene a prevoir rare (= frequence clim < 0.2), ce qui est notre cas ici
# il sera en effet systematiquement bon ou tres bon, laissant penser a tort que les modeles sont tous performants
# (pour obtenir un bon taux global, il suffit en effet de ne jamais prevoir l'occurrence du phenomene rare...)

# Scores prevision brute
scores(data$OCCp,data$OCC)
# PSS=0.29, H=0.37, F=0.08

# Scores regression logistique BIC avec seuil de proba de 0.5 (seuil que l'utilisateur prendrait naturellement)
scores(predict(glm.outBIC,type="response")>0.5,data$OCC)
# PSS=0.35, H=0.37, F=0.02
# pss = bonne prevision - fausse alerte à maximiser

# Exploitation de la courbe ROC pour determiner le seuil qui optimise le score PSS
roc.plot(as.numeric(data$OCC)-1,predict(glm.outBIC,type="response"))

# Un seuil de proba proche de 0.1 optimisera le PSS
scores(predict(glm.outBIC,type="response")>0.1,data$OCC)
# PSS=0.66, H=0.79, F=0.13
# Le seuil de proba optimal a exploiter est tres different de 0.5


# Exploitation d'un modele lineaire gaussien = strategie pouvant etre tentante :
# prevoir O3o puis seuiller les previsions statistiques pour en deduire une prevision de depassement de seuil

#On retire OCC qui n'est pas un predicteur exploitable (car issu de mesures du lendemain)
lm.out=lm(O3o~.,data[,-9])
scores(predict(lm.out)>180,data$OCC)
# PSS=0.1, H=0.1, F=0.004
# cette strategie mene a de mauvais resultats, meme moins bons que ceux obtenus par la prevision non post-traitee OCCp!
# --> Conclusion : pour prevoir un depassement de seuil il faut absolument proposer un modele de discrimination, une regression logistique par exemple.

#Remarque :
# L'evaluation sur fichier test pourrait �galement etre pratiquee comme au TP2, le script CV.R pouvant etre adapte 
# pour permettre de confronter des modeles de regression logistique (autre mode de selection, modeles avec interactions...)
# en analysant des boites a moustaches de scores PSS, H ou F.
