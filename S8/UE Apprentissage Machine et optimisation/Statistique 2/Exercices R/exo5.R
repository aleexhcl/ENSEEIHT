data <- read.table("CLIM.txt", header = TRUE, sep = ";", dec = ",")

an <- function(date)
{
    res <- date %/% 10000
    res
}

mois <- function(date)
{
    res <- date %/% 100
    res <- res %% 100 
    res
}

AN <- sapply(data$DATE, FUN = an)
data <- cbind(data, AN)
MOIS <- sapply(data$DATE, FUN = mois)
data <- cbind(data, MOIS)

toul <- subset(data, POSTE == 31069001)
agen <- data[data$POSTE == 47091001, ]
max(agen$TX) ; agen$DATE[which.max(agen$TX)]
max(toul$TX) ; toul$DATE[which.max(toul$TX)]

# split.screen(1:2) + screen(2) ; hist(as.numeric(agen$TX), main = "Histogram Agen", col = "#000c64", xlab = "TX pour Agen", breaks = seq(-9,41,2)) ; screen(1) ; hist(as.numeric(toul$TX), main = "Histogram Toul", col = "#008b5a", xlab = "TX pour Toul", breaks = seq(-9,41,2))

moy <- function(data, ind)
{
    maxan <- max(data$AN)
    minan <- min(data$AN)
    res <- matrix(0, maxan - minan, 13)
    for(an in 1:maxan - minan) {
        for(mois in 1:12) {
            s <- subset(data, data$MOIS == mois)
            s <- subset(s[ind], data$AN == (an + minan - 1))
            s <- sapply(s, FUN = as.numeric)
            res[an, mois] <- mean(s)
        }
    }
    res[, 13] <- rowMeans(res[, 1:12])
    res
}
