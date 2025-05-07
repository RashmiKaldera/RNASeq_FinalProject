# RNASeq_FinalProject

This project aims to develop a workflow that can be used to analyze RNASeq data to infer information on the differential expression of genes. The workflow is developed for the paper ["Lipid metabolic reprogramming drives triglyceride storage and variable sensitivity to FASN inhibition in endocrine-resistant breast cancer cells"](https://pubmed.ncbi.nlm.nih.gov/40055794/). The Geo Accession number is [GSE281935](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE281935). The raw SRA files are available at [this link](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA1186202&o=acc_s%3Aa).

### Log in commands
`ssh rkalderadissasekara@xanadu-submit-ext.cam.uchc.edu `

Setting up an interactive session

`srun --pty -p general --qos=general --mem=8G bash`

Used the script 
