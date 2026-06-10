#!/bin/bash
# ╔════════════════════════════════════════════════════════════════════╗
# ║     Script de Execução Paralela - Roda testes em 3 ambientes      ║
# ║     simultaneamente para economizar tempo!                          ║
# ╚════════════════════════════════════════════════════════════════════╝

# Carrega NVM e ativa Node.js 20 (compatível com Playwright)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use 20 > /dev/null 2>&1

# Cores para output bonito no terminal
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
AZUL='\033[0;34m'
VERMELHO='\033[0;31m'
NC='\033[0m' # Sem cor

# Banner bonitinho
echo -e "${AZUL}"
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                                                                    ║"
echo "║           🚀 EXECUÇÃO PARALELA DE TESTES                          ║"
echo "║           Rodando em 3 ambientes simultaneamente!                 ║"
echo "║                                                                    ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Cria pasta para resultados se não existir
mkdir -p results/{amazon,mercadolivre,samsung}

echo -e "${AMARELO}⏱️  Iniciando execução...${NC}\n"

# Roda os 3 ambientes em paralelo usando & (background)
# O '&' no final de cada comando faz ele rodar em background (paralelo)
echo -e "${VERDE}▶️  Iniciando testes: Amazon${NC}"
robot --variable ENVIRONMENT:AMAZON \
      --outputdir results/amazon \
      --name "Testes Amazon" \
      --loglevel INFO \
      tests/web/ &
PID_AMAZON=$!  # Salva o Process ID para monitorar depois

echo -e "${VERDE}▶️  Iniciando testes: Mercado Livre${NC}"
robot --variable ENVIRONMENT:MERCADOLIVRE \
      --outputdir results/mercadolivre \
      --name "Testes Mercado Livre" \
      --loglevel INFO \
      tests/web/ &
PID_ML=$!

echo -e "${VERDE}▶️  Iniciando testes: Samsung${NC}"
robot --variable ENVIRONMENT:SAMSUNG \
      --outputdir results/samsung \
      --name "Testes Samsung" \
      --loglevel INFO \
      tests/web/ &
PID_SAMSUNG=$!

echo -e "\n${AMARELO}⏳ Aguardando conclusão dos testes...${NC}\n"

# Aguarda todos os processos terminarem
# O 'wait' espera todos os processos em background finalizarem
wait $PID_AMAZON
STATUS_AMAZON=$?

wait $PID_ML
STATUS_ML=$?

wait $PID_SAMSUNG
STATUS_SAMSUNG=$?

# Exibe resumo dos resultados
echo -e "\n${AZUL}╔════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${AZUL}║                    📊 RESUMO DA EXECUÇÃO                           ║${NC}"
echo -e "${AZUL}╚════════════════════════════════════════════════════════════════════╝${NC}\n"

# Função para exibir status bonitinho
exibir_status() {
    local ambiente=$1
    local status=$2
    
    if [ $status -eq 0 ]; then
        echo -e "  ✅ ${VERDE}$ambiente: PASSOU${NC}"
    else
        echo -e "  ❌ ${VERMELHO}$ambiente: FALHOU (código $status)${NC}"
    fi
}

exibir_status "Amazon        " $STATUS_AMAZON
exibir_status "Mercado Livre " $STATUS_ML
exibir_status "Samsung       " $STATUS_SAMSUNG

echo ""
echo -e "${AZUL}📂 Relatórios salvos em:${NC}"
echo -e "   📄 results/amazon/report.html"
echo -e "   📄 results/mercadolivre/report.html"
echo -e "   📄 results/samsung/report.html"

echo ""
echo -e "${AMARELO}💡 Dica: Abra os arquivos report.html no navegador para ver os resultados detalhados!${NC}"
echo ""

# Retorna código de erro se algum teste falhou
if [ $STATUS_AMAZON -ne 0 ] || [ $STATUS_ML -ne 0 ] || [ $STATUS_SAMSUNG -ne 0 ]; then
    echo -e "${VERMELHO}⚠️  Alguns testes falharam. Verifique os relatórios acima.${NC}\n"
    exit 1
else
    echo -e "${VERDE}🎉 Todos os testes passaram com sucesso!${NC}\n"
    exit 0
fi
