# RNA-seq Snakemake Pipeline

Pipeline para análisis de RNA-seq usando Snakemake, incluyendo:
example for RNA-seq. 2 conditions-1 sample per condition. mus musculus reference

- QC con FastQC
- Trim de reads con Cutadapt
- Alineamiento con HISAT2
- Conteo de genes con featureCounts

## Requisitos

- Conda
- Snakemake
- Dependencias listadas en `environment.yml`

## Cómo usar

1. Crear el entorno:

```bash
conda env create -f environment.yml
conda activate rnaseq
