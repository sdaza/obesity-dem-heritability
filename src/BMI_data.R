###############################
# BMI data
# #############################


library(data.table)
library(xlsx)

# heritability matrix
test = expand.grid(iq_father = 1:4, iq_mother = 1:4, iq_kid = 1:4)



test = expand.grid(iq_father = 1:7, iq_mother = 1:7)
offsprings = c(54, 7, 11, 16, 1, 10, 5, 
               40, 19, 12, 40, 22, 10, 5, 
               19, 22, 48, 94, 60, 20, 2, 
               29, 44, 107, 186, 167, 62, 26, 
               19, 27, 78, 166, 143, 58, 15, 
               5, 10, 39, 100, 77, 28, 16, 
               5, 2, 11, 17, 17, 11, 19)

mean_iq = c(74.4, 82.4, 91.1, 93.8, 104.0, 98.3, 113.6, 
            90.3, 89.9, 99.6, 99.2, 102.0, 113.9, 107.4, 
            103.3, 102.2, 102.4, 106.0, 104.1, 101.9, 113.0, 
            101.1, 101.3, 106.0, 108.2, 109.1, 110.9, 113.1, 
            97.5, 102.5, 107.8, 108.9, 112.9, 114.2, 114.9, 
            97.8, 113.9, 108.3, 111.6, 113.4, 108.9, 115.8, 
            113.6, 109.0, 109.4, 113.6, 116.1, 115.8, 123.5)

variance_iq = c(19.7, 15.6, 16.1, 16.7, 13.0, 12.0, 10.8,
            17.6, 12.0, 10.1, 11.2, 12.0, 9.5, 17.2,  
            13.0, 10.0, 16.7, 11.2, 18.7, 13.2, 9.0, 
            16.0, 16.6, 10.2, 11.4, 12.0, 11.5, 9.6, 
            13.0, 12.0, 10.5, 11.0, 10.8, 9.2, 11.0, 
            22.7, 9.5, 12.3, 11.1, 12.4, 22.2, 13.3, 
            10.8, 3.0, 4.8, 6.3, 13.8, 10.7, 13.0)


test$offsprings = offsprings
test$mean_iq = mean_iq
test$variance_iq = variance_iq
test$sd_iq = sqrt(test$variance_iq)
test$sd_testing = test$sd_iq

write.xlsx(test, "heritability",  file = "data/heritability.xlsx", row.names = FALSE)


# absolute values
test = c(1, 2, 3, 4, 5, 7)
abs(test - max(test)) 
0.5 + 6 *0.25 + 6 * 0.25

# create preston matrix
e = 0.4
test = expand.grid(iq_father = 1:7, iq_mother = 1:7, iq_kid = 1:7)
test = data.table(test)
test[iq_father == iq_mother & iq_kid == iq_mother, prop := 1-e]
test[iq_father == iq_mother & 
    (iq_kid == (iq_mother + 1) | iq_kid == (iq_mother - 1)), 
    prop := e/2]


test[iq_father == 1 & iq_mother == 1 & iq_kid == 2, prop := e]
test[iq_father == 7 & iq_mother == 7 & iq_kid == 6, prop := e]

table(test$prop)
test[iq_father != iq_mother & (iq_father == iq_kid | iq_mother == iq_kid), prop := 1/2]
test[is.na(prop), prop := 0]
table(test$prop)

write.xlsx(test, "test",  file = "data/matrixH.xlsx", row.names = FALSE)

# mating matrix
test = data.table(expand.grid(ego = 1:7, alter = 1:7))
test[, prop := 0.0]
write.xlsx(test, "mating", file = "data/mating.xlsx", row.names = FALSE)
