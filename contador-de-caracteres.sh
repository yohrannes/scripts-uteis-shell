#!/bin/bash

# Contador de Caracteres Portátil - Ubuntu
# Não instala nada, apenas executa
# Uso: bash contador.sh

# Verifica se xclip está disponível
if ! command -v xclip &> /dev/null; then
    echo "❌ xclip não encontrado. Instale com: sudo apt install xclip"
    echo "Ou use a versão alternativa sem xclip abaixo..."
    exit 1
fi

echo "🔍 Contador de Caracteres Ativo"
echo "Selecione qualquer texto para ver a contagem"
echo "Pressione Ctrl+C para sair"
echo "----------------------------------------"

prev_selection=""

# Loop principal
while true; do
    # Captura seleção atual (primary clipboard - texto selecionado)
    current_selection=$(xclip -o -selection primary 2>/dev/null)
    
    # Se houve mudança na seleção e não está vazia
    if [[ "$current_selection" != "$prev_selection" ]] && [[ -n "$current_selection" ]]; then
        
        # Contagens
        char_count=${#current_selection}
        char_no_spaces=$(echo "$current_selection" | tr -d ' \t\n\r' | wc -c)
        word_count=$(echo "$current_selection" | wc -w)
        line_count=$(echo "$current_selection" | wc -l)
        
        # Limpa tela e mostra resultado
        clear
        echo "🔍 Contador de Caracteres Ativo"
        echo "Selecione qualquer texto para ver a contagem"
        echo "Pressione Ctrl+C para sair"
        echo "----------------------------------------"
        echo ""
        echo "📊 TEXTO SELECIONADO:"
        echo "────────────────────"
        echo "Caracteres (total): $char_count"
        echo "Caracteres (sem espaços): $char_no_spaces"
        echo "Palavras: $word_count"
        echo "Linhas: $line_count"
        echo ""
        echo "📝 Prévia do texto:"
        echo "$(echo "$current_selection" | head -c 100)$([ ${#current_selection} -gt 100 ] && echo "...")"
        echo ""
        
        prev_selection="$current_selection"
    fi
    
    # Aguarda 0.3 segundos
    sleep 0.3
done
