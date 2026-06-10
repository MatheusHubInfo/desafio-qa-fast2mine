*** Settings ***
Documentation        Sistema inteligente de gerenciamento de ambientes e massas de dados.
...                  Permite trocar entre diferentes sites sem alterar o código dos testes.
Library              Collections

*** Variables ***
# Ambiente padrão caso o usuário não especifique (pode trocar rodando: robot -v ENVIRONMENT:AMAZON tests/web/)
${ENVIRONMENT}       MERCADOLIVRE

# Mapeamento de URLs reais
&{URLS}
...                  AMAZON=https://www.amazon.com.br
...                  MERCADOLIVRE=https://www.mercadolivre.com.br
...                  CASASBAHIA=https://www.casasbahia.com.br/

# Massa de dados: produtos para pesquisar em cada ambiente
&{PRODUTOS}
...                  AMAZON=Apple iphone 16 plus rosa
...                  MERCADOLIVRE=nitendo switch lite azul
...                  CASASBAHIA=tv samsung 50

# Produtos inexistentes para testes negativos
&{PRODUTOS_INVALIDOS}
...                  AMAZON=xyzabc123produto999inexistente
...                  MERCADOLIVRE=xyzabc123produto999inexistente
...                  CASASBAHIA=xyzabc123produto999inexistente

*** Keywords ***
Configurar Ambiente De Execucao
    [Documentation]    Carrega URL e produto baseado no ambiente escolhido
    
    # Busca as configurações do ambiente selecionado
    ${URL_ATUAL}       Get From Dictionary    ${URLS}         ${ENVIRONMENT}
    ${PRODUTO_ATUAL}   Get From Dictionary    ${PRODUTOS}     ${ENVIRONMENT}
    ${PRODUTO_INVALIDO_ATUAL}   Get From Dictionary    ${PRODUTOS_INVALIDOS}    ${ENVIRONMENT}
    
    # Torna as variáveis acessíveis para todos os testes e keywords
    Set Global Variable    ${BASE_URL}     ${URL_ATUAL}
    Set Global Variable    ${PRODUTO}      ${PRODUTO_ATUAL}
    Set Global Variable    ${PRODUTO_INVALIDO}    ${PRODUTO_INVALIDO_ATUAL}
    
    # Exibe info no console
    Log    Ambiente: ${ENVIRONMENT}    console=True
    Log    URL: ${BASE_URL}    console=True
    Log    Produto: ${PRODUTO}    console=True
