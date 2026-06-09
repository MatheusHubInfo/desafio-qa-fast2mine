*** Settings ***
Documentation        Keywords de interacao com a tela de equipamentos web.
Library              Browser
Resource             config/env_config.resource
Resource             pages/web_equipamentos.page

*** Keywords ***
Iniciar Sessao Web
    Configurar Ambiente De Execucao
    New Browser    browser=chromium    headless=False
    New Page       ${BASE_URL}

Encerrar Sessao Web
    Take Screenshot
    Close Browser

Dado que o usuário está na tela de equipamentos
    Wait For Elements State    ${WEB_INPUT_BUSCA}    visible    timeout=5s

Quando informar o nome de um equipamento válido
    Fill Text    ${WEB_INPUT_BUSCA}    ${EQUIPAMENTO}

Quando informar um equipamento inexistente
    Fill Text    ${WEB_INPUT_BUSCA}    Equipamento Inexistente

E clicar em "Buscar"
    Click    ${WEB_BTN_BUSCAR}

Então o sistema deve retornar o equipamento correspondente
    Get Text    ${WEB_TXT_NOME_EQUIP}    ==    ${EQUIPAMENTO}

E exibir suas informações corretamente
    Wait For Elements State    ${WEB_TABELA_REGISTROS}    visible    timeout=3s

Então o sistema deve exibir a mensagem "Equipamento não encontrado"
    Get Text    ${WEB_ALERTA_NAO_ENCONTRADO}    contains    Equipamento não encontrado

E não apresentar registros na consulta
    Get Element Count    ${WEB_TXT_NOME_EQUIP}    ==    0
