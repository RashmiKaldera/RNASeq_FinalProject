# RNASeq_FinalProject

This project aims to develop a workflow that can be used to analyze RNASeq data to infer information on the differential expression of genes. The workflow is developed for the paper ["Lipid metabolic reprogramming drives triglyceride storage and variable sensitivity to FASN inhibition in endocrine-resistant breast cancer cells"](https://pubmed.ncbi.nlm.nih.gov/40055794/) which suggests that lipid metabolic reprogramming is increasingly recognized as a hallmark of endocrine resistance in estrogen receptor-positive (ER+) breast cancer. In this study, they investigated alterations in lipid metabolism in ER + breast cancer cell lines. The Geo Accession number for the study is [GSE281935](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE281935). The raw SRA files are available at [this link](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA1186202&o=acc_s%3Aa).

### Log in commands
`ssh rkalderadissasekara@xanadu-submit-ext.cam.uchc.edu `

Setting up an interactive session

`srun --pty -p general --qos=general --mem=8G bash`
### Downloading and validating the SRR files

Used the script [SRRdownload.sh](https://github.com/RashmiKaldera/RNASeq_FinalProject/blob/main/Scripts/SRRdownload.sh) to download the SRR files and to validate them using the following command.

`chmod +x SRRdownload.sh`

`sbatch SRRdownload.sh`
### Generating fastq files and renaming the samples
Used `fasterq-dump` with the script [srrtofastq.sh](https://github.com/RashmiKaldera/RNASeq_FinalProject/blob/main/Scripts/srrtofastq.sh) to generate the fastq files for paired end sequencing data using the same commands as before.
### Creating Salmon index files
Because the authors are interested in differential expression on per gene basis and not transcript isoform levels, psuedoalignment with Salmon. To generate the Salmon index file, the human transcriptome.fa was obtained from [Ensembl](https://useast.ensembl.org/index.html) using the following command.

`wget https://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz`
`gunzip Homo_sapiens.GRCh38.cdna.all.fa.gz`

The Salmon index was then generated using the script [salmon_index.sh](https://github.com/RashmiKaldera/RNASeq_FinalProject/blob/main/Scripts/salmon_index.sh).
### Quantifying with Salmon Quant
A matrix of counts was obtained for each sample using the script [salmon_quant.sh](https://github.com/RashmiKaldera/RNASeq_FinalProject/blob/main/Scripts/salmon_quant.sh).
### Downloading the salmon_quant folder for downstream analysis using sftp
`get -r salmon_quant` 
### Differential gene expression analysis

The downstream analysis of Deseq and ORA was performed using the produced `quant.sf` files on R studio. The complete analysis is available on [Differential Gene Expression Analysis_SalmonQuant.rmd](https://github.com/RashmiKaldera/RNASeq_FinalProject/blob/main/R/DifferentialExpressionAnalysis_SalmonQuant.Rmd).

### Conclusion
The authors of the paper had used Star for genome alignment coupled with cufflinks to generate downstream expression analysis. However, I used a different approach here with pseudoalignment with Salmon. Even from my results, I can see that the lipid metabolic pathways are upregulated in endocrine resistant breast cancer cells which aligns with what the paper has observed. Therefore, this workflow can be used for RNAseq differential expression analysis pipelines.
