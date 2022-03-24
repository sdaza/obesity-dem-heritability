library(sensobol)

N <- 2 ^ 13
params <- c("$r$", "$K$", "$N_0$")
matrices <- c("A", "B", "AB", "BA")
first <- total <- "azzini"
order <- "second"
R <- 10 ^ 3
type <- "percent"
conf <- 0.95


# read heritability
dat = fread("models/BMI-fertility/data/heritability-ff.csv")

dat[, father := father - 1]
dat[, mother := mother - 1]
dat[, kid := kid - 1]
fwrite(dat, "models/BMI-fertility/data/heritability-ff.csv", row.names = FALSE)

dat = fread("models/BMI-fertility/data/heritability-ifls.csv")

dat[, father := father - 1]
dat[, mother := mother - 1]
dat[, kid := kid - 1]
fwrite(dat, "models/BMI-fertility/data/heritability-ifls.csv", row.names = FALSE)
