*** Settings ***
Documentation    Configuração dinâmica de URLs e ambientes

*** Variables ***
# Configuração de Ambiente
${ENV}                  dev
${BASE_URL_DEV}         https://app-dev.fast2mine.com
${BASE_URL_HML}         https://app-hml.fast2mine.com
${BASE_URL_PROD}        https://app.fast2mine.com

# URL Dinâmica baseada no ambiente
${BASE_URL}             ${BASE_URL_${ENV.upper()}}

# Configurações de Timeout
${TIMEOUT_DEFAULT}      10s
${TIMEOUT_LONG}         30s

# Credenciais (substituir por variáveis de ambiente em produção)
${USER_EMAIL}           usuario@teste.com
${USER_PASSWORD}        senha123

*** Keywords ***
Configurar Ambiente
    [Arguments]    ${ambiente}=dev
    Set Global Variable    ${ENV}    ${ambiente}
    Set Global Variable    ${BASE_URL}    ${BASE_URL_${ambiente.upper()}}
    Log    Ambiente configurado: ${ambiente} - URL: ${BASE_URL}
