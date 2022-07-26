data(iris)
names(iris)
attach(iris)
mean(Sepal.Length)
hist(Sepal.Length)
iris2 <- subset(iris,Species=="versicolor")
detach(iris)
nviris <- iris2[order(iris2$Sepal.Length),]
