#!/bin/bash

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

