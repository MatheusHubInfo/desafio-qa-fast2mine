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
    [Documentation]    Inicia o navegador e aguarda o carregamento completo da página.
    Configurar Ambiente De Execucao
    New Browser    browser=chromium    headless=False
    New Page       ${BASE_URL}
    Wait For Load State    networkidle    timeout=10s

Encerrar Sessao Web
    Take Screenshot
    Close Browser

Dado que o usuário está na tela de equipamentos
    Wait For Elements State    ${WEB_INPUT_BUSCA}    visible    timeout=10s
    Wait For Elements State    ${WEB_BTN_BUSCAR}     enabled    timeout=5s

Quando informar o nome de um equipamento válido
    Fill Text    ${WEB_INPUT_BUSCA}    ${EQUIPAMENTO}
    Sleep        0.3s    # Aguarda processamento do input

Quando informar um equipamento inexistente
    Fill Text    ${WEB_INPUT_BUSCA}    Equipamento Inexistente
    Sleep        0.3s    # Aguarda processamento do input

E clicar em "Buscar"
    Click    ${WEB_BTN_BUSCAR}
    Wait For Load State    networkidle    timeout=5s

Então o sistema deve retornar o equipamento correspondente
    Wait For Elements State    ${WEB_TXT_NOME_EQUIP}    visible    timeout=5s
    Get Text    ${WEB_TXT_NOME_EQUIP}    ==    ${EQUIPAMENTO}

E exibir suas informações corretamente
    Wait For Elements State    ${WEB_TABELA_REGISTROS}    visible    timeout=5s

Então o sistema deve exibir a mensagem "Equipamento não encontrado"
    Wait For Elements State    ${WEB_ALERTA_NAO_ENCONTRADO}    visible    timeout=5s
    Get Text    ${WEB_ALERTA_NAO_ENCONTRADO}    contains    Equipamento não encontrado

E não apresentar registros na consulta
    Wait For Load State    networkidle    timeout=3s
    Get Element Count    ${WEB_TXT_NOME_EQUIP}    ==    0

# --- KEYWORDS PARA CT-002 (EDITAR NOME) ---
Dado que o usuário localizou um equipamento cadastrado
    Wait For Elements State    ${WEB_TXT_NOME_EQUIP}    visible    timeout=10s

Quando clicar em "Editar"
    Wait For Elements State    ${WEB_BTN_EDITAR}    enabled    timeout=5s
    Click    ${WEB_BTN_EDITAR}
    Wait For Elements State    ${WEB_INPUT_NOME_EDIT}    visible    timeout=5s

E alterar o nome do equipamento
    Fill Text    ${WEB_INPUT_NOME_EDIT}    ${EQUIPAMENTO}_Editado
    Sleep        0.3s    # Aguarda processamento do input

E salvar a alteração
    Wait For Elements State    ${WEB_BTN_SALVAR}    enabled    timeout=5s
    Click    ${WEB_BTN_SALVAR}
    Wait For Load State    networkidle    timeout=5s

Então o sistema deve atualizar o nome com sucesso
    Wait For Elements State    ${WEB_TXT_NOME_EQUIP}    visible    timeout=5s
    Get Text    ${WEB_TXT_NOME_EQUIP}    contains    Editado

E exibir mensagem de confirmação
    # Aguarda toast/mensagem de sucesso aparecer
    Sleep    1s

# --- KEYWORDS PARA CT-003 (ALTERAR STATUS) ---
Dado que existe um equipamento com status "Ativo"
    Wait For Elements State    ${WEB_TXT_STATUS_EQUIP}    visible    timeout=10s
    Get Text    ${WEB_TXT_STATUS_EQUIP}    ==    Ativo

Quando o usuário alterar o status para "Inativo"
    Wait For Elements State    ${WEB_BTN_EDITAR}    enabled    timeout=5s
    Click    ${WEB_BTN_EDITAR}
    Wait For Elements State    ${WEB_SELECT_STATUS_EDIT}    visible    timeout=5s
    Select Options By    ${WEB_SELECT_STATUS_EDIT}    value    Inativo
    Sleep    0.3s    # Aguarda processamento da seleção

Então o sistema deve persistir a alteração
    Wait For Load State    networkidle    timeout=5s

E exibir o status "Inativo"
    Wait For Elements State    ${WEB_TXT_STATUS_EQUIP}    visible    timeout=5s
    Get Text    ${WEB_TXT_STATUS_EQUIP}    ==    Inativo

# --- KEYWORDS PARA CT-004 (CONSULTAR STATUS) ---
Dado que existe um equipamento cadastrado com status "Ativo"
    Wait For Elements State    ${WEB_TXT_NOME_EQUIP}    visible    timeout=10s
    Wait For Elements State    ${WEB_TXT_STATUS_EQUIP}   visible    timeout=5s

Quando o usuário realizar a busca pelo equipamento
    Fill Text    ${WEB_INPUT_BUSCA}    ${EQUIPAMENTO}
    Sleep        0.3s
    Click        ${WEB_BTN_BUSCAR}
    Wait For Load State    networkidle    timeout=5s

Então o sistema deve exibir o equipamento encontrado
    Wait For Elements State    ${WEB_TXT_NOME_EQUIP}    visible    timeout=5s

E apresentar o status "Ativo"
    Wait For Elements State    ${WEB_TXT_STATUS_EQUIP}    visible    timeout=5s
    Get Text    ${WEB_TXT_STATUS_EQUIP}    ==    Ativo

# --- KEYWORDS PARA CT-005 (LIMPAR FILTRO) ---
Dado que o usuário realizou uma busca por um equipamento
    Fill Text    ${WEB_INPUT_BUSCA}    ${EQUIPAMENTO}
    Sleep        0.3s
    Click        ${WEB_BTN_BUSCAR}
    Wait For Load State    networkidle    timeout=5s

Quando clicar na opção de limpar filtro
    Wait For Elements State    ${WEB_BTN_LIMPAR}    enabled    timeout=5s
    Click    ${WEB_BTN_LIMPAR}
    Wait For Load State    networkidle    timeout=5s

Então o sistema deve remover os critérios da pesquisa
    Get Property    ${WEB_INPUT_BUSCA}    value    ==    ${EMPTY}

E exibir novamente todos os equipamentos disponíveis
    Wait For Elements State    ${WEB_TABELA_REGISTROS}    visible    timeout=5s
    ${count}=    Get Element Count    ${WEB_TXT_NOME_EQUIP}
    Should Be True    ${count} > 0    msg=Nenhum equipamento listado após limpar filtro

# --- KEYWORDS PARA CT-007 (VALIDAÇÃO CAMPO OBRIGATÓRIO) ---
Dado que o usuário está editando um equipamento
    Wait For Elements State    ${WEB_BTN_EDITAR}    enabled    timeout=5s
    Click    ${WEB_BTN_EDITAR}
    Wait For Elements State    ${WEB_INPUT_NOME_EDIT}    visible    timeout=5s

Quando remover o valor do campo nome
    Fill Text    ${WEB_INPUT_NOME_EDIT}    ${EMPTY}
    Sleep        0.3s

E tentar salvar a alteração
    Click    ${WEB_BTN_SALVAR}
    Sleep    1s    # Aguarda validação processar

Então o sistema deve impedir a gravação
    # Permanece na tela de edição
    Wait For Elements State    ${WEB_INPUT_NOME_EDIT}    visible    timeout=5s

E exibir mensagem informando que o campo é obrigatório
    Wait For Elements State    ${WEB_MSG_VALIDACAO}    visible    timeout=5s
    Get Text    ${WEB_MSG_VALIDACAO}    contains    obrigatório

# --- NOVAS KEYWORDS MOBILE (APPIUM) ---
Iniciar Sessao Mobile
    [Documentation]    Inicia sessão no app mobile com capabilities completas.
    Configurar Ambiente De Execucao
    Open Application    http://localhost:4723/wd/hub
    ...                 platformName=Android
    ...                 platformVersion=11.0
    ...                 deviceName=Android Emulator
    ...                 appPackage=com.fast2mine.sistema
    ...                 appActivity=.MainActivity
    ...                 automationName=UiAutomator2
    ...                 autoGrantPermissions=true
    ...                 noReset=true
    ...                 newCommandTimeout=300
    ...                 uiautomator2ServerInstallTimeout=60000
    # Capabilities opcionais para dispositivos físicos:
    # ...                 udid=dispositivo_id_aqui
    # ...                 systemPort=8200

Encerrar Sessao Mobile
    Capture Page Screenshot
    Close Application

Dado que o usuário abriu o app na tela de busca
    Wait Until Element Is Visible    ${MOBILE_INPUT_BUSCA}    timeout=10s
    Wait Until Element Is Visible    ${MOBILE_BTN_BUSCAR}     timeout=5s

Quando buscar o equipamento cadastrado do ambiente
    Input Text     ${MOBILE_INPUT_BUSCA}    ${EQUIPAMENTO}
    Sleep          0.5s    # Aguarda processamento do input
    Click Element  ${MOBILE_BTN_BUSCAR}
    Sleep          1s      # Aguarda processamento da busca

Quando buscar por um termo invalido no app
    Input Text     ${MOBILE_INPUT_BUSCA}    Equipamento Inexistente
    Sleep          0.5s    # Aguarda processamento do input
    Click Element  ${MOBILE_BTN_BUSCAR}
    Sleep          1s      # Aguarda processamento da busca

Então o app deve listar o registro correto
    Wait Until Element Is Visible    ${MOBILE_LISTA_RESULTADOS}    timeout=10s
    Wait Until Element Is Visible    ${MOBILE_TXT_NOME_EQUIP}      timeout=5s
    Element Text Should Be           ${MOBILE_TXT_NOME_EQUIP}      ${EQUIPAMENTO}

Então o app deve mostrar o aviso de lista vazia
    Wait Until Element Is Visible    ${MOBILE_ALERTA_VAZIO}    timeout=10s
    Element Text Should Be           ${MOBILE_ALERTA_VAZIO}    Não encontrado

# --- KEYWORDS MOBILE PARA CT-002 (EDITAR NOME) ---
Dado que o usuário localizou um equipamento no app
    Wait Until Element Is Visible    ${MOBILE_TXT_NOME_EQUIP}    timeout=10s

Quando tocar em "Editar" no app
    Wait Until Element Is Visible    ${MOBILE_BTN_EDITAR}    timeout=10s
    Click Element    ${MOBILE_BTN_EDITAR}
    Wait Until Element Is Visible    ${MOBILE_INPUT_NOME_EDIT}    timeout=10s

E alterar o nome do equipamento no app
    Clear Text       ${MOBILE_INPUT_NOME_EDIT}
    Input Text       ${MOBILE_INPUT_NOME_EDIT}    ${EQUIPAMENTO}_Editado
    Sleep            0.5s    # Aguarda processamento do input

E salvar a alteração no app
    Wait Until Element Is Visible    ${MOBILE_BTN_SALVAR}    timeout=10s
    Click Element    ${MOBILE_BTN_SALVAR}
    Sleep            2s    # Aguarda salvamento processar

Então o app deve atualizar o nome com sucesso
    Wait Until Element Is Visible    ${MOBILE_TXT_NOME_EQUIP}    timeout=10s
    ${texto}=    Get Text    ${MOBILE_TXT_NOME_EQUIP}
    Should Contain    ${texto}    Editado

E exibir mensagem de confirmação no app
    Wait Until Element Is Visible    ${MOBILE_MSG_SUCESSO}    timeout=10s

# --- KEYWORDS MOBILE PARA CT-003 (ALTERAR STATUS) ---
Dado que existe um equipamento com status "Ativo" no app
    Wait Until Element Is Visible    ${MOBILE_TXT_STATUS_EQUIP}    timeout=10s
    Element Text Should Be    ${MOBILE_TXT_STATUS_EQUIP}    Ativo

Quando o usuário alterar o status para "Inativo" no app
    Wait Until Element Is Visible    ${MOBILE_BTN_EDITAR}    timeout=10s
    Click Element    ${MOBILE_BTN_EDITAR}
    Wait Until Element Is Visible    ${MOBILE_SELECT_STATUS_EDIT}    timeout=10s
    Click Element    ${MOBILE_SELECT_STATUS_EDIT}
    # Seleciona opção "Inativo" (depende da implementação do picker)
    Click Element    xpath=//android.widget.TextView[@text="Inativo"]
    Sleep    0.5s

Então o app deve persistir a alteração do status
    Sleep    2s    # Aguarda processamento

E exibir o status "Inativo" no app
    Wait Until Element Is Visible    ${MOBILE_TXT_STATUS_EQUIP}    timeout=10s
    Element Text Should Be    ${MOBILE_TXT_STATUS_EQUIP}    Inativo

# --- KEYWORDS MOBILE PARA CT-004 (CONSULTAR STATUS) ---
Dado que existe um equipamento cadastrado com status "Ativo" no app
    Wait Until Element Is Visible    ${MOBILE_TXT_NOME_EQUIP}    timeout=10s
    Wait Until Element Is Visible    ${MOBILE_TXT_STATUS_EQUIP}    timeout=5s

Quando o usuário realizar a busca pelo equipamento no app
    Input Text       ${MOBILE_INPUT_BUSCA}    ${EQUIPAMENTO}
    Sleep            0.5s
    Click Element    ${MOBILE_BTN_BUSCAR}
    Sleep            2s

Então o app deve exibir o equipamento encontrado
    Wait Until Element Is Visible    ${MOBILE_TXT_NOME_EQUIP}    timeout=10s

E apresentar o status "Ativo" no app
    Wait Until Element Is Visible    ${MOBILE_TXT_STATUS_EQUIP}    timeout=10s
    Element Text Should Be    ${MOBILE_TXT_STATUS_EQUIP}    Ativo

# --- KEYWORDS MOBILE PARA CT-005 (LIMPAR FILTRO) ---
Dado que o usuário realizou uma busca no app
    Input Text       ${MOBILE_INPUT_BUSCA}    ${EQUIPAMENTO}
    Sleep            0.5s
    Click Element    ${MOBILE_BTN_BUSCAR}
    Sleep            2s

Quando tocar na opção de limpar filtro no app
    Wait Until Element Is Visible    ${MOBILE_BTN_LIMPAR}    timeout=10s
    Click Element    ${MOBILE_BTN_LIMPAR}
    Sleep            2s

Então o app deve remover os critérios da pesquisa
    ${texto_input}=    Get Text    ${MOBILE_INPUT_BUSCA}
    Should Be Empty    ${texto_input}

E exibir novamente todos os equipamentos no app
    Wait Until Element Is Visible    ${MOBILE_LISTA_RESULTADOS}    timeout=10s
    ${count}=    Get Matching Xpath Count    ${MOBILE_TXT_NOME_EQUIP}
    Should Be True    ${count} > ${0}    msg=Nenhum equipamento listado

# --- KEYWORDS MOBILE PARA CT-007 (VALIDAÇÃO CAMPO OBRIGATÓRIO) ---
Dado que o usuário está editando um equipamento no app
    Wait Until Element Is Visible    ${MOBILE_BTN_EDITAR}    timeout=10s
    Click Element    ${MOBILE_BTN_EDITAR}
    Wait Until Element Is Visible    ${MOBILE_INPUT_NOME_EDIT}    timeout=10s

Quando remover o valor do campo nome no app
    Clear Text    ${MOBILE_INPUT_NOME_EDIT}
    Sleep         0.5s

E tentar salvar a alteração no app
    Click Element    ${MOBILE_BTN_SALVAR}
    Sleep            2s

Então o app deve impedir a gravação
    # Permanece na tela de edição
    Wait Until Element Is Visible    ${MOBILE_INPUT_NOME_EDIT}    timeout=10s

E exibir mensagem informando que o campo é obrigatório no app
    Wait Until Element Is Visible    ${MOBILE_MSG_VALIDACAO}    timeout=10s
    ${texto_msg}=    Get Text    ${MOBILE_MSG_VALIDACAO}
    Should Contain    ${texto_msg}    obrigatório
