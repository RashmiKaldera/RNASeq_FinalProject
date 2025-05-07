#!/bin/bash
#SBATCH --job-name=indexSalmon
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 2                # Increased threads to match --nthread
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=16G
#SBATCH --mail-user= kalderadissasekara@uchc.edu
#SBATCH --output=/home/FCAM/rkalderadissasekara/eofiles/%x.%j.out  # Standard output log
#SBATCH --error=/home/FCAM/rkalderadissasekara/eofiles/%x.%j.err   # Standard error log

# Print job information
date
echo "Hostname: $(hostname)"

# Load required modules
module load salmon/1.9.0

# Set up directories

TRANSCRIPTOME="/home/FCAM/rkalderadissasekara/transcriptome/Homo_sapiens.GRCh38.cdna.all.fa"

INDEX="/home/FCAM/rkalderadissasekara/salmon_index"

mkdir -p "/home/FCAM/rkalderadissasekara/salmon_index"


# run salmon index
salmon index \
        -t $TRANSCRIPTOME \
        --index $INDEX \
        -k 31 \
        -p 2
