
#!/usr/bin/python


# python models/fertility-BMI/process_files.py "models/fertility-BMI/output/" "output/data/" "results-sobol"
import numpy as np
import pandas as pd
import os
import shutil
import glob


import sys
args = sys.argv

# function for reading csv files

def pd_read_pattern(pattern, sep):
    files = glob.glob(pattern)
    df = pd.DataFrame()
    for f in files:
        df = df.append(pd.read_csv(f, sep=sep))
    return df.reset_index(drop=True)

# function to remove files
def removeFiles(pattern):
    files = glob.glob(pattern)
    for file in files:
        try:
            os.remove(file)
        except:
            print("Error while deleting file : ", file)

# read output files
def readOutput(read_raw_files, path, output_path, result_file_name):
    if (read_raw_files):
        df = pd_read_pattern(path + "group*.csv", sep=";")
        params = pd_read_pattern(path + "par*.csv", sep=";")
        params = params.drop(columns=["replicate"])
        df.iteration = df.iteration.astype(float)
        df = df.sort_values(by=['iteration'])
        df = pd.merge(df, params, on="iteration")
        df.to_csv(output_path + result_file_name + ".csv", index=False)
    else:
        df = pd.read_csv(output_path + result_file_name + ".csv")
        return df

# read files
readOutput(True, args[1], args[2], args[3])
removeFiles(args[1] + "group*.csv")
removeFiles(args[1] +"par*.csv")
print(":::::::: Files read successfully")