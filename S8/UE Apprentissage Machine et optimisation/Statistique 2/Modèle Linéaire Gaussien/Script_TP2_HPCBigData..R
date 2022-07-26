# Script TP2 HPC-BigData - Modele linaire gaussien

# 1 - Chargement librairies et donnees


data=read.table(file="DataTP.txt",header=TRUE)

names(data)
summary(data)
dim(data)

# 2 - Etude preliminaire et regression simple

aix=subset(data,STATION=="Aix")
summary(aix)
sd(aix$O3o)
sd(aix$O3p)
par(mfrow=c(1,2))
hist(aix$O3o,breaks=seq(0,300,30),ylim=c(0,100))
hist(aix$O3p,breaks=seq(0,300,30),ylim=c(0,100))
# on impose ici les memes classes pour comparer les histogrammes

x11()
boxplot(aix$O3o,aix$O3p,names=c("[O3]obs","[O3]prevu"))
# Les previsions semblent surestimer globalement les mesures

var.test(aix$O3o,aix$O3p)
# -> les variances peuvent etre considerees comme egales
t.test(aix$O3o,aix$O3p,var.equal=T)
# -> les moyennes sont significativement differentes : les previsions sont biaisees (biais positif)

cor(aix$O3o,aix$O3p)
cor.test(aix$O3o,aix$O3p)
#liaison lin�aire significative detectee

plot(aix$O3p,aix$O3o)
regsimple=lm(O3o~O3p,data=aix)
summary(regsimple)
# -> les 2 parametres du modele sont jug�s significativement differents de 0
# -> la regression simple n'explique que 22% de la variance totale du predictand
# en considerant d'autres predicteurs, le modele statistique peut certainement etre ameliore

x11()
plot(aix$O3p,aix$O3o,xlab="O3 PREVU MOCAGE",ylab="O3 OBSERVE",
     main="PREVISIONS 24H",pch='+')
abline(regsimple,col="red")

x11()
plot(aix$O3o,type ="l",lwd=2,main="Concentration d'ozone � Aix",xlab="Date",ylab="[O3]")
points(aix$O3p,col="blue",pch="+")
points(fitted(regsimple),col="red",pch="+")
legend(0,268,lty=1,col=c("black"),legend=c("observ�e"),bty="n")
legend(0,256,pch="+",col=c("blue","red"),legend=c("       prevue","       ASsimple"),bty="n") 
# -> le traitement statistique tire les previsions brutes vers la moyenne du predictand mais est incapable d'atteindre les valeurs extremes
# la variabilit� du predictand est mal reproduite, il faut enrichir la regression pour atteindre une variabilite du modele plus forte


# 3 - Regression multiple : predicteurs continus


x11()
par(mfrow=c(3,2))
hist(data$O3p)
hist(data$TEMPE)
hist(data$FF)
hist(data$RMH2O)
hist(data$NO2)
hist(log(data$NO2))
# -> la distribution de NO2 est tres dissymetrique, l'emploi de la fonction log permet d'obtenir un profil plus adapte au modele gaussien.
# La sym�trie des distributions des pr�dicteurs n'est pas une hypoth�se du MLG mais elle permet de limiter les occurrences et impacts de valeurs extremes 
# qui seraient tr�s influentes lors de l'estimation des param�tres de r�gression. Le predicteur elabore sera de plus mieux correle avec le predictand O3o.
# -> on utilisera donc plutot la variable log(NO2)comme pr�dicteur par la suite :
cor(data$O3o,data$NO2)
cor(data$O3o,log(data$NO2))

x11()
pairs(data[,c(-1,-7)])
# -> on cherche � reperer sur cette matrice graphique d'une part les pb de multicolinearite entre predicteurs et d'autre part les fortes correlations entre 
# les differents predicteurs et le predictand O3o
# -> pas de pb de colinearite trop marquees entre predicteurs ici, les variables les mieux correlees avec O3o semblent etre O3p et TEMPE qui constitueront 
# les meilleurs predicteurs

regmult=lm(O3o~O3p+TEMPE+RMH2O+log(NO2)+FF,data)
summary(regmult)
# -> l'analyse des tests de Student montre que l'influence de NO2 n'est pas significative
# le % de variance expliquee passe � 51%
model.matrix(regmult)[1:10,]

plot(fitted(regmult),residuals(regmult),main="Hypoth�se d'homosc�dasticit�",xlab="Valeurs ajust�es (Y*)",ylab="R�sidus")
# -> legere heteroscedasticite : les valeurs s'écartent du centre vers la droite (cone)
# il y aurait mieux � faire qu'une regression : il faudrait transformer le predictand pour stabiliser la variance des erreurs
# -> modele lineaire generalise avec fct de lien
qqnorm(residuals(regmult))
# graph linéaire => normalite du schema : peut de valeur qui sortent de -100 100
# 95% des observations entre quantiles -2 et 2
# -> les queues de distribution s'eloignent de la normalite, mais globalement cette hypoth�se ne pose pas probleme
acf(residuals(regmult))
# -> correlation temporelle marquee pendant une semaine, moins nette ensuite.
# un modele autoregressif pourrait etre plus adapte
# correlation selon le temps : correlation entre la serie et serie decalée de 1 permet de vérifier valeur indep de la precedente
# observe des valeurs hors de la barre de 0,5 donc ici besoin de tenir compte des jours précédents > non indep 
# si reste dans la barre des points tillés => var indépendante de la valeur précedente 

plot(fitted(regmult),data$O3o,xlab="[03] PREVUE par AS",ylab="[03] OBSERVEE",pch="+",main="Hypoth�se de lin�arit�")
# -> l'hypothese de linearite de l'esperance de O3o est correcte m�me si on decele une legere courbure
# Au final, les predicteurs a conserver seraient ici O3p, TEMPE, RMH2O et FF


# 4 - Analyse de variance (ANOVA) : predicteurs qualitatifs

# transfo de JJ caractere en valeur 
data$JJ <- as.factor(data$JJ)

anova1=lm(O3o~JJ,data)
summary(anova1)
model.matrix(anova1)[1:10,]
# Par defaut, R a pose comme contrainte d'identification alpha(F)=0. La modalite F du facteur JJ est donc prise comme reference.
# Le terme constant du modele englobe donc ici � l'effet moyen de la modalite F. L'estimation du parametre alpha(S) relatif � la modalite S du facteur JJ
# (ici R trouve 0.4716 mais avec un ecart-type de 2.76) s'interprete alors comme l'effet diff�rentiel de la modalit� S par rapport � la modalit� F.
# Ce terme est juge non significatif par le test de Student et donc le predicteur JJ est ici juge sans interet.

anova2=lm(O3o~C(JJ,sum),data)
summary(anova2)
model.matrix(anova2)[1:10,]
# avec la contrainte 'somme des alpha = 0', le modele global ne change en rien : ce sont les parametres estimes et leur interpretation qui different.
# On conclut toujours que le predicteur JJ n'est pas influent et les p-values des tests globaux de Fisher sont rigoureusement les memes avec les 2 contraintes. 
# Le modele statistique n'a pas change en modifiant la contrainte et fera exactement les memes previsions.


# 5 - Analyse de covariance (ANCOVA) : predicteurs quantitatifs et qualitatifs, selection automatique

# Modele complet

regcomplet=lm(O3o~O3p+TEMPE+RMH2O+log(NO2)+FF+STATION+JJ,data)

# On ajoute le facteur STATION � 5 modalites. On cherche donc ici � estimer un seul modele statistique capable d'adapter sa prevision selon la station consideree.

summary(regcomplet)
# Deux contraintes ont ici ete imposees puisqu'il y a 2 facteurs. Au vu des sorties R, le logiciel a pris comme references la modalite F de JJ et la modalite Aix de STATION. 
# L'analyse des tests de Student confirme que le facteur JJ n'est pas significativement influent, par contre certaines modalites du facteur STATION menent a des effets differentiels juges significatifs.
# O3o se comporte differemment aux stations Pla et Cad par rapport � Aix alors que Als et Ram ont des comportements moyens tr�s proches d'Aix. 
# Il faut donc conserver le predicteur STATION qui enrichit notre modele, lui permettant une adaptation a la station.
# On remarque que la variable FF semble plus influente qu'� la question 2, de meme pour NO2. FF et NO2 ont donc un impact significatif sur O3o pour certaines stations.


# Selection automatique des predicteurs

library(MASS)

regaic=stepAIC(regcomplet)
summary(regaic)
formula(regaic)
# la s�lection automatique descendante utilisant le critere AIC ne retire que le facteur JJ
# critere AIC :
# log vraisemblance + pénalisation du nb de var
# et ajoute critère BIC pour selectionner les var

regbic=stepAIC(regcomplet,k=log(nrow(data)))
summary(regbic)
formula(regbic)
# la selection automatique descendante utilisant le critere BIC retire le facteur JJ et les variables RMH2O et NO2
# la selection BIC est plus severe et m�ne en general � des modeles plus parcimonieux (moins de predicteurs selectionnes qu'avec le critere AIC)
# le terme de penalisation de la dimension du modele dans l'indice BIC est en effet plus important que pour l'indice l'AIC.
# Le % de variance expliquee passe � 52%

#L'interet de tels algorithmes intervient en cas de modele complet plus complexe, par exemple si on cherche a tester toutes les interactions d'ordre 2 possibles
# l'algorithme effectue un premier tri, essayez :
regint=lm(O3o~.*.,data)
summary(regint)
regbicint=stepAIC(regint,k=log(nrow(data)))
formula(regbicint)



# 6 - Evaluation des modeles

plot(data$O3o,type ="l",main="Concentration d'ozone",xlab="Indice",ylab="[O3]")
points(data$O3p,col="blue",pch="+",cex=1.2)
regsimple=lm(O3o~O3p,data)
points(fitted(regbicint),col="green",pch="+",cex=1.2)
points(fitted(regsimple),col="red",pch="+",cex=1.2)
legend(0,330,lty=1,col=c("black"),legend=c("observ�"),bty="n")
legend(0,320,pch="+",col=c("blue","red","green"),legend=c("       prevu","       regsimple","       regbicint"),bty="n") 
# On voit que le modele regbicint en vert ameliore la regression simple en rouge en donnant une plus grande variabilite aux previsions statistiques

# Calcul des scores :

# fonction calculant le biais et le RMSE
score=function(obs,prev) {
rmse=sqrt(mean((prev-obs)**2))
biais=mean(prev-obs)
print("Biais  RMSE") 
return(round(c(biais,rmse),3))
}

score(data$O3o,data$O3p)
# biais=11.82 RMSE=38.34
# -> la prevision brute est biaisee
score(data$O3o,fitted(regsimple))
# biais=0 RMSE=33.01
# -> la regression simple debiaise la prevision brute et reduit la variabilite de l'erreur
score(data$O3o,fitted(regbic))
# biais=0 RMSE=28.24
# -> la regression BIC reduit encore la variabilite de l'erreur
score(data$O3o,fitted(regbicint))
# -> la regression BICint reduit encore la variabilite de l'erreur, le modele le plus complexe etant le plus performant sur les donnees d'apprentissage

# Mais les ecarts constates sont-ils signigicatifs ? Rien ne permet de l'affirmer a ce stade.
# De plus quel serait le comportement des modeles sur de nouvelles donnees ?

# Ces scores ont ete calcules sur fichier d'apprentissage, c'est � dire sur les donnees qui ont servi � l'estimation du modele statistique.
# Il faut pour valider le modele le tester sur de nouvelles donnees (non utilisees pour estimer les parametres du modele) 
# pour verifier que les scores ne se degradent pas trop. Les scores sur fichier test servent � apprecier la robustesse du modele (= capacite � s'adapter � de nouvelles donnees).
# Si le modele est de trop grande dimension, les scores seront bons voire excellents sur apprentissage mais mauvais sur test (le modele sera trop adapte � 
# l'echantillon d'apprentissage mais incapable de s'en detacher (= phenomene de sur-apprentissage). 
# Le principe de parcimonie est donc tres important, c'est un gage de robustesse.


nappr=ceiling(0.8*nrow(data))
ii=sample(1:nrow(data),nappr)
jj=setdiff(1:nrow(data),ii)
datatest=data[jj,]
datapp=data[ii,]

regsimple=lm(O3o~O3p,datapp)
regaic=lm(formula(regaic),datapp)
regbic=lm(formula(regbic),datapp)
regbicint=lm(formula(regbicint),datapp)
regsurapp=lm(O3o~.*.*.,datapp) # modele volontairement trop complexe

score(datapp$O3o,datapp$O3p) # scores bruts de MOCAGE
score(datapp$O3o,fitted(regsimple))
score(datapp$O3o,fitted(regbic))
score(datapp$O3o,fitted(regbicint))
score(datapp$O3o,fitted(regsurapp))
# Sans surprise plus le modele est complexe et plus il est performant sur les donnees d'apprentissage,
# le biais est nul par construction.


score(datatest$O3o,datatest$O3p)
score(datatest$O3o,predict(regsimple,datatest))
score(datatest$O3o,predict(regbic,datatest))
score(datatest$O3o,predict(regbicint,datatest))
score(datatest$O3o,predict(regsurapp,datatest))
# Les scores se degradent sur test, le modele le plus complexe etant le moins robuste.

# Pour avoir acces a la variabilite des estimateurs de scores (= sensibilite de l'estimateur a l'echantillonnage)
# on peut pratiquer de la validation croisee en tirant plusieurs fois de facon aleatoire des sous-echantillons d'apprentissage et test, 
# permettant d'acceder au final a plusieurs estimations des modeles et scores et de comparer des boites a moustaches de scores 
# (les ecarts etant juges significatifs si les boites n'ont pas de zones communes) :
source("CV.R") 
# Sur le graphe genere, scores RMSE sur fichier d'apprentissage en bleu puis fichier test en rouge, le modele complexe avec interactions 
# est clairement sur-apprenti, les modeles simple, bic et bicint sont robustes, le bicint etant significativement le meilleur sur 
# test c'est le modele a proposer au final. car le + bas et moins d'écart type, correspond environ 
