#!/bin/bash

smifile=${1}
ncpu=${2}
crifile=${3}
num_cris=`wc -l ${crifile} | awk '{print $1}'`
readarray -t cris < ${crifile}

lines=`wc -l ${smifile} | awk '{print $1}' `
subline=$((lines/ncpu+1))

split -l  ${subline} ${smifile} sub

files=($(ls sub*))
for i in `ls sub*`; do
    mv ${i} ${i}.smi
done

for cri_i in $(seq 1 ${num_cris}); do
    cri=${cris[${cri_i}-1]}
    cri_name=$(echo $cri | tr -d '[:blank:]')
    cri_name=${cri_name//">"/"gt"}
    cri_name=${cri_name//"<"/"lt"}

    for i in ${files[*]}; do

        obabel ${i}.smi -osmi --filter "$cri" -O ${i}_${cri_i}_out.smi &
        # cat *_out.smi > ${patt_i}_out.smi

    done
    wait
    cat *_${cri_i}_out.smi > cri_${cri_name}_results.smi
    find . -name '*_out.smi' -type f -delete

done

wait

# cat *_out.smi > out.smi

find . -name 'sub*.smi' -type f -delete
