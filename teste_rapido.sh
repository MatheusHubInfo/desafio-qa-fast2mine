#!/bin/bash
# Script de teste rápido - Roda apenas o CT-001 para validar que está tudo funcionando

# Carrega NVM e ativa Node.js 20 (compatível com Playwright)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use 20 > /dev/null 2>&1

clear
echo "==============================================================="
echo "           TESTE RÁPIDO - Validação do Setup"
echo "==============================================================="
echo ""
echo "Rodando CT-001 (Busca de produto) no Mercado Livre..."
echo ""

python3 -m robot --variable ENVIRONMENT:MERCADOLIVRE \
      --test "CT-001*" \
      --outputdir results/teste_rapido \
      --loglevel INFO \
      tests/web/

if [ $? -eq 0 ]; then
    echo ""
    echo "SUCESSO! O ambiente está configurado corretamente."
    echo "Veja o relatório em: results/teste_rapido/report.html"
else
    echo ""
    echo "Teste falhou. Verifique o relatório para mais detalhes."
    echo "results/teste_rapido/report.html"
fi

echo ""
