*** Settings ***
Documentation        Keywords Mobile - Automação com Appium
Library              AppiumLibrary
Resource             config/env_config.resource
Resource             pages/mobile_equip_page.resource

*** Keywords ***
# ═══════════════════════════════════════════════════════════════
#  SETUP & TEARDOWN
# ═══════════════════════════════════════════════════════════════

Iniciar Sessao Mobile
    [Documentation]    Abre app mobile com capabilities configuradas
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

Encerrar Sessao Mobile
    [Documentation]    Captura screenshot e fecha app
    Capture Page Screenshot
    Close Application

# ═══════════════════════════════════════════════════════════════
#  BUSCA
# ═══════════════════════════════════════════════════════════════

Dado que o usuário abriu o app na tela de busca
    Wait Until Element Is Visible    ${MOBILE_INPUT_BUSCA}    timeout=10s
    Wait Until Element Is Visible    ${MOBILE_BTN_BUSCAR}     timeout=5s

Quando buscar o equipamento cadastrado do ambiente
    Input Text     ${MOBILE_INPUT_BUSCA}    ${EQUIPAMENTO}
    Sleep          0.5s
    Click Element  ${MOBILE_BTN_BUSCAR}
    Sleep          1s

Quando buscar por um termo invalido no app
    Input Text     ${MOBILE_INPUT_BUSCA}    Equipamento Inexistente
    Sleep          0.5s
    Click Element  ${MOBILE_BTN_BUSCAR}
    Sleep          1s

Então o app deve listar o registro correto
    Wait Until Element Is Visible    ${MOBILE_LISTA_RESULTADOS}    timeout=10s
    Wait Until Element Is Visible    ${MOBILE_TXT_NOME_EQUIP}      timeout=5s
    Element Text Should Be           ${MOBILE_TXT_NOME_EQUIP}      ${EQUIPAMENTO}

Então o app deve mostrar o aviso de lista vazia
    Wait Until Element Is Visible    ${MOBILE_ALERTA_VAZIO}    timeout=10s
    Element Text Should Be           ${MOBILE_ALERTA_VAZIO}    Não encontrado

# ═══════════════════════════════════════════════════════════════
#  EDIÇÃO
# ═══════════════════════════════════════════════════════════════

Dado que o usuário localizou um equipamento no app
    Wait Until Element Is Visible    ${MOBILE_TXT_NOME_EQUIP}    timeout=10s

Quando tocar em "Editar" no app
    Wait Until Element Is Visible    ${MOBILE_BTN_EDITAR}         timeout=10s
    Click Element                    ${MOBILE_BTN_EDITAR}
    Wait Until Element Is Visible    ${MOBILE_INPUT_NOME_EDIT}    timeout=10s

E alterar o nome do equipamento no app
    Clear Text       ${MOBILE_INPUT_NOME_EDIT}
    Input Text       ${MOBILE_INPUT_NOME_EDIT}    ${EQUIPAMENTO}_Editado
    Sleep            0.5s

E salvar a alteração no app
    Wait Until Element Is Visible    ${MOBILE_BTN_SALVAR}    timeout=10s
    Click Element                    ${MOBILE_BTN_SALVAR}
    Sleep            2s

Então o app deve atualizar o nome com sucesso
    Wait Until Element Is Visible    ${MOBILE_TXT_NOME_EQUIP}    timeout=10s
    ${texto}=    Get Text            ${MOBILE_TXT_NOME_EQUIP}
    Should Contain                   ${texto}    Editado

E exibir mensagem de confirmação no app
    Wait Until Element Is Visible    ${MOBILE_MSG_SUCESSO}    timeout=10s

# ═══════════════════════════════════════════════════════════════
#  STATUS
# ═══════════════════════════════════════════════════════════════

Dado que existe um equipamento com status "Ativo" no app
    Wait Until Element Is Visible    ${MOBILE_TXT_STATUS_EQUIP}    timeout=10s
    Element Text Should Be           ${MOBILE_TXT_STATUS_EQUIP}    Ativo

Quando o usuário alterar o status para "Inativo" no app
    Wait Until Element Is Visible    ${MOBILE_BTN_EDITAR}              timeout=10s
    Click Element                    ${MOBILE_BTN_EDITAR}
    Wait Until Element Is Visible    ${MOBILE_SELECT_STATUS_EDIT}      timeout=10s
    Click Element                    ${MOBILE_SELECT_STATUS_EDIT}
    Click Element                    xpath=//android.widget.TextView[@text="Inativo"]
    Sleep    0.5s

Então o app deve persistir a alteração do status
    Sleep    2s

E exibir o status "Inativo" no app
    Wait Until Element Is Visible    ${MOBILE_TXT_STATUS_EQUIP}    timeout=10s
    Element Text Should Be           ${MOBILE_TXT_STATUS_EQUIP}    Inativo

Dado que existe um equipamento cadastrado com status "Ativo" no app
    Wait Until Element Is Visible    ${MOBILE_TXT_NOME_EQUIP}      timeout=10s
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
    Element Text Should Be           ${MOBILE_TXT_STATUS_EQUIP}    Ativo

# ═══════════════════════════════════════════════════════════════
#  FILTROS
# ═══════════════════════════════════════════════════════════════

Dado que o usuário realizou uma busca no app
    Input Text       ${MOBILE_INPUT_BUSCA}    ${EQUIPAMENTO}
    Sleep            0.5s
    Click Element    ${MOBILE_BTN_BUSCAR}
    Sleep            2s

Quando tocar na opção de limpar filtro no app
    Wait Until Element Is Visible    ${MOBILE_BTN_LIMPAR}    timeout=10s
    Click Element                    ${MOBILE_BTN_LIMPAR}
    Sleep            2s

Então o app deve remover os critérios da pesquisa
    ${texto_input}=    Get Text    ${MOBILE_INPUT_BUSCA}
    Should Be Empty    ${texto_input}

E exibir novamente todos os equipamentos no app
    Wait Until Element Is Visible    ${MOBILE_LISTA_RESULTADOS}    timeout=10s
    ${count}=    Get Matching Xpath Count    ${MOBILE_TXT_NOME_EQUIP}
    Should Be True    ${count} > ${0}

# ═══════════════════════════════════════════════════════════════
#  VALIDAÇÃO
# ═══════════════════════════════════════════════════════════════

Dado que o usuário está editando um equipamento no app
    Wait Until Element Is Visible    ${MOBILE_BTN_EDITAR}         timeout=10s
    Click Element                    ${MOBILE_BTN_EDITAR}
    Wait Until Element Is Visible    ${MOBILE_INPUT_NOME_EDIT}    timeout=10s

Quando remover o valor do campo nome no app
    Clear Text    ${MOBILE_INPUT_NOME_EDIT}
    Sleep         0.5s

E tentar salvar a alteração no app
    Click Element    ${MOBILE_BTN_SALVAR}
    Sleep            2s

Então o app deve impedir a gravação
    Wait Until Element Is Visible    ${MOBILE_INPUT_NOME_EDIT}    timeout=10s

E exibir mensagem informando que o campo é obrigatório no app
    Wait Until Element Is Visible    ${MOBILE_MSG_VALIDACAO}    timeout=10s
    ${texto_msg}=    Get Text        ${MOBILE_MSG_VALIDACAO}
    Should Contain                   ${texto_msg}    obrigatório
