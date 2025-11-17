# 🖥️ Sistema de Monitoramento Linux

Um sistema de monitoramento leve e eficiente para servidores Ubuntu/Linux que detecta automaticamente problemas de performance usando apenas comandos nativos do sistema.

## 📋 Características

- **Zero dependências externas** - usa apenas comandos nativos do Linux
- **Baixo overhead** - não consome recursos significativos do sistema
- **Alertas automáticos** quando CPU ou memória ultrapassam 95%
- **Logs estruturados** com informações detalhadas de troubleshooting
- **Daemon resiliente** com restart automático via systemd
- **Fallback inteligente** se houver problemas de permissão

## 🚀 Como Funciona

O script monitora continuamente:
- **Load Average de 5 minutos** (métrica nativa do kernel Linux)
- **Uso de Memória RAM** 
- **Uso de Swap**
- **Processos com maior consumo** de CPU e memória

### Comandos Nativos Utilizados
- `uptime` → Load average e tempo de funcionamento
- `free` → Estatísticas de memória e swap
- `nproc` → Número de processadores
- `ps aux --sort` → Lista de processos ordenados
- `df -h` → Uso de disco

## 📦 Instalação

### Pré-requisitos
- Ubuntu/Debian Linux
- Usuário com privilégios sudo
- Pacote `bc` (instalado automaticamente)

### Instalação Rápida
```bash
# Clone ou baixe o script
curl -O https://raw.githubusercontent.com/seu-repo/monitor-sistema.sh

# Execute o script de instalação
chmod +x monitor-sistema.sh
sudo ./monitor-sistema.sh
```

### O que a Instalação Faz
1. Cria diretório `/home/ubuntu/scripts/`
2. Instala o script de monitoramento
3. Configura serviço systemd
4. Instala dependência `bc`
5. Cria arquivo de log com permissões corretas
6. Inicia o serviço automaticamente

## ⚙️ Configuração

### Ajustar Thresholds
Edite o script para alterar os limites de alerta:
```bash
sudo nano /home/ubuntu/scripts/monitor_sistema_simples.sh

# Altere esta linha para mudar o threshold:
if [ $(echo "$CPU_PERCENT >= 95" | bc -l) -eq 1 ] || [ $(echo "$MEM_USAGE >= 95" | bc -l) -eq 1 ]; then
```

### Alterar Intervalo de Verificação
Por padrão verifica a cada 5 minutos. Para alterar:
```bash
# No final do script, altere:
sleep 300  # 300 segundos = 5 minutos
```

## 📊 Monitoramento e Logs

### Visualizar Logs em Tempo Real
```bash
# Logs do systemd (saída do script)
sudo journalctl -u system-monitor.service -f

# Arquivo de log de alertas
sudo tail -f /var/log/system_monitor.log

# Verificar status do serviço
sudo systemctl status system-monitor.service
```

### Exemplo de Log de Alerta
```
Wed Jul 16 14:30:25 UTC 2025: HIGH USAGE ALERT - Load: 3.85 (CPU: 96.25%), MEM: 97.50%, SWAP: 45.20%
=== SYSTEM INFO ===
14:30:25 up 2 days, 14:30, 3 users, load average: 2.15, 3.85, 2.90
=== TOP CPU PROCESSES ===
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
ubuntu    1234 45.2  8.1 1234567 123456 ?     R    14:25   2:15 heavy_process
```

## 🔧 Gerenciamento do Serviço

### Comandos Úteis
```bash
# Parar o monitoramento
sudo systemctl stop system-monitor.service

# Iniciar o monitoramento
sudo systemctl start system-monitor.service

# Reiniciar o serviço
sudo systemctl restart system-monitor.service

# Desabilitar inicialização automática
sudo systemctl disable system-monitor.service

# Habilitar inicialização automática
sudo systemctl enable system-monitor.service

# Ver logs detalhados
sudo systemctl status system-monitor.service -l
```

### Desinstalar
```bash
# Parar e desabilitar o serviço
sudo systemctl stop system-monitor.service
sudo systemctl disable system-monitor.service

# Remover arquivos
sudo rm /etc/systemd/system/system-monitor.service
sudo rm -rf /home/ubuntu/scripts/
sudo rm /var/log/system_monitor.log

# Recarregar systemd
sudo systemctl daemon-reload
```

## 🔍 Troubleshooting

### Script Não Está Salvando Logs
```bash
# Verificar permissões do arquivo de log
ls -la /var/log/system_monitor.log

# Testar escrita manual
echo "teste" | sudo tee -a /var/log/system_monitor.log

# Verificar se o serviço está rodando
sudo systemctl status system-monitor.service
```

### CPU Sempre em 100%
O script usa **Load Average**, não CPU instantâneo. Load Average > número de CPUs indica sobrecarga:
```bash
# Verificar número de CPUs
nproc

# Load de 4.0 em sistema com 4 CPUs = 100% de utilização
```

### Alertas Falsos
Se receber muitos alertas falsos, ajuste os thresholds no script de 95% para um valor mais alto.

## 📈 Interpretação das Métricas

### Load Average
- **Load 1.0** em sistema com 1 CPU = 100% de utilização
- **Load 2.0** em sistema com 4 CPUs = 50% de utilização
- **Load > número de CPUs** = sistema sobrecarregado

### Uso de Memória
- Porcentagem baseada em memória total vs usada
- **Não inclui cache/buffers** (apenas memória realmente utilizada)

### Swap Usage
- **0%** = ideal (sem uso de swap)
- **>50%** = possível problema de memória

## 🤝 Contribuição

### Melhorias Sugeridas
- [ ] Alertas via email/webhook
- [ ] Dashboard web simples
- [ ] Métricas de disco I/O
- [ ] Integração com ferramentas de monitoramento
- [ ] Alertas configuráveis por arquivo

### Como Contribuir
1. Fork o repositório
2. Crie uma branch para sua feature
3. Teste em ambiente de desenvolvimento
4. Submeta um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## ⚠️ Aviso

Este script é fornecido "como está" sem garantias. Teste em ambiente de desenvolvimento antes de usar em produção.
