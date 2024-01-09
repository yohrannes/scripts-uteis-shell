#!/bin/bash
if [ "$1" == "--help" ]; then
    echo How to use...
    echo O RANGE do DNS reverso no CWP já deve estar pré-configurado.
    echo ip desejado 192.168.0.1 para o host my.domain.com
    echo Executar o arquivo desta forma .... 
    echo ./add-reverse-cwp-panel.sh 192 168 0 1 my.domain.com
else
    echo Será adicionado um apontamento reverso para o ip $1.$2.$3.$4 no dominio $5
    if [ -d "/usr/local/cwpsrv" ]; then
        echo $4 14400 IN PTR $5. >> /var/named/"$3"."$2"."$1"*
    elif [ -d "/usr/local/cpanel" ]; then
        echo "$4     14400   IN      PTR     $5." >> /var/named/"$3"."$2"."$1"*
        /usr/local/cpanel/scripts/restartsrv_bind --restart --hard
        /usr/local/cpanel/scripts/restartsrv_dnsadmin --restart --hard
        /scripts/restartsrv_named --hard
    else
        echo Opção errada
        sleep 2
    fi
    echo adicionando o seguinte PTR...
    cat /var/named/"$3"."$2"."$1"* | tail -1
fi
