*** Settings ***
Documentation        Keywords de interacao com a tela de equipamentos web e mobile.
Library              Browser
Library              AppiumLibrary
Resource             config/env_config.resource
Resource             pages/web_equipamentos.page
Resource             pages/mobile_equip_page.resource

*** Keywords ***
# --- KEYWORDS WEB JÁ EXISTENTES ---
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

# --- NOVAS KEYWORDS MOBILE (APPIUM) ---
Iniciar Sessao Mobile
    Configurar Ambiente De Execucao
    Open Application    http://localhost:4723/wd/hub
    ...                 platformName=Android
    ...                 deviceName=Emulator
    ...                 appPackage=com.fast2mine.sistema
    ...                 appActivity=.MainActivity
    ...                 automationName=UiAutomator2

Encerrar Sessao Mobile
    Capture Page Screenshot
    Close Application

Dado que o usuário abriu o app na tela de busca
    Wait Until Element Is Visible    ${MOBILE_INPUT_BUSCA}    timeout=5s

Quando buscar o equipamento cadastrado do ambiente
    Input Text     ${MOBILE_INPUT_BUSCA}    ${EQUIPAMENTO}
    Click Element  ${MOBILE_BTN_BUSCAR}

Quando buscar por um termo invalido no app
    Input Text     ${MOBILE_INPUT_BUSCA}    Equipamento Inexistente
    Click Element  ${MOBILE_BTN_BUSCAR}

Então o app deve listar o registro correto
    Wait Until Element Is Visible    ${MOBILE_LISTA_RESULTADOS}    timeout=5s
    Element Text Should Be           ${MOBILE_TXT_NOME_EQUIP}      ${EQUIPAMENTO}

Então o app deve mostrar o aviso de lista vazia
    Element Text Should Be           ${MOBILE_ALERTA_VAZIO}        Não encontrado
