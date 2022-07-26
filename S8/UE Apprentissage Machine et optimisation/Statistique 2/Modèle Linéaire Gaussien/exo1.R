data <- read.table("DataTP.txt", header = TRUE)

## part 2 

summary(data)
aix <- subset(data, STATION == "Aix")
sd(aix$O3o)

# comparer = sd ou summary 

split.screen(1:2) + screen(2) ; hist(aix$O3o); screen(1);hist(aix$O3p)

#diag moustache ou histo 

var.test(aix$O3o, aix$O3p)
# rapport des var donne 1 
t.test(aix$O3o, aix$O3p, var.equals=T)
# test avec variances égales 

cor.test(aix$O3o, aix$O3p)
# sont correles peut chercher sys 

lm.out = lm(O3o~O3p, aix)
summary(lm.out)

plot(aix$O3o,aix$O3p, type="p")
abline(lm.out)

plot(aix$O3o)
points(aix$O3p,col="blue",pch=4)
points(predict(lm.out),col="red",pch=4)

# n'atteint pas les valeurs extremes 

## part 3 
hist(data$O3o)
hist(data$O3p)
hist(data$TEMPE)
hist(data$RMH2O)
hist(data$NO2)
hist(data$FF)

# veut gaussienne pour toutes var > ok sauf NO2 :
# applique log à la var NO2 > plus corelation

pairs(data[, c(-1, -7)])

regmult <- lm(O3o~O3p + TEMPE + RMH2O + log(NO2) + FF, data)
summary(regmult)

model.matrix(regmult)[1:10, ]

plot(fitted(regmult), residuals(regmult))
# homoscedasticité : peut vérif sur la deuxieme part des Veurs
hist(residuals(regmult))
# histo d'une var normale
qqnorm(residuals(regmult))
# graph linéaire >> normalite du schema : peut de valeur qui sortent de -100 100
# 95% des observations entre -2 et 2
acf(residuals(regmult))
# correlation selon le temps :
# correlation serie et serie decalée de 1 > var non indep
# observe des valeurs hors de la barre de 0,5
# besoin de tenir compte des jours précédents
plot(fitted(regmult), data$O3o)
# reponse lineaire avec legere courbure à la fin