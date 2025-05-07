#!/bin/bash
#SBATCH --job-name=srr2fastq
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mem=12G
#SBATCH --mail-type=END
#SBATCH --mail-user=kalderadissasekara@uchc.edu
#SBATCH --output=/home/FCAM/rkalderadissasekara/eofiles/%x.%j.out
#SBATCH --error=/home/FCAM/rkalderadissasekara/eofiles/%x.%j.err

set -e  # Exit on any error

# Print basic info
start_time=$(date +%s)
echo "Starting conversion on $(hostname) at $(date)"

# Load sratoolkit
module load sratoolkit

INPUT_DIR="/home/FCAM/rkalderadissasekara/srr_files"
OUTPUT_DIR="/home/FCAM/rkalderadissasekara/fastq_files"
mkdir -p "$OUTPUT_DIR"

# Expected sample labels in correct order
sample_labels=(
    "UCD4_EWD_1" "UCD4_EWD_2" "UCD4_EWD_3"
    "UCD4_FulvR_1" "UCD4_FulvR_2" "UCD4_FulvR_3"
    "UCD4_TamR_1" "UCD4_TamR_2" "UCD4_TamR_3"
    "UCD4_parental_1" "UCD4_parental_2" "UCD4_parental_3"
    "T47D_FulvR_1" "T47D_FulvR_2" "T47D_FulvR_3"
    "T47D_TamR_1" "T47D_TamR_2" "T47D_TamR_3"
    "T47D_parental_1" "T47D_parental_2" "T47D_parental_3"
)

# Sort .sra files
sra_files=($(ls "$INPUT_DIR"/*.sra | sort))

# Safety check
if [ ${#sra_files[@]} -ne ${#sample_labels[@]} ]; then
    echo "Mismatch: ${#sra_files[@]} SRA files but ${#sample_labels[@]} sample labels."
    exit 1
fi

# Convert and rename
for i in "${!sra_files[@]}"; do
    sra_file="${sra_files[$i]}"
    label="${sample_labels[$i]}"
    sra_base=$(basename "$sra_file" .sra)

    echo "Converting $sra_base → $label"

    fasterq-dump "$sra_file" -O "$OUTPUT_DIR" -e 4

    # Rename
    mv "$OUTPUT_DIR/${sra_base}_1.fastq" "$OUTPUT_DIR/${label}_1.fastq"
    mv "$OUTPUT_DIR/${sra_base}_2.fastq" "$OUTPUT_DIR/${label}_2.fastq"

    # Compress
    gzip "$OUTPUT_DIR/${label}_1.fastq"
    gzip "$OUTPUT_DIR/${label}_2.fastq"

    echo "Finished and gzipped: $label"
done

echo "All FASTQ files converted, renamed, and compressed."

end_time=$(date +%s)
runtime=$((end_time - start_time))
echo "Total runtime: $((runtime / 60)) min $((runtime % 60)) sec"

