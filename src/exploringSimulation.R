

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
dat
dat[, apply(.SD, 2, mean), .SDcols = paste0("g", 1:4), by = .(iteration)]
dat[mating > 0 1, apply(.SD, 2, mean), .SDcols = paste0("g", 1:4)]


