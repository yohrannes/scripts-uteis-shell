#!/bin/bash
read -p "Digite o dominio desejado:" dominio
echo
read -p "Digite o host de destino:" hostdesejado
echo
read -p "Digite o porta de destino:" port
echo
hostdestino="$hostdesejado:$port"

cat <<EOT > /etc/nginx/conf.d/$dominio.conf
server {
  	listen *:80;
    listen [::]:80;
    server_name  $dominio;
  	access_log /var/log/nginx/$dominio.access_log main;
  	error_log /var/log/nginx/$dominio.error_log info;
 
        location / {
        proxy_pass  $hostdestino;
        proxy_redirect     off;
        proxy_set_header   Host             \$host;
        proxy_set_header   X-Real-IP        \$remote_addr;
        proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
      }
}
server {
  	listen       443 ssl;
  	listen       [::]:443  ssl;
    server_name  $dominio;
  	access_log /var/log/nginx/$dominio.access_log main;
  	error_log /var/log/nginx/$dominio.error_log info;
  
    ssl_certificate      /var/lib/jelastic/SSL/jelastic.chain;
    ssl_certificate_key  /var/lib/jelastic/SSL/jelastic.key;
    ssl_session_timeout  5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
    ssl_prefer_server_ciphers   on;
    ssl_session_cache shared:SSL:10m;
    
        location / {
        proxy_pass  $hostdestino;
        proxy_redirect     off;
        proxy_set_header   Host             \$host;
        proxy_set_header   X-Real-IP        \$remote_addr;
        proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
      }
}
EOT

if [ -f /etc/nginx/conf.d/$dominio.conf ]; then
  echo "Virtual Host criado com sucesso!"
else
  echo "Erro ao criar o arquivo."
fi