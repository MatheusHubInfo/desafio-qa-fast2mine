#!/bin/bash
# Script de teste rápido - Roda apenas o CT-001 para validar que está tudo funcionando

clear
echo "════════════════════════════════════════════════════════════"
echo "           🧪 TESTE RÁPIDO - Validação do Setup"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Rodando CT-001 (Busca de produto) no Mercado Livre..."
echo ""

robot --variable ENVIRONMENT:MERCADOLIVRE \
      --test "CT-001*" \
      --outputdir results/teste_rapido \
      --loglevel INFO \
      tests/web/

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCESSO! O ambiente está configurado corretamente."
    echo "📄 Veja o relatório em: results/teste_rapido/report.html"
else
    echo ""
    echo "⚠️  Teste falhou. Verifique o relatório para mais detalhes."
    echo "📄 results/teste_rapido/report.html"
fi

echo ""
