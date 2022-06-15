
### 2022-06-15

- Added vertical transmission and genetic influences
  - Average of parent's BMI 
- Re-runned sensitivity analysis
- Explore outcome changes
  - Include scenario with out mating (random) and no fertility (future)

### 2022-05-07

- Create class for sensitivity analysis
- Run simulations for Sobol
- Run simulations to show differences in outcome

### 2022-05-06

- Optimized the assignment of random bmi values from bmi categories or groups
- Implemented bmi group differentials in mating using a logistic function
- Sensitivity analysis using vertical transmission

### 2022-05-04

- Simulation is kind of slow, find ways to optimize (specially vertical transmission)

### 2022-04-22

- The key factor moving away from HW equilibrum is fertility

### 2022-04-03

- Implement vertical transmission
    - I have tried serveral ways
    - I will use Preston's matrix, leakage will define different rules of transmission
- Explore importance of parameters when genetic and vertical transmission are working


### 2022-03-27

- Create an output of the AM by obesity group 
- Define mating to be different by BMI
- Create a more flexible definition of fertility differentials (function)

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