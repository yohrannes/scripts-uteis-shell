#!/bin/bash

#
sudo mkdir -p ~/scripts

read -p "Digite o email para receber notificações de uso acima de 90%: " TO_EMAIL
read -p "Digite o nome do usuário atual: " USER
cat <<EOF > ~/scripts/monitorador_de_uso_acima_de_90.sh
#!/bin/bash
# Script de monitoramento
LOG_FILE="/var/log/system_monitor.log"

while true; do
    # CPU usage
    CPU_USAGE=\$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\\\\([0-9.]*\\\\)%* id.*/\\\\1/" | awk '{print 100 - \$1}')
    
    # Memory usage
    MEM_USAGE=\$(free | grep Mem | awk '{printf("%.0f", \$3/\$2 * 100.0)}')
    
    # Log se uso alto (>90%)
    if [ \$(echo "\$CPU_USAGE" | cut -d. -f1) -gt 90 ] || [ "\$MEM_USAGE" -gt 90 ]; then
        {
            echo "\$(date): High usage - CPU: \${CPU_USAGE}%, MEM: \${MEM_USAGE}%"
            echo "=== TOP CPU PROCESSES ==="
            ps aux --sort=-%cpu | head -5
            echo "=== TOP MEMORY PROCESSES ==="
            ps aux --sort=-%mem | head -5
            echo "---"
        } >> "\$LOG_FILE"

        # Get instance name metadata (check oficial doc)
        # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/work-with-tags-in-IMDS.html#allow-access-to-tags-in-IMDS
        TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
        curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/

        TO_EMAIL="$TO_EMAIL"
        INSTANCE_NAME=\$(curl -s http://169.254.169.254/latest/meta-data/tags/instance/Name || echo "Unknown Instance")
        SUBJECT="Alto consumo de CPU identificado - \$INSTANCE_NAME"

        {
            echo "\$INSTANCE_NAME - CPU > 90% - Verifique a instância imediatamente."
            echo ""
            echo "Segue abaixo os top processos/causas de travamento de CPU e MEMÓRIA na máquina, no período de alto consumo!!!."
            echo ""
            echo "=== ÚLTIMOS REGISTROS ==="
            tail -n14 /var/log/system_monitor.log
            echo ""
            echo "Data/Hora: \$(date)"
            echo "Hostname do servidor: \$(hostname)"
        } | mail -s "\$SUBJECT" "\$TO_EMAIL"

    fi
    sleep 60
done
EOF

sudo chmod +x ~/scripts/monitorador_de_uso_acima_de_90.sh

sudo tee /etc/systemd/system/system-monitor.service > /dev/null <<EOF
[Unit]
Description=System Monitor Script
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/home/$USER/scripts/monitorador_de_uso_acima_de_90.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable system-monitor.service
sudo systemctl start system-monitor.service
sudo systemctl status system-monitor.service
