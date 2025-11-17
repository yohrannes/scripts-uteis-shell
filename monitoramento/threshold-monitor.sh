#!/bin/bash

sudo mkdir -p /home/ubuntu/scripts

cat <<EOF > /home/ubuntu/scripts/monitor_sistema_simples.sh
#!/bin/bash
LOG_FILE="/var/log/system_monitor.log"

while true; do
    # Obtém load average de 5 minutos (segundo valor do uptime)
    LOAD_5MIN=\$(uptime | awk -F'load average:' '{print \$2}' | awk -F',' '{print \$2}' | xargs)
    
    # Obtém número de CPUs para calcular porcentagem
    NUM_CPUS=\$(nproc)
    
    # Calcula porcentagem de CPU baseada no load average
    CPU_PERCENT=\$(echo "scale=2; (\$LOAD_5MIN / \$NUM_CPUS) * 100" | bc -l)
    
    # Obtém uso de memória atual
    MEM_USAGE=\$(free | awk '/^Mem:/ {printf "%.2f", \$3/\$2 * 100}')
    
    # Obtém uso de swap
    SWAP_USAGE=\$(free | awk '/^Swap:/ {if(\$2>0) printf "%.2f", \$3/\$2 * 100; else print "0"}')
    
    echo "\$(date): Load 5min: \${LOAD_5MIN} (CPU: \${CPU_PERCENT}%), MEM: \${MEM_USAGE}%, SWAP: \${SWAP_USAGE}%"
    
    # Verifica se CPU ou memória estão acima do limite
    if [ \$(echo "\$CPU_PERCENT >= 95" | bc -l) -eq 1 ] || [ \$(echo "\$MEM_USAGE >= 95" | bc -l) -eq 1 ]; then
        {
            echo "\$(date): HIGH USAGE ALERT - Load: \${LOAD_5MIN} (CPU: \${CPU_PERCENT}%), MEM: \${MEM_USAGE}%, SWAP: \${SWAP_USAGE}%"
            echo "=== SYSTEM INFO ==="
            uptime
            echo "=== TOP CPU PROCESSES ==="
            ps aux --sort=-%cpu | head -6
            echo "=== TOP MEMORY PROCESSES ==="
            ps aux --sort=-%mem | head -6
            echo "=== DISK USAGE ==="
            df -h | grep -E '^/dev/'
            echo "---"
        } >> "\$LOG_FILE"
    fi
    
    # Aguarda 5 minutos
    sleep 300
done
EOF

sudo chmod +x /home/ubuntu/scripts/monitor_sistema_simples.sh

# Cria o serviço systemd
sudo tee /etc/systemd/system/system-monitor.service > /dev/null <<EOF
[Unit]
Description=System Monitor Script
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=30
User=root
ExecStart=/home/ubuntu/scripts/monitor_sistema_simples.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Instala bc se não estiver instalado
sudo apt-get update && sudo apt-get install -y bc

# Recarrega e inicia o serviço
sudo systemctl daemon-reload
sudo systemctl enable system-monitor.service
sudo systemctl start system-monitor.service

# Verifica o status
sudo systemctl status system-monitor.service

# Comandos úteis para monitoramento:
echo "=== COMANDOS ÚTEIS ==="
echo "Ver logs: sudo journalctl -u system-monitor.service -f"
echo "Ver arquivo de log: sudo tail -f /var/log/system_monitor.log"
echo "Parar serviço: sudo systemctl stop system-monitor.service"
echo "Reiniciar serviço: sudo systemctl restart system-monitor.service"
