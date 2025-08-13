
# RNA-seq Snakemake Pipeline

Pipeline para análisis de RNA-seq usando **Snakemake**.  
Ejemplo: 2 condiciones, 1 muestra por condición. Referencia: *Mus musculus*.

El workflow realiza:

- Control de calidad (QC) de reads con **FastQC**
- Recorte de reads con **Cutadapt**
- Alineamiento con **HISAT2**
- Conteo de genes con **featureCounts**

## Requisitos

- Conda
- Snakemake
- Dependencias listadas en `environment.yml`

## Instalación del entorno

```bash
conda env create -f environment.yml
conda activate rnaseq
````

## Uso del pipeline

1. Coloca tus archivos fastq en `data/raw/` con el formato `{sample}_1.fastq.gz` y `{sample}_2.fastq.gz`.
2. Revisa y ajusta los nombres de muestras en `config.yaml`.
3. Ejecuta Snakemake:

```bash
snakemake --cores 4
```

> Ajusta el número de cores según tu máquina.

## Estructura de directorios

```
rnaseq-pipeline/
├── data/             # Archivos de entrada (fastq)
├── reference/        # Archivos de referencia (genoma, GTF)
├── results/          # Salida del pipeline
├── scripts/          # Scripts auxiliares (opcional)
├── Snakefile         # Workflow principal
├── config.yaml       # Configuración de muestras
├── environment.yml   # Entorno Conda con dependencias
├── README.md
└── .gitignore
```

## GitHub

Repositorio: [https://github.com/paulagerv/rnaseq-pipeline](https://github.com/paulagerv/rnaseq-pipeline)

---


