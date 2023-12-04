#!/bin/bash
read -p 'Digite o ip desejadp para criar o apontamento PTR reverso' ip
cat $ip | grep .
# cat /var/named | grep $4.$3.$2