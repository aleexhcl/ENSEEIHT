data <- read.table("DataTP.txt", header = TRUE)
summary(data)
data$JJ <- as.factor(data$JJ)

anova1 <- lm(O3o~JJ, data)
summary(anova1)
model.matrix(anova1)[1:10, ]
# intercepte inclu l'influence des jours feries JJf
# param JJ a pvalue > 0.05
# contrainte par default alphaF = 0

anova2 <- lm(O3o~ C(JJ, sum), data)

summary(anova2)
model.matrix(anova2)[1:10, ]
# modele change la contrainte imposée
# plus d'influence des jours feries

regcomplet <- lm(O3o~O3p + TEMPE + RMH2O + log(NO2) + STATION + JJ + FF, data)
summary(regcomplet)
model.matrix(regcomplet)[1:10, ]

# pour regmult : tout sauf log(NO2)
# pour regcomplet : mtn log(NO2) et FF var importantes
# stations Als et Ram comme station aix, mais pas les autres
# pour selectionner les var > critere AIC :
# log vraisemblance + pénalisation du nb de var
# et ajoute critère BIC pour selectionner les var

library(MASS)
# terme apprentissage + terme régularisation
regaic <- stepAIC(regcomplet)
summary(regaic)
# etapes de supp start / step
# modèle supp la var JJ pour min AIC

regbic <- stepAIC(regcomplet, k = log(nrow(data)))
summary(regbic)
# prend log(n)j/n pour pénaliser le modèle
# generalemt selec moins de var que aic car influence des var + imp

# ajout interaction entre var
regbicint <- stepAIC(lm(O3o~. * ., data), k = log(nrow(data)))
summary(regbicint)
# monte pour R carre de 52 à 61%

plot(data$O3o)
points(data$O3p, col = "blue", pch = 4)
points(fitted(regbicint), col = "red", pch = 4)
points(fitted(regbic), col = "#1aff00", pch = 4)
# avec interaction peut atteindre des valeurs moins dans la moy
# pour verif prediction modele : 80% pour entrainement de beta
# 20% de test : test la RMSE

scores <- function(obs, previsions)
{
    biais <- mean(obs - previsions)
    rmse <- sqrt((mean((obs - previsions)**2)))
    print("Biais ; RMSE")
    return(round(c(biais, rmse), 3))
}

scores(data$O3o, data$O3p)
scores(data$O3o, fitted(regaic))
scores(data$O3o, fitted(regbic))
scores(data$O3o, fitted(regbicint))
# augm du rmse en fonction de pred

indapp <- sample(1:nrow(data), celling(nrow(data) * 0.8))
indtest <- setdiff(1:nrow(data), indapp)
datatest <- data[indtest, ]

regcompletapp <- lm(O3o~O3p + TEMPE + RMH2O +
    log(NO2) + STATION + JJ + FF, data[indapp, ])
regaicapp <- lm(formula(regaic), data[indapp, ])
regbicapp <- lm(formula(regbic), data[indapp, ])
regbicintapp <- lm(formula(regbicint), data[indapp, ])
regsimple <- lm(O3o~. * ., data[indapp, ])


scores(data[indapp, ]$O3o, fitted(regsimple))
scores(data[indapp, ]$O3o, fitted(regaicapp))
scores(data[indapp, ]$O3o, fitted(regbicapp))
scores(data[indapp, ]$O3o, fitted(regbicintapp))

scores(datatest$O3o, predict(regsimple, datatest))
scores(datatest$O3o, predict(regaicapp, datatest))
scores(datatest$O3o, predict(regbicapp, datatest))
scores(datatest$O3o, predict(regbicintapp, datatest))
# score biaisé mais RMSE proche de datapp

source("CV.R")
