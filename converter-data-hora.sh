#!/bin/bash
datas[0]=10/10/2023; horas[0]=01:15:01
datas[1]=10/11/2023; horas[1]=21:15:00
datas[2]=10/12/2023; horas[2]=21:14:15
datas[3]=10/13/2023; horas[3]=21:23:50
datas[4]=10/14/2023; horas[4]=22:19:31
datas[5]=10/15/2023; horas[5]=21:27:06
datas[6]=10/16/2023; horas[6]=21:15:05

for ((i=0;i<=6;i++)); do echo -e '\e[32m'$i - ${datas[$i]} ${horas[$i]}'\e[0m'; done; echo;

for ((i=0;i<=6;i++)); do
    data_brasil[$i]=$(date -d "${datas[$i]}" +"%d/%m/%Y")
    hora_ajustada[$i]=$(date -d "${horas[$i]} 3 hours ago" +"%H:%M:%S")
    if [[ "${horas[$i]}" < "18:00:00" ]]; then
        data_brasil[i]=$(date -d "${datas[$i]} 1 day ago" +"%d/%m/%Y")
    fi
done

for ((i=0;i<=6;i++)); do echo -e '\e[32m'$i - ${data_brasil[$i]} ${hora_ajustada[$i]}'\e[0m'; done; echo;