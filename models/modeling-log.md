
### 2022-03-26

- It looks that the baseline is in HW equilibrium
    - Need to simulate several replicates and check
- The allele frequencies now comes from a uniform distribution (0-.4), where half
     of the snps uses to sample frequencies (e.g., if there is 100 snps, 50 samples 
     for frequencies are drawn)
- The error in the simulation seems to be related to memory limits, I am currently using 1024 x 25

### 2022-03-25

- Assess if there is a function to check SNPs are in equilibrium
- Run sensitivity for the matrix and SNP versions of the model
    - Efast
    - Sobol
- Getting an error in the SNP simulation (output writing)
- Different assortative mating by BMI (logistic regression)?