*** Settings ***
Documentation        Gerenciamento dinâmico de ambientes e massas de dados (Fast2Mine).
Library              Collections

*** Variables ***
# Ambiente padrão executado caso não seja passado nenhum parâmetro via console
${ENVIRONMENT}       QA1

# Dicionário de URLs mapeado conforme o documento da prova
&{URLS}
...                  QA1=https://gal.sistema.com
...                  QA2=https://gal2.sistema.com
...                  QA3=https://gal3.sistema.com

# Dicionário de Massas de Dados (Equipamentos válidos) para cada servidor
&{EQUIPAMENTOS}
...                  QA1=Caminhão 01
...                  QA2=Caminhão_02
...                  QA3=Caminhão_03

*** Keywords ***
Configurar Ambiente De Execucao
    [Documentation]    Carrega de forma dinâmica a URL e a Massa de Dados baseada na variável global.
    ${URL_ATUAL}       Get From Dictionary    ${URLS}            ${ENVIRONMENT}
    ${MASSA_ATUAL}     Get From Dictionary    ${EQUIPAMENTOS}    ${ENVIRONMENT}
    
    # Define as variáveis como globais para que as Keywords Web/Mobile consigam acessá-las
    Set Global Variable    ${BASE_URL}        ${URL_ATUAL}
    Set Global Variable    ${EQUIPAMENTO}     ${MASSA_ATUAL}
    
    Log To Console     \n[INFO] Executando no Ambiente: ${ENVIRONMENT} | URL: ${BASE_URL} | Massa: ${EQUIPAMENTO}
