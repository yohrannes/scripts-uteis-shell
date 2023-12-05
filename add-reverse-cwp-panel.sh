#!/bin/bash
echo '[1] CWP panel'
echo '[2] Cpanel'
read -p 'Digite o tipo de painel de hospedagem:' tipopainel
read -p 'Digite o dominio:' domain
echo Será adicionado um apontamento reverso para o ip $1.$2.$3.$4 no dominio $domain
if [ "$tipopainel" == "1" ]; then
    # echo $4 14400 IN PTR $domain. >> /var/named/"$3"."$2"."$1"*
    echo $4 14400 IN PTR $domain.  /var/named/"$3"."$2"."$1"*
elif [ "$tipopainel" == "2" ]; then
    # echo $4     14400   IN      PTR     $domain. >> /var/named/"$3"."$2"."$1"*
    echo "$4     14400   IN      PTR     $domain.  /var/named/$3.$2.$1*"
else
    echo opção errada
    sleep 2
fi
echo adicionando o seguinte PTR...
cat /var/named/"$3"."$2"."$1"* | tail -1
