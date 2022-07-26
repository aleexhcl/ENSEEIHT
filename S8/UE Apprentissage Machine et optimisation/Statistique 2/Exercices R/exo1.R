bis <- function(an)
    {div400 <- (an %% 400 == 0)
    div100 <- (an %% 4 == 0 & an %% 100 != 0)
    res <- (div400 | div100)
    res}

afficherbis <- function(file)
{
indices <- sapply(file, FUN = bis)
file[indices]
}