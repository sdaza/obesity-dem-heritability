
library(data.table)

p = fread("output/data/param-snp-vt-efast.csv")
setorder(p, iteration)

r = fread("output/data/results-snp-vt-efast.csv")
setorder(r, iteration)



tl = function(prob) {
    return(-log((1-prob)/prob))
}

tp = function(t) {
    return(1/(1+exp(-t)))
}

(v = tl(0.0))

tp(v)
