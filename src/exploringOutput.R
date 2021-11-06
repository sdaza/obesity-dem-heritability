# exploring simulation output

library(data.table)
library(xtable)
library(texreg)
path = "models/fertility-BMI/output/"
files = list.files(path = path, pattern = "group")


# functions
readFiles = function(path, files) {
    data = list()
    for (i in seq_along(files)) {
        data[[i]] = fread(paste0(path, files[i]))
    }
    return(rbindlist(data))   
}

intervals = function(x) {
    m = rounding(median(x))
    l = rounding(quantile(x, 0.025))
    h = rounding(quantile(x, 0.975))
    return(paste0(m, " [", l, "-", h, "]"))
}

rounding = function(x) {
    return(sprintf(x, fmt = '%#.2f'))
}


# read data
dat = readFiles(path, files)
params = list.files(path = path, pattern = "paramet")
params = readFiles(path = path, params)
params[, replicates := .N, iteration]
params = params[replicate == 1][, replicate := NULL]
setorder(params, iteration)
setnames(params, names(params), paste0("par_", names(params)))
params

dat = merge(dat, params, by.x = "iteration", by.y = "par_iteration", x.all = TRUE)
dat = dat[population > 1000]
dat[, replicates := .N, iteration]
summary(dat$replicates)

# sensitivity analysis using random forest
library(party)
cf = cforest(g4 ~  par_random_mating + par_leakage + par_fertility_factor,
    data = dat,   
    controls = cforest_unbiased(mtry = 2, ntree = 100))
vi = varimp(cf, conditional = TRUE)
barplot(vi)


# 3D countour
library(plotly)

fig = plot_ly(dat, x = ~ par_random_mating,
    y = ~ par_fertility_factor, 
    z = ~ par_leakage,
    marker = list(color = ~ g4, size = 4, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE))
fig = fig %>% add_markers()
fig = fig %>% layout(scene = list(xaxis = list(title = 'random mating'),
                                   yaxis = list(title = 'fertility'),
                                   zaxis = list(title = 'leakage')),
                      annotations = list(
                        x = 1.13,
                        y = 1.05,
                        text = 'Obesity',
                        xref = 'paper',
                        yref = 'paper',
                        showarrow = FALSE
                        ))
fig

# linear model
library(lme4)

dat[, rm := scale(par_random_mating)]
dat[, l := scale(par_leakage)]
dat[, f := scale(par_fertility_factor)]

m1 = lm(g4 ~  par_random_mating * par_leakage * par_fertility_factor, data = dat)
summary(m1)

m1 = lm(g4 ~  rm * l * f, data = dat)
screenreg(m1)

# sensobol
library(sensobol)

N <- 2 ^ 13
params <- c("$r$", "$K$", "$N_0$")
matrices <- c("A", "B", "AB", "BA")
first <- total <- "azzini"
order <- "second"
R <- 10 ^ 3
type <- "percent"
conf <- 0.95

mat <- sobol_matrices(matrices = matrices, N = N, params = params,
    order = order, type = "LHS")

dim(mat)
2^# explore estimates
a = dat[population > 1000, lapply(.SD, function(x) rounding(median(x))), 
    .SDcols = c("mating",  "kid-father-cor", "kid-mother-cor"), by = .(iteration)]
table(a$iteration)

a
m = dat[population > 1000, lapply(.SD, intervals), .SDcols = paste0("g", 1:4), by = .(iteration)]
table(m$iteration)

m = merge(a, m, by = "iteration")
setnames(m, paste0("g", 1:4), c("underweight", "normal", "overweight", "obese"))
m = merge(params, m, by = "iteration")

m
vars = c("replicates", "fertility_type", "heritability_type", "mating_type", "random_mating",
    "mating", "kid-father-cor", "kid-mother-cor", "normal", "overweight", "obese")
tab  = m[heritability_type == "observed", ..vars]

setorder(tab, mating_type)
tab = transpose(tab, keep.names = "rn")

lt = print(xtable::xtable(tab, caption = "Preliminary model output"), 
        table.placement = "htp", 
        booktabs=TRUE,
        caption.placement = "top", 
        include.rownames = FALSE, 
        scalebox = 0.8, file = "output/tables/example.tex")
