# This script purpose is to compare the network proximity between pairs of drug-related files.

import glob, os

# Defining the directory where the .txt search will occur
directory = ""
# Defining some variables
seed = 1000
reapt = 1000
script = "/network_proximity_edit.py"

# Starting the list that will contain the PATH of the .txt
archives = []

# Getting the .txt files
os.chdir(f"{directory}")
for file in glob.glob("*.txt"):
    archives.append(os.path.join(f"{directory}", file))

# Function to open two files
def recive(file,files):
    for i in files:
        #  Call the "network_proximity_edit.py" script via CMD with the four arguments
        print(f'comparing drug {file}, with {i}')
        os.system(f' python {script} {file} {i} {reapt} {seed} >> /proximity_for_drug_drug.txt')


# This loop is used to call the function passing the gene files as a parameter to compare them. The loop iterates until all files have been compared.
pos = 0
while pos < len(archives):
    recive(archives[pos],archives[pos+1:])
    if pos+1 == len(archives)-1:
        break
    else:
        pos +=1