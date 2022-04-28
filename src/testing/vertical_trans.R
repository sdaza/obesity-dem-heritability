
library(data.table)


p = fread("output/data/param-snp-vt-efast.csv")
setorder(p, iteration)

r = fread("output/data/results-snp-vt-efast.csv")
setorder(r, iteration)


r
p
