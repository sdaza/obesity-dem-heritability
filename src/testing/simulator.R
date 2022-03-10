library(PhenotypeSimulator)


# simulate simple bi-allelic genotypes and estimate kinship
genotypes <- simulateGenotypes(N = 1000, NrSNP = 1000, 
                               frequencies = c(0.5), 
                               verbose = FALSE)
causalSNPs <- getCausalSNPs(N=1000, genotypes = genotypes$genotypes, 
                            NrCausalSNPs = 100, verbose = FALSE)
genFixed <- geneticFixedEffects(N = 1000, P = 1, X_causal = causalSNPs, pIndependentGenetic = 1) 


snp <- rbinom(200, 2, 0.3)
prop.table(table(snp))
allelefreq <- getAlleleFrequencies(snp)
allelefreq

noiseBg <- noiseBgEffects(N = 1000, P = 1, share = FALSE)
str(noiseBg)
# parameters
genVar <- 0.3
noiseVar <- 1 - genVar
totalSNPeffect <- 0.10
h2s <- totalSNPeffect/genVar

# rescale phenotype components
genFixed_independent_scaled <- rescaleVariance(genFixed$independent, genVar)
noiseBg_independent_scaled <- rescaleVariance(noiseBg$independent, noiseVar)

        var_component <- var(genFixed$independent)
        mean_var <- mean(diag(var_component))
        scale_factor <- sqrt(propvar/mean_var)
        component_scaled <- genFixed$independent * scale_factor

mean(genFixed_independent_scaled$component)
mean(noiseBg_independent_scaled$component)

# Total variance proportion shave to add up yo 1
total <-  noiseVar + genVar
total == 1
#> [1] TRUE

# combine components into final phenotype
Y <- genFixed_independent_scaled$component + noiseBg_independent_scaled$component
summary(Y)


hist(Y)
# transform phenotype non-linearly
Y_nl <- transformNonlinear(Y, alpha=0.7, method="exp")

covs
str(genFixed)
ind = genFixed$independent
genFixed$cov_effect


effects = t(genFixed$cov_effect)
effects
effects
covs = genFixed$cov
tt = causalSNPs %*% effects
tt
ind





genVar <- 0.6
noiseVar <- 1 - genVar
totalSNPeffect <- 0.01
h2s <- totalSNPeffect/genVar

phi <- 0.6 
rho <- 0.1
delta <- 0.3
shared <- 0.8
independent <- 1 - shared

# rescale phenotype components
genFixed_shared_scaled <- rescaleVariance(genFixed$shared, shared * h2s *genVar)
noiseBg <- noiseBgEffects(N = 100, P = 1)

noiseBg
 geneticFixedEffects
str(genotypes)

table(genotypes$genotypes[, 1])

genotypes_sd <- standardiseGenotypes(genotypes$genotypes)
genotypes_sd
kinship <- getKinship(N=10, X=genotypes_sd, verbose = FALSE)
kinship

?simulateGenotypes
