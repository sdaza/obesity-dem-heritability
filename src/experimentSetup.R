

library(data.table)

mating_type = c("defined", "observed")
mating = c(0.1, 0.5, 0.9)
heredity = c("uniform", "preston", "observed")
leakeage = c(0.1, 0.3, 0.5)

experiments = data.table(expand.grid(mating_type = mating_type, mating = mating, heredity = heredity, 
    leakage = leakeage))
nrow(experiments)

# remove reduntant rows
experiments[, select := TRUE]
experiments[heredity == "uniform" & leakage > 0.1, select := FALSE]
experiments[heredity == "observed" & leakage > 0.1, select := FALSE]

nrow(experiments)

experiments[mating_type == "observed" & mating > 0.1, select := FALSE]
experiments = experiments[select == TRUE]
experiments
fwrite(experiments, "models/fertility-BMI/data/exp-design-01.csv", row.names = FALSE)
