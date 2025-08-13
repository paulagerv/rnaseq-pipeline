# Snakefile - RNA-seq Pipeline usando config.yaml

# Cargar configuración
configfile: "config.yaml"

SAMPLES = config["samples"]

# Rutas
RAW_DIR = config["paths"]["raw_data"]
TRIMMED_DIR = config["paths"]["trimmed_data"]
RESULTS_DIR = config["paths"]["results"]
REFERENCE_INDEX = config["paths"]["reference_index"]
GTF_FILE = config["paths"]["gtf"]

# Regla principal: generar BAM y conteos
rule all:
    input:
        expand(f"{RESULTS_DIR}/{{sample}}.sorted.bam", sample=SAMPLES),
        expand(f"{RESULTS_DIR}/{{sample}}.counts.txt", sample=SAMPLES)

# QC con FastQC
rule fastqc:
    input:
        r1 = f"{RAW_DIR}/{{sample}}_1.fastq.gz",
        r2 = f"{RAW_DIR}/{{sample}}_2.fastq.gz"
    output:
        f"{RESULTS_DIR}/fastqc/{{sample}}_1_fastqc.html",
        f"{RESULTS_DIR}/fastqc/{{sample}}_2_fastqc.html"
    threads: 2
    shell:
        """
        fastqc {input.r1} {input.r2} -o {RESULTS_DIR}/fastqc -t {threads}
        """

# Trim con Cutadapt
rule cutadapt:
    input:
        r1 = f"{RAW_DIR}/{{sample}}_1.fastq.gz",
        r2 = f"{RAW_DIR}/{{sample}}_2.fastq.gz"
    output:
        r1_trimmed = f"{TRIMMED_DIR}/{{sample}}_1.trimmed.fastq.gz",
        r2_trimmed = f"{TRIMMED_DIR}/{{sample}}_2.trimmed.fastq.gz"
    threads: 2
    shell:
        """
        cutadapt -j {threads} \
            -q 20,20 -m 30 \
            -o {output.r1_trimmed} -p {output.r2_trimmed} \
            {input.r1} {input.r2}
        """

# Alineamiento con HISAT2
rule hisat2_align:
    input:
        r1 = f"{TRIMMED_DIR}/{{sample}}_1.trimmed.fastq.gz",
        r2 = f"{TRIMMED_DIR}/{{sample}}_2.trimmed.fastq.gz"
    output:
        bam = f"{RESULTS_DIR}/{{sample}}.sorted.bam"
    threads: 2
    params:
        index = REFERENCE_INDEX
    shell:
        """
        mkdir -p {RESULTS_DIR}
        hisat2 -p {threads} -x {params.index} -1 {input.r1} -2 {input.r2} | \
        samtools sort -@ {threads} -o {output.bam}
        samtools index {output.bam}
        """

# Conteo de genes con featureCounts
rule featurecounts:
    input:
        bam = f"{RESULTS_DIR}/{{sample}}.sorted.bam"
    output:
        counts = f"{RESULTS_DIR}/{{sample}}.counts.txt"
    threads: 2
    params:
        gtf = GTF_FILE
    shell:
        """
        featureCounts -T {threads} -p -a {params.gtf} -o {output.counts} {input.bam}
        """
