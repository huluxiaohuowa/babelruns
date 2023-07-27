#!/bin/bash

smifile=${1}
ncpu=${2}
# substructure=${3}
patts_file=${3}
num_patts=`wc -l ${patts_file} | awk '{print $1}'`
readarray -t patts < ${patts_file}

lines=`wc -l ${smifile} | awk '{print $1}' `
subline=$((lines/ncpu+1))

split -l  ${subline} ${smifile} sub

files=($(ls sub*))
for i in `ls sub*`; do
    mv ${i} ${i}.smi
done

for patt_i in $(seq 1 ${num_patts}); do
    patt=${patts[${patt_i}-1]}
    for i in ${files[*]}; do

        obabel ${i}.smi -s "${patt}" -O ${i}_${patt_i}_out.smi &
        # cat *_out.smi > ${patt_i}_out.smi

    done
    wait
    cat *_${patt_i}_out.smi > patt_${patt_i}_results.smi
    find . -name '*_out.smi' -type f -delete

done

wait

# cat *_out.smi > out.smi

find . -name 'sub*.smi' -type f -delete
