data <- read.table("ozone.txt", header = TRUE)
subset(data, T15 > 30)$maxO3v
data2 <- subset(data, pluie == "Sec")
data2[order(-data2$T12), ]

split.screen(1:2) + screen(2) ; boxplot(data$Ne9) ; screen(1) ; hist(data$Ne9)
quantile(data$maxO3, probs = seq(0, 1, 0.1))