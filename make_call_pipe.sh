#!/bin/bash


###rm ../results/*hisat2*  ../results/*slurm*  ../results/RNA-Seq_checkpoint.txt


# mkdir ../results/_logs  ../results/_SAM ../results/_QC
# 
#  
# # 
WORKDIR=$__WORKDIR__

mkdir $WORKDIR/$1/results/_logs $WORKDIR/$1/results/_fastqc $WORKDIR/$1/results/_TMP
rm $WORKDIR/$1/results/_logs/qc_* $WORKDIR/$1/results/_fastqc/*

temp_path=$WORKDIR/FastQC
WORKDIR=$WORKDIR/$1
inputFiles=$WORKDIR/data/_all_fq.txt
labels=$WORKDIR/results/_labels.txt
fld=$(ls $WORKDIR/data/*_R1*.fastq.gz |awk -F"/" '{print NF}' | uniq)
fld=$((fld+0))
ls $WORKDIR/data/*_R1*.fastq.gz |cut -f$fld -d"/" | cut -f1 -d"." |sed 's/.$//g' |sed 's/.$//g' | uniq  > $labels

errDir="$WORKDIR/results/_logs/$5.out"
outDir="$WORKDIR/results/_logs/$5.err"
ls -1  $WORKDIR/data/*_R1*.fastq.gz  > $inputFiles
WORKDIR="$WORKDIR/scripts"


# rm $WORK_DIR/180911_Lim/data/*.fq

for i in `ls -1  $temp_path/template_*.sh | cut -f$fld -d"/"`;  do  sed "s/__JOBID__/$1/g"  $temp_path/$i |sed "s/__EMAIL__/$2/g"|sed "s~__WORK_DIR__~$WORKDIR~g"|sed "s~__ERR_LOG__~$errDir~g"|sed "s~__OUT_LOG__~$outDir~g"|sed "s/__EMAIL_TYPE__/$3/g"> $WORKDIR/$i; echo $i; done	
# 
# |sed "s/__ERR_LOG__/$errDir/g"|sed "s/__OUT_LOG__/$outDir/g" 

# 
# list all your subject and put them in a file
# |sed "s/__WORK_DIR__/${WORK_DIR}/g"
#   |sed "s/__ERR_LOG__/$errDir" |sed "s/__OUT_LOG__/$outDir"





# more template_hisat2.sh
out1=$(sbatch --job-name=QC_$1 --account=$4 ${WORKDIR}/template_fqc.sh)
JOB_ID1=$(echo $out1 | cut -d" " -f4)
echo $JOB_ID1

