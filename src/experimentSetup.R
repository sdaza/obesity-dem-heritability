

library(data.table)

# define genetic effects
set.seed(105422)
dat = data.table(effects = rnorm(2000))
fwrite(dat, "models/BMI-SNP/data/genetic-effects.csv", row.names = FALSE)

# SNPs grid of parameters 
genetic_variance = c(0.3, 0.6)
random_mating = c(0.5, 1.0)
experiments = data.table(expand.grid(gv =genetic_variance, 
    rm = random_mating))
fwrite(experiments, "models/BMI-SNP/data/param-snp-testing.csv", row.names = FALSE)

# mating
mating_type = c("defined", "observed")
mating = seq(0.1, 0.9, 0.1)
heredity = c("uniform", "preston", "observed")
leakeage = seq(0.0, 0.9, 0.1)
fertility = c("uniform", "additive")
experiments = data.table(expand.grid(mating_type = mating_type, mating = mating, heredity = heredity, 
    leakage = leakeage, fertility_type = fertility))
nrow(experiments)
experiments

# remove reduntant rows
experiments[, select := TRUE]
experiments[heredity == "uniform" & leakage > 0.0, select := FALSE]
experiments[heredity == "observed" & leakage > 0.0, select := FALSE]

nrow(experiments)

experiments[mating_type == "observed" & mating > 0.1, select := FALSE]
experiments = experiments[select == TRUE]
experiments

fwrite(experiments, "models/fertility-BMI/data/exp-design-01.csv", row.names = FALSE)

# check values
experiments[mating_type == "observed" & heredity == "preston"]

# hypercube sampling
library(lhs)

# set the seed for reproducibility
set.seed(1111)
# a design with 5 samples from 4 parameters
A = improvedLHS(100, 3) 
B = matrix(nrow = nrow(A), ncol = ncol(A))

B[,1] <- qunif(A[, 1], min = 0, max = 1)
B[,2] <- qunif(A[, 2], min = 0, max = 0.6)
B[,3] <- qunif(A[, 3], min = 0, max = 0.3)

B = data.table(B)
setnames(B, names(B), c("random_mating", "leakage", "fertility"))
fwrite(B, "models/fertility-BMI/data/hypercube.csv", row.names = FALSE)


