#Fonction calcul des scores (GLOBAL,H,F,PSS)
############################################

scores = function(PREV,OBS,quiet=FALSE){
tab=table(PREV,OBS)
if (quiet == FALSE){print(tab)}
sco=rep(0,4)
# SUCCES GLOBAL
sco[1]=(tab[1,1]+tab[2,2])/sum(tab)
# HIT RATE H
sco[2]=tab[2,2]/sum(tab[,2])
# FALSE ALARM RATE F
sco[3]=tab[2,1]/sum(tab[,1])
# SCORE DE PIERCE PSS = H-F
sco[4]=sco[2]-sco[3]
if (quiet == FALSE){
print(" ")
print("Taux global    H         F         PSS")}
sco}
