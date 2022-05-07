
library(data.table)

p = fread("output/data/param-snp-vt-efast.csv")
setorder(p, iteration)

r = fread("output/data/results-snp-vt-efast.csv")
setorder(r, iteration)



tl = function(prob) {
    return(-log((1-prob)/prob))
}


tpp = function(logit) {
odds = exp(logit)
return(odds / (1+odds))
}

tpp(v)

exp(0)
exp(1)

tp = function(t) {
    return(1/(1+exp(-t)))
}

(v = tl(0.6))
tp(v)
for (i in 0:3) {
    print(tp(v - 0.3 * i))
}


tp(v)

