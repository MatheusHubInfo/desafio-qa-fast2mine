*** Settings ***
Documentation    Keywords compartilhadas - Regras de negócio da aplicação
Library          Browser
Library          AppiumLibrary
Resource         config/env_config.resource
Resource         pages/web_equipamentos.page

*** Keywords ***
# ==================== SETUP E TEARDOWN ====================
Iniciar Sessão Web
    [Documentation]    Inicia o navegador e acessa a aplicação web
    New Browser    chromium    headless=False
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page    ${BASE_URL}
    Wait For Load State    networkidle

Encerrar Sessão Web
    [Documentation]    Fecha o navegador e limpa a sessão
    Close Browser

Iniciar Sessão Mobile
    [Documentation]    Inicia a sessão do Appium para testes mobile
    [Arguments]    ${platform}=android
    IF    '${platform}' == 'android'
        Open Application    http://localhost:4723/wd/hub
        ...    platformName=Android
        ...    deviceName=emulator-5554
        ...    appPackage=com.fast2mine
        ...    appActivity=.MainActivity
    ELSE IF    '${platform}' == 'ios'
        Open Application    http://localhost:4723/wd/hub
        ...    platformName=iOS
        ...    deviceName=iPhone 14
        ...    bundleId=com.fast2mine.app
    END

Encerrar Sessão Mobile
    [Documentation]    Fecha o aplicativo e encerra a sessão do Appium
    Close Application

# ==================== KEYWORDS DE NEGÓCIO ====================
Cadastrar Novo Equipamento
    [Documentation]    Realiza o cadastro completo de um novo equipamento
    [Arguments]    ${nome}    ${tipo}    ${status}    ${localizacao}
    
    Clicar No Botão Novo Equipamento
    Preencher Campo Nome    ${nome}
    Preencher Campo Tipo    ${tipo}
    Preencher Campo Status    ${status}
    Preencher Campo Localização    ${localizacao}
    Clicar No Botão Salvar
    Mensagem De Sucesso Deve Ser Exibida

Validar Equipamento Cadastrado
    [Documentation]    Valida que o equipamento foi cadastrado com sucesso
    [Arguments]    ${nome}
    
    Equipamento Deve Estar Visível Na Listagem    ${nome}

Editar Equipamento Existente
    [Documentation]    Edita um equipamento já cadastrado
    [Arguments]    ${nome_atual}    ${novo_nome}    ${novo_tipo}    ${novo_status}    ${nova_localizacao}
    
    ${locator_editar}=    Set Variable    ${LOC_BTN_EDITAR.replace('{nome}', '${nome_atual}')}
    Click    ${locator_editar}
    
    Preencher Campo Nome    ${novo_nome}
    Preencher Campo Tipo    ${novo_tipo}
    Preencher Campo Status    ${novo_status}
    Preencher Campo Localização    ${nova_localizacao}
    Clicar No Botão Salvar
    Mensagem De Sucesso Deve Ser Exibida

Excluir Equipamento
    [Documentation]    Remove um equipamento do sistema
    [Arguments]    ${nome}
    
    ${locator_excluir}=    Set Variable    ${LOC_BTN_EXCLUIR.replace('{nome}', '${nome}')}
    Click    ${locator_excluir}
    
    # Confirmar exclusão no modal
    Wait For Elements State    ${LOC_MODAL_CONFIRMACAO}    visible    timeout=5s
    Click    css=.modal-confirmacao button.confirmar
    Mensagem De Sucesso Deve Ser Exibida

Realizar Login
    [Documentation]    Efetua login na aplicação (se necessário)
    [Arguments]    ${email}=${USER_EMAIL}    ${senha}=${USER_PASSWORD}
    
    Fill Text    css=input[name="email"]    ${email}
    Fill Text    css=input[name="password"]    ${senha}
    Click    css=button[type="submit"]
    Wait For Load State    networkidle

# ==================== KEYWORDS DE VALIDAÇÃO ====================
Sistema Deve Exibir Mensagem
    [Documentation]    Valida que uma mensagem específica é exibida
    [Arguments]    ${mensagem}    ${tipo}=sucesso
    
    IF    '${tipo}' == 'sucesso'
        Mensagem De Sucesso Deve Ser Exibida
    ELSE IF    '${tipo}' == 'erro'
        Mensagem De Erro Deve Ser Exibida
    END
    
    ${texto_msg}=    Get Text    css=.toast-${tipo}, .alert-${tipo}
    Should Contain    ${texto_msg}    ${mensagem}
