#!/bin/bash
# Script para rodar testes com Node.js 20 (compatível com Playwright)

# Carrega NVM e ativa Node.js 20
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use 20 > /dev/null 2>&1

# Define ambiente (padrão: AMAZON)
AMBIENTE="${1:-AMAZON}"

echo "Executando testes no ambiente: $AMBIENTE"
echo "----------------------------------------"

# Remove resultados anteriores
rm -rf results/teste_${AMBIENTE,,}

# Executa testes
python3 -m robot \
    --variable ENVIRONMENT:$AMBIENTE \
    --outputdir results/teste_${AMBIENTE,,} \
    --loglevel INFO \
    tests/web/

# Mostra status
if [ $? -eq 0 ]; then
    echo ""
    echo "Testes PASSARAM!"
    echo "Relatório: results/teste_${AMBIENTE,,}/report.html"
else
    echo ""
    echo "Testes FALHARAM"
    echo "Veja detalhes em: results/teste_${AMBIENTE,,}/log.html"
fi

# Abre relatório
xdg-open "results/teste_${AMBIENTE,,}/report.html" 2>/dev/null &
