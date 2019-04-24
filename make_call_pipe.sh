#!/bin/bash


###rm ../results/*hisat2*  ../results/*slurm*  ../results/RNA-Seq_checkpoint.txt


# mkdir ../results/_logs  ../results/_SAM ../results/_QC
# 
#  
# # 
WORK_DIR=$__WORKDIR__

mkdir $WORK_DIR/$1/results/_logs $WORK_DIR/$1/results/_fastqc $WORK_DIR/$1/results/_TMP
rm $WORK_DIR/$1/results/_logs/qc_* $WORK_DIR/$1/results/_fastqc/*

temp_path=$WORK_DIR/FastQC
fld=$(ls -1  $temp_path/template_*.sh |awk -F"/" '{print NF}' | uniq)
fld=$((fld+0))

# rm $WORK_DIR/180911_Lim/data/*.fq

for i in `ls -1  $temp_path/template_*.sh | cut -f$fld -d"/"`;  do  sed "s/JOBID/$1/g"  $temp_path/$i |sed "s/__EMAIL__/$2/g" |sed "s/__EMAIL_TYPE__/$3/g" |sed 's/__WORKDIR__/${WORK_DIR}/g' > $WORK_DIR/$1/scripts/$i; done	


inputFiles=$WORK_DIR/$1/data/_all_fq.txt
labels=$WORK_DIR/$1/results/_labels.txt
# list all your subject and put them in a file

########????!!!!!! WHAT IS THIS SED COMMAND IS DOING HERE??? !!!!!!????########
ls -1  $WORK_DIR/$1/data/*_R1*.fastq.gz |sed "s/JOBID/$1/g" > $inputFiles
########????!!!!!!!!!!!!!!!!!sed "s/JOBID/$1/g"!!!!!!!!!!!!!!!!!!!!????########

fld=$(ls $WORK_DIR/$1/data/*_R1*.fastq.gz |awk -F"/" '{print NF}' | uniq)
fld=$((fld+0))

ls $WORK_DIR/$1/data/*_R1*.fastq.gz |cut -f$fld -d"/" | cut -f1 -d"." |sed 's/.$//g' |sed 's/.$//g' | uniq  > $labels


# more template_hisat2.sh
out1=$(sbatch --job-name=QC_$1 --account=$4 ${WORK_DIR}/${1}/scripts/template_fqc.sh)
JOB_ID1=$(echo $out1 | cut -d" " -f4)
echo $JOB_ID1

