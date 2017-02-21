#! /usr/bin/env bash 

datasets="$HOME/data-sets"


CTCF="$datasets/bed/encode.tfbs.chr22.bed.gz"
H3K4me3="$datasets/bed/encode.h3k4me3.hela.chr22.bed.gz"

#1 Use BEDtools intersect to identify the size of the largest overlap between CTCF and H3K4me3 locations.

answer_1=$(bedtools intersect -wo -a $CTCF -b $H3K4me3 | awk 'BEGIN {OFS="\t"} ($4 == "CTCF")' | sort -k15nr | cut -f15 | head -n1)
 
echo "answer-1: $answer_1"


#2 Use BEDtools to calculate the GC content of nucleotides 19,000,000 to 19,000,500 on chr22 of hg19 genome build. 
#  Report the GC content as a fraction e.g., 0.50

fasta="$datasets/fasta/hg19.chr22.fa"
bed="$datasets/bed/interval.bed"

answer_2=$(bedtools nuc -fi $fasta -bed $bed | grep -v "^#" | awk 'BEGIN {OFS="\t"} {printf $5 * 100}' | cut -f5)

echo "answer-2: $answer_2" 




#3 Use BEDtools to identify the length of the CTCF ChIP-seq peak (i.e.,
#  interval) that has the largest mean signal in ctcf.hela.chr22.bg.gz

CTCFpeaks="$datasets/bed/encode.tfbs.chr22.bed.gz"
signal="$datasets/bedtools/ctcf.hela.chr22.bg.gz"

answer_3=$(bedtools map -c 4 -o mean -a $CTCFpeaks -b $signal | awk 'BEGIN {OFS="\t"} ($5 !=".")' | awk 'BEGIN {OFS="\t"} ($4 == "CTCF")' | sort -k5gr | awk 'BEGIN {OFS="\t"} {print $0, $3 - $2}' | cut -f6 | head -n1)

echo "answer-3: $answer_3"


#4 Use BEDtools to identify the gene promoter (defined as 1000 bp upstream
#  of a TSS) with the highest median signal in ctcf.hela.chr22.bg.gz. Report
#  the gene name e.g., 'ABC123'

promoter="$datasets/bed/tss.hg19.chr22.bed.gz"
signal="$datasets/bedtools/ctcf.hela.chr22.bg.gz"

answer_4=$( bedtools map -c 4 -o median -a $promoter -b $signal | awk 'BEGIN {OFS="\t"} ($7 !=".")' | sort -k7gr | cut -f4 | head -n1)


echo "answer-4: $answer_4"


#5 Use BEDtools to identify the longest interval on chr22 that is not
#  covered by genes.hg19.bed.gz. Report the interval like chr1:100-500

bed="$datasets/bed/genes.hg19.bed.gz"
genome="$datasets/genome/hg19.genome"

answer_5=$( bedtools complement -i $bed -g $genome | awk 'BEGIN {OFS="\t"} {print $0, $3 - $2}' | sort -k4nr | awk '{OFS="\t"} {print $1 ":" $2 "-" $3}' | grep chr22 | head -n1)

echo "answer-5: $answer_5" 

#6 Use one or more BEDtools that we haven't covered in class. Be creative.

chr22="$datasets/bedtools/ctcf.hela.chr22.bg.gz"

answer_6=$(bedtools spacing -i $chr22 | awk 'BEGIN {OFS="\t"} ($5 !=".")' | cut -f5 | sort -k1nr | head -n1 | awk '{print $1 " :Largest spacing between ctcf intervals on chr22"}') 

echo "answer-6: $answer_6"



