#!/bin/bash

sudo mkdir -p /home/ubuntu/scripts

cat <<EOF > /home/ubuntu/scripts/monitorador_de_uso_acima_de_90.sh
#!/bin/bash
# Script de monitoramento
LOG_FILE="/var/log/system_monitor.log"

while true; do
    # CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    
    # Memory usage
    MEM_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
    
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
    fi
    sleep 60
done
EOF

sudo chmod +x /home/ubuntu/scripts/monitorador_de_uso_acima_de_90.sh

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
ExecStart=/home/ubuntu/scripts/monitorador_de_uso_acima_de_90.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable system-monitor.service
sudo systemctl start system-monitor.service
sudo systemctl status system-monitor.service
