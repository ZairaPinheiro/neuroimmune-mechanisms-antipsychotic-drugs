# This script is compare a set of drug and disease genes with the script "network_proximity_edit.py," which calculates the network proximity between them

# Importing the necessary libraries
import glob, os

# Defining the directory where the .txt search will occur
directory = ""
# Defining some variables
seed = 1000                                                              # A random number generator seed
reapt = 1000                                                             # The number of repetitions to perform
input2 = "/Disease_genes.txt"  # The path to the "Disease_genes.txt" file
script = "/network_proximity_edit.py" # The path to the "network_proximity_edit.py" script.

# Starting the list that will contain the PATH of the .txt
archives = []

# Getting the .txt files
os.chdir(f"{directory}")
for file in glob.glob("*.txt"):
    archives.append(os.path.join(f"{directory}", file))

# Function to open both files (drug_files)
def recive(file,input2):
    #  Call the "network_proximity_edit.py" script via CMD with the four arguments  
    print(f'comparing drug {file}, with {input2}')
    os.system(f' python {script} {file} {input2} {reapt} {seed} >> /proximity_for_drug_diesease.txt')


# call the function passing the gene files as a parameter to compare them
for file in archives:
    recive(file,input2)
