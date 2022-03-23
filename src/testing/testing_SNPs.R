# testing SNP model output (anylogic)

library(data.table)
gen = 50:60
dat = fread("models/BMI-SNP/output/agents-0-0.csv")

dat = dat[generation %in% c(0, gen)]
table(dat$generation)
vars = paste0("snp", 1:100)
dat[, (vars) := tstrsplit(snps, ",", fixed=TRUE), id]
dat[, (vars) := lapply(.SD, function(x) as.numeric(gsub(".+=|\\}", "", x))), .SDcols = vars]

print(" :::::::::::::::::::::: ")
vv = sample(1:100, 1)
diff = NULL
for (i in 1:100) {      
a = sd(dat[generation == 0, get(paste0("snp", i))])
b = sd(dat[generation == 60, get(paste0("snp", i))])
diff  = c(diff, b -  a)
}

hist(diff)
table(diff>0)

# pgs mating by group
dat[, snps := NULL]
t = dat[generation != 0, .(cor = cor(father_pgs, mother_pgs), 
    cmk = cor(father_pgs, pgs)), .(father_bmi_group, mother_bmi_group)]
setorder(t, cor)

tt = function(t) (max(t) - t) + min(t)
tt(c(0, 1,2, 3))

# snp example
vv = sample(1:100, 1)
print(vv)
prop.table(table(dat[generation == 0, get(paste0("snp", vv))]))
sd(dat[generation == 0, get(paste0("snp", vv))])

prop.table(table(dat[generation == 60,  get(paste0("snp", vv))]))
sd(dat[generation == gen, get(paste0("snp", vv))])

# mendelian matrix
m = matrix(c(1, 0, 0, 0.5, 0.5, 0, 0, 1, 0, 0.25, 
        0.50, 0.25, 0, 0.50, 0.5, 0, 0, 1), 
        nrow = 6, ncol = 3, byrow  = TRUE)       
colnames(m) = c(0, 1, 2)
rownames(m) = c("00", "01", "02", "11", "12", "22")
m

# create heritability matrix
dat = fread("models/BMI-SNP/output/agents-0-0.csv")
dat[, snps := NULL]
tt = dat[generation > 20 & generation < 50]
tt = tt[, .N, .(father_bmi_group, mother_bmi_group, bmi_group)]
tt[, total := sum(N), .(father_bmi_group, mother_bmi_group)]
tt[, prop := N / total]
tt = dcast(tt, father_bmi_group + mother_bmi_group ~ bmi_group, value.var = "prop")
tt

# fragile families
ff = fread("models/BMI-SNP/data/heritability-ff.csv")
ff = dcast(ff, father + mother ~ kid, value.var = "oprop")
ff[, mother := mother - 1]
ff[, father := father - 1]
setnames(ff, names(ff), c("father_bmi_group", "mother_bmi_group", 0:3))
ff

# preston
e = 0.2
test = expand.grid(father_bmi_group = 0:3, mother_bmi_group = 0:3, bmi_group = 0:3)
test = data.table(test)
test[father_bmi_group == mother_bmi_group & bmi_group == mother_bmi_group, prop := 1-e]
test[father_bmi_group == mother_bmi_group & 
    (bmi_group == (mother_bmi_group + 1) | bmi_group == (mother_bmi_group - 1)), 
    prop := e/2]

test[father_bmi_group == 0 & mother_bmi_group == 0 & bmi_group == 1 , prop := e]
test[father_bmi_group == 3 & mother_bmi_group == 3 & bmi_group == 2, prop := e]
test[father_bmi_group != mother_bmi_group & (father_bmi_group == bmi_group | mother_bmi_group == bmi_group), prop := 1/2]
test[is.na(prop), prop := 0]

test = dcast(test, father_bmi_group + mother_bmi_group ~ bmi_group, value.var = "prop")
test

table(test$prop)

table(test$prop)
test[, sum(prop), .(mother_bmi_group, father_bmi_group)]

# read data from experiments
exp = fread("output/data/results-snp-testing.csv")
