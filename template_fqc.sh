#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=__EMAIL__
#SBATCH --mail-type=__EMAIL_TYPE__
#SBATCH --error=__ERR_LOG__
#SBATCH --output=__OUT_LOG__
#SBATCH --workdir=__WORK_DIR__

export MUGQIC_INSTALL_HOME=/cvmfs/soft.mugqic/CentOS6  
module use $MUGQIC_INSTALL_HOME/modulefiles
module load fastqc/0.11.5
module load mugqic/MultiQC/v1.6

inputFiles=../data/_all_fq.txt

rm ../data/*.fastq 

gunzip -k ../data/*R*.fastq.gz

time fastqc -o ../results/_fastqc/ --dir ../results/_TMP -f fastq  ../data/*R*.fastq
rm ../data/*.fastq 

time multiqc --outdir ../results/_fastqc ../results/_fastqc 


