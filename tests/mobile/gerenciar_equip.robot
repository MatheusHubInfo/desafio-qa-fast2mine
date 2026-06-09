*** Settings ***
Documentation    Testes automatizados para gerenciamento de equipamentos (Mobile)
...              Implementa os casos de teste descritos em documentacao_testes/casos_de_teste.md
...              Adaptados para a plataforma mobile (Android/iOS)

Library          AppiumLibrary
Resource         ../../resources/config/env_config.resource

Suite Setup      Iniciar Sessão Mobile    platform=android
Suite Teardown   Encerrar Sessão Mobile

*** Variables ***
# Massa de Dados - Equipamentos Mobile
${EQUIP_NOME_VALIDO}          Trator de Esteira D8
${EQUIP_TIPO}                 Trator
${EQUIP_STATUS_OPERACIONAL}   Operacional
${EQUIP_LOCALIZACAO}          Mina Sul - Setor B

# Locators Mobile (carregados do XML)
${LOC_BTN_NOVO}               id=com.fast2mine:id/btn_novo_equipamento
${LOC_INPUT_NOME}             id=com.fast2mine:id/input_nome
${LOC_INPUT_TIPO}             id=com.fast2mine:id/spinner_tipo
${LOC_INPUT_STATUS}           id=com.fast2mine:id/spinner_status
${LOC_INPUT_LOCALIZACAO}      id=com.fast2mine:id/input_localizacao
${LOC_BTN_SALVAR}             id=com.fast2mine:id/btn_salvar

*** Keywords ***
# Keywords Mobile Específicas
Clicar No Botão Novo Equipamento Mobile
    Wait Until Element Is Visible    ${LOC_BTN_NOVO}    timeout=10s
    Click Element    ${LOC_BTN_NOVO}

Preencher Formulário Mobile
    [Arguments]    ${nome}    ${tipo}    ${status}    ${localizacao}
    
    Wait Until Element Is Visible    ${LOC_INPUT_NOME}    timeout=10s
    Input Text    ${LOC_INPUT_NOME}    ${nome}
    
    Click Element    ${LOC_INPUT_TIPO}
    Click Text    ${tipo}
    
    Click Element    ${LOC_INPUT_STATUS}
    Click Text    ${status}
    
    Input Text    ${LOC_INPUT_LOCALIZACAO}    ${localizacao}

Salvar Equipamento Mobile
    Click Element    ${LOC_BTN_SALVAR}
    Wait Until Page Contains    sucesso    timeout=10s

Validar Equipamento Na Lista Mobile
    [Arguments]    ${nome}
    
    ${locator}=    Set Variable    xpath=//android.widget.TextView[@text='${nome}']
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Element Should Be Visible    ${locator}

*** Test Cases ***
CT001 - Cadastrar Equipamento Mobile Com Dados Válidos
    [Documentation]    Valida o cadastro bem-sucedido de um novo equipamento via app mobile
    [Tags]    mobile    smoke    cadastro    positivo
    
    Clicar No Botão Novo Equipamento Mobile
    Preencher Formulário Mobile
    ...    nome=${EQUIP_NOME_VALIDO}
    ...    tipo=${EQUIP_TIPO}
    ...    status=${EQUIP_STATUS_OPERACIONAL}
    ...    localizacao=${EQUIP_LOCALIZACAO}
    Salvar Equipamento Mobile
    
    Validar Equipamento Na Lista Mobile    ${EQUIP_NOME_VALIDO}

CT002 - Validar Campo Obrigatório No Mobile
    [Documentation]    Tenta cadastrar equipamento sem preencher campos obrigatórios no mobile
    [Tags]    mobile    validacao    negativo
    
    Clicar No Botão Novo Equipamento Mobile
    Click Element    ${LOC_BTN_SALVAR}
    
    # Valida mensagem de erro
    Wait Until Page Contains    obrigatório    timeout=5s

CT003 - Validar Responsividade Mobile
    [Documentation]    Valida que os elementos são exibidos corretamente em diferentes orientações
    [Tags]    mobile    ui    positivo
    
    # Orientação Portrait
    Set Orientation    PORTRAIT
    Element Should Be Visible    ${LOC_BTN_NOVO}
    
    # Orientação Landscape
    Set Orientation    LANDSCAPE
    Element Should Be Visible    ${LOC_BTN_NOVO}
    
    # Volta para Portrait
    Set Orientation    PORTRAIT
