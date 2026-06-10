*** Settings ***
Documentation        Sistema inteligente de gerenciamento de ambientes e massas de dados.
...                  Permite trocar entre diferentes sites sem alterar o código dos testes.
Library              Collections

*** Variables ***
# Ambiente padrão caso o usuário não especifique (pode trocar rodando: robot -v ENVIRONMENT:AMAZON tests/web/)
${ENVIRONMENT}       MERCADOLIVRE

# Mapeamento de URLs reais - agora os testes vão funcionar de verdade! 🎯
&{URLS}
...                  AMAZON=https://www.amazon.com.br
...                  MERCADOLIVRE=https://www.mercadolivre.com.br
...                  SAMSUNG=https://www.samsung.com/br

# Massa de dados: produtos para pesquisar em cada ambiente
# Escolhi produtos populares que provavelmente sempre terão resultados
&{PRODUTOS}
...                  AMAZON=iPhone 15
...                  MERCADOLIVRE=Notebook Dell
...                  SAMSUNG=Galaxy S24

*** Keywords ***
Configurar Ambiente De Execucao
    [Documentation]    Mágica acontece aqui! Carrega URL e produto baseado no ambiente escolhido.
    ...                Isso permite rodar o mesmo teste em sites diferentes sem mudar nada no código.
    
    # Busca as configurações do ambiente selecionado
    ${URL_ATUAL}       Get From Dictionary    ${URLS}         ${ENVIRONMENT}
    ${PRODUTO_ATUAL}   Get From Dictionary    ${PRODUTOS}     ${ENVIRONMENT}
    
    # Torna as variáveis acessíveis para todos os testes e keywords
    Set Global Variable    ${BASE_URL}     ${URL_ATUAL}
    Set Global Variable    ${PRODUTO}      ${PRODUTO_ATUAL}
    
    # Exibe info no console para o usuário saber onde está rodando
    Log To Console     \n╔══════════════════════════════════════════════════════════╗
    Log To Console     ║  🌍 Ambiente: ${ENVIRONMENT}
    Log To Console     ║  🔗 URL: ${BASE_URL}
    Log To Console     ║  📦 Produto: ${PRODUTO}
    Log To Console     ╚══════════════════════════════════════════════════════════╝\n
