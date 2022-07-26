vectunif <- matrix(1, nrow = 12, ncol = 1000)

f <- function(vect)
{
    vect <- runif(12, 0, 1)
    vect
}

vectunif <- sapply(vectunif, f)
moy <- colMeans(vectunif)
