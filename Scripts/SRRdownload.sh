#!/bin/bash
#SBATCH --job-name=SRRDownload
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 3
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=4G
#SBATCH --mail-user=kalderadissasekara@uchc.edu
#SBATCH --output=/home/FCAM/rkalderadissasekara/eofiles/%x.%j.out  # Standard output log
#SBATCH --error=/home/FCAM/rkalderadissasekara/eofiles/%x.%j.err   # Standard error log

set -e  # Exit if any command fails

# Record start time
start_time=$(date +%s)

date
echo "Hostname: $(hostname)"

# Load sratoolkit
module load sratoolkit

# Output directory for SRR data
OUTPUT_DIR="/home/FCAM/rkalderadissasekara/srr_downloads"
mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

# Download and validate SRR files
for i in $(seq -w 608 628); do
    SRR_ID="SRR31352${i}"
    echo "Downloading $SRR_ID..."
    prefetch "$SRR_ID"

    echo "Validating $SRR_ID..."
    vdb-validate "$SRR_ID" || echo "Validation failed for $SRR_ID"

    echo "-----------------------------"
done

echo "SRR download and validation completed."

# Record end time
end_time=$(date +%s)
runtime=$((end_time - start_time))
echo "Total runtime: $((runtime / 60)) minutes and $((runtime % 60)) seconds."

