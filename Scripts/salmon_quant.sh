#!/bin/bash
#SBATCH --job-name=quant_Salmon
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4   
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=16G
#SBATCH --mail-user=kalderadissasekara@uchc.edu
#SBATCH --output=/home/FCAM/rkalderadissasekara/eofiles/%x.%j.out
#SBATCH --error=/home/FCAM/rkalderadissasekara/eofiles/%x.%j.err

set -e  # Exit immediately if any command fails

start_time=$(date +%s)

date
echo "Hostname: $(hostname)"

module load salmon/1.9.0

FASTQ_DIR="/home/FCAM/rkalderadissasekara/fastq_files"
OUTPUT_DIR="/home/FCAM/rkalderadissasekara/salmon_quant"
SALMON_INDEX="/home/FCAM/rkalderadissasekara/salmon_index"

mkdir -p "$OUTPUT_DIR"

# Loop through all *_1.fastq.gz files
for R1 in "$FASTQ_DIR"/*_1.fastq.gz; do
    SAMPLE=$(basename "$R1" _1.fastq.gz)
    R2="$FASTQ_DIR/${SAMPLE}_2.fastq.gz"
    SAMPLE_OUT="$OUTPUT_DIR/${SAMPLE}_quant"

    echo "Running Salmon for $SAMPLE..."

    salmon quant -i "$SALMON_INDEX" \
                 -l A \
                 -1 "$R1" -2 "$R2" \
                 -p 4 \
                 -o "$SAMPLE_OUT"
done

echo "Salmon quantification completed for all samples."

end_time=$(date +%s)
runtime=$((end_time - start_time))
echo "Pipeline completed successfully."
echo "Total runtime: $((runtime / 60)) minutes and $((runtime % 60)) seconds."

