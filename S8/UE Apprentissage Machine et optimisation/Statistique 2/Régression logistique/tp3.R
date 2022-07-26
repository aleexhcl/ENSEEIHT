data <- read.table("DataTP.txt", header = TRUE)
library(MASS)

data$OCC <- as.factor(as.numeric(data$O3o > 180))
data$OCCp <- as.factor(as.numeric(data$O3p > 180))
summary(data)

source("scores.R")

glm.out <- glm(OCC~., data[, -2], family = binomial)
summary(glm.out)

glm.outBIC <- stepAIC(glm.out, k = log(nrow(data)))
summary(glm.outBIC)

scores(data$OCCp, data$OCC)
# predict(glm.outBIC, type = "response") donne des proba
scores(as.numeric(predict(glm.outBIC, type = "response") > 0.5), data$OCC)
# pss = bonne prevision - fausse alerte à maximiser

roc.plot(as.numeric(data$OCC) - 1, predict(glm.outBIC, type = "response"))

scores(as.numeric(predict(glm.outBIC, type = "response") > 0.1), data$OCC)
# choisi de mieux prédir H que taux global pour savoir quand depasse le seuil
# mm si augm de F
# depend de ce que l'on cherche a predir > opti quand se rapproche le plus
# de la courbe ROC ideale (droite jusq 1)