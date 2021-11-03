

library(data.table)

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
