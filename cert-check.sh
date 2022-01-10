#!/bin/bash

set -euo pipefail

rd=$(tput setaf 1) 
rst=$(tput sgr0)           
neon=$(tput setaf 118)  

IFS=$'\n'
printf "\033c"
echo "-------------------------------------------------------------------------------------------------------------------------

                         888                  888                        888      
                         888                  888                        888      
 .d8888b .d88b.  888d888 888888       .d8888b 88888b.   .d88b.   .d8888b 888  888 
d88P    d8P  Y8b 888P    888         d88P     888  88b d8P  Y8b d88P     888 .88P 
888     88888888 888     888         888      888  888 88888888 888      888888K  
Y88b.   Y8b.     888     Y88b.       Y88b.    888  888 Y8b.     Y88b.    888  88b 
 Y8888P  Y8888   888      Y888        Y8888P  888  888  Y8888    Y8888P  888  888
"
echo "-------------------------------------------------------------------------------------------------------------------------"
echo "STATUS CODES: X = OUT OF TOLERANCE O = NOT EXPIRED"
echo "-------------------------------------------------------------------------------------------------------------------------"
echo "STATUS  |  DAYS TILL EXP   |   FILE NAME AND LOCATION"
echo "-------------------------------------------------------------------------------------------------------------------------"

for dir in $(find ~ -type f -name "*.crt" 2>/dev/null | grep "\.crt$" | sed 's:[^/]*$::') ; do
    cd "${dir}" >/dev/null
    files=($(find ~ -type f -name "*.crt" 2>/dev/null | grep "\.crt$"))

    for file in ${files[*]} ; do
        dateone="$(openssl x509 -enddate -noout -in "${file}" | sed -e 's/notAfter=//g')"         
        datetwo="$(date +"%b %d%t%H:%M:%S %Y %Z")"
        dateone_seconds="$(date -j -f "%b %d%t%H:%M:%S %Y %Z" "${dateone}" "+%s")"                  
        datetwo_seconds="$(date -j -f "%b %d%t%H:%M:%S %Y %Z" "${datetwo}" "+%s")"
        let difference="${dateone_seconds}"-"${datetwo_seconds}"                               
        let result="${difference}"/86400
            if [[ $result -lt 1 ]]; then
                printf "/ "${result}" "${file}$" " \
                    | awk '{printf "%-13s %-16s %-15s %-1s %-1s\n", $1, $2, $3, $4, $5}'
            else
                printf "O "${result}" "${file}" " \
                    | awk '{printf "%-13s %-16s %-15s %-1s %-1s\n", $1, $2, $3, $4, $5}'
            fi
            cd ~ >/dev/null   
        done
    break
done
