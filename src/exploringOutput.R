# exploring simulation output

library(data.table)
path = "models/fertility-BMI/output/"
files = list.files(path = path, pattern = "group")

readFiles = function(path, files) {
    data = list()
    for (i in seq_along(files)) {
        data[[i]] = fread(paste0(path, files[i]))
    }
    return(rbindlist(data))   
}

dat = readFiles(path, files)
params = list.files(path = path, pattern = "paramet")
params = readFiles(path = path, params)
params = params[replicate == 1][, replicate := NULL]

rounding = function(x) {
    return(sprintf(x, fmt = '%#.2f'))
}

intervals = function(x) {
    m = rounding(median(x))
    l = rounding(quantile(x, 0.025))
    h = rounding(quantile(x, 0.975))
    return(paste0(m, " [", l, "-", h, "]"))
}

names(dat)
a = dat[population > 1000, lapply(.SD, function(x) rounding(median(x))), 
    .SDcols = c("mating",  "kid-father-cor", "kid-mother-cor"), by = .(iteration)]
a
m = dat[population > 1000, lapply(.SD, intervals), .SDcols = paste0("g", 1:4), by = .(iteration)]
m = merge(a, m, by = "iteration")
setnames(m, paste0("g", 1:4), c("underweight", "normal", "overweight", "obese"))
m = merge(params, m, by = "iteration")
