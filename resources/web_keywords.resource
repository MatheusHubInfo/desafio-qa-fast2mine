*** Settings ***
Documentation        Keywords Web reutilizáveis - Busca de produtos em e-commerce
Library              Browser
Library              Collections
Library              OperatingSystem
Library              DateTime
Library              String
Resource             config/env_config.resource
Resource             pages/web_equipamentos.resource

*** Variables ***
${SCREENSHOTS_DIR}        ${EXECDIR}/results/screenshots
${REPORTS_DIR}            ${EXECDIR}/results/reports

*** Keywords ***
#---
#  SETUP & TEARDOWN
#---

Iniciar Sessao Web
    [Documentation]    Abre navegador e carrega URL do ambiente selecionado
    Configurar Ambiente De Execucao
    Create Directory    ${SCREENSHOTS_DIR}
    
    TRY
        New Browser    browser=chromium    headless=True    args=["--disable-blink-features=AutomationControlled"]
        New Context    
        ...    viewport={'width': 1920, 'height': 1080}
        ...    userAgent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36
        ...    acceptDownloads=True
        ...    javaScriptEnabled=True
        ...    bypassCSP=True
        ...    extraHTTPHeaders={'Accept-Language': 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7'}
        New Page       ${BASE_URL}
        Wait For Load State    domcontentloaded    timeout=30s
        Sleep    3s
        
        # Tenta aceitar cookies se aparecer
        ${cookies_btn}=    Run Keyword And Return Status
        ...    Get Element    text="Aceitar cookies"
        IF    ${cookies_btn}
            Click    text="Aceitar cookies"
            Sleep    1s
        END
        
        # Tenta fechar modais/popups comuns
        ${fechar_modal}=    Run Keyword And Return Status
        ...    Click    css=button[aria-label*="Fechar"]    timeout=2s
        IF    ${fechar_modal}
            Sleep    0.5s
        END
        
        ${fechar_x}=    Run Keyword And Return Status
        ...    Click    css=.evg-modal-overlay    timeout=2s
        IF    ${fechar_x}
            Sleep    0.5s
        END
        
        Log    Navegador aberto    console=True
    EXCEPT    AS    ${error}
        Capturar Erro    Falha ao abrir navegador    ${error}
        Fail    Erro ao abrir navegador: ${error}
    END

Encerrar Sessao Web
    [Documentation]    Captura screenshot final e fecha navegador
    TRY
        ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
        Take Screenshot    ${SCREENSHOTS_DIR}/final_${timestamp}
        Log    Screenshot salvo    console=True
    EXCEPT
        Log    Erro ao capturar screenshot    console=True
    END
    Close Browser

#---
#  BUSCA DE PRODUTOS
#---

Acessar Campo De Busca
    [Documentation]    Localiza campo de busca (multi-seletor para diferentes sites)
    
    TRY
        Wait For Elements State    ${CAMPO_BUSCA_1}    visible    timeout=3s
        ${CAMPO_ENCONTRADO}=    Set Variable    ${CAMPO_BUSCA_1}
    EXCEPT
        TRY
            Wait For Elements State    ${CAMPO_BUSCA_2}    visible    timeout=3s
            ${CAMPO_ENCONTRADO}=    Set Variable    ${CAMPO_BUSCA_2}
        EXCEPT
            TRY
                Wait For Elements State    ${CAMPO_BUSCA_3}    visible    timeout=3s
                ${CAMPO_ENCONTRADO}=    Set Variable    ${CAMPO_BUSCA_3}
            EXCEPT
                Wait For Elements State    ${CAMPO_BUSCA_4}    visible    timeout=5s
                ${CAMPO_ENCONTRADO}=    Set Variable    ${CAMPO_BUSCA_4}
            END
        END
    END
    
    Set Suite Variable    ${CAMPO_BUSCA_ATIVO}    ${CAMPO_ENCONTRADO}
    Log    Campo de busca localizado    console=True
    RETURN    ${CAMPO_ENCONTRADO}

Digitar Termo De Busca
    [Arguments]    ${termo}
    [Documentation]    Digita termo com delay para simular digitação humana
    Click    ${CAMPO_BUSCA_ATIVO}
    Fill Text    ${CAMPO_BUSCA_ATIVO}    ${EMPTY}
    Type Text    ${CAMPO_BUSCA_ATIVO}    ${termo}    delay=50ms
    Sleep    0.3s
    Log    Digitado: ${termo}    console=True

Clicar No Botao Buscar
    [Documentation]    Clica botão de busca ou pressiona Enter
    TRY
        # Tenta BTN_BUSCA_1 (Amazon)
        ${btn1_visible}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${BTN_BUSCA_1}    visible    timeout=2s
        
        IF    ${btn1_visible}
            Click    ${BTN_BUSCA_1}
        ELSE
            # Tenta BTN_BUSCA_2 (Mercado Livre)
            ${btn2_visible}=    Run Keyword And Return Status
            ...    Wait For Elements State    ${BTN_BUSCA_2}    visible    timeout=2s
            
            IF    ${btn2_visible}
                Click    ${BTN_BUSCA_2}
            ELSE
                # Tenta BTN_BUSCA_3 (Casas Bahia)
                ${btn3_visible}=    Run Keyword And Return Status
                ...    Wait For Elements State    ${BTN_BUSCA_3}    visible    timeout=2s
                
                IF    ${btn3_visible}
                    Click    ${BTN_BUSCA_3}
                ELSE
                    # Fallback: Enter
                    Keyboard Key    press    Enter
                END
            END
        END
        
        Wait For Load State    domcontentloaded    timeout=30s
        Sleep    2s
        Log    Busca executada    console=True
    EXCEPT    AS    ${error}
        Capturar Erro    Falha ao buscar    ${error}
        Fail    Erro na busca: ${error}
    END

Validar Produto Nos Resultados
    [Arguments]    ${produto_esperado}
    [Documentation]    Valida se produto aparece nos resultados (valida título ou URL)
    
    TRY
        # Pega título e URL da página
        ${titulo_pagina}=    Get Title
        ${url_atual}=    Get Url
        Log    Titulo: ${titulo_pagina}    console=True
        Log    URL: ${url_atual}    console=True
        
        # Valida primeira palavra do produto
        ${palavras_produto}=    Split String    ${produto_esperado}
        ${primeira_palavra}=    Get From List    ${palavras_produto}    0
        
        # Tenta validar pelo título (Amazon, Samsung)
        ${titulo_contem}=    Run Keyword And Return Status
        ...    Should Contain    ${titulo_pagina}    ${primeira_palavra}    ignore_case=True
        
        # Se não achou no título, valida pela URL (Mercado Livre)
        IF    not ${titulo_contem}
            Should Contain    ${url_atual}    ${primeira_palavra}    ignore_case=True
            ...    msg=Produto "${primeira_palavra}" não encontrado no título "${titulo_pagina}" nem na URL "${url_atual}"
            Log    Produto encontrado na URL    console=True
        ELSE
            Log    Produto encontrado no titulo    console=True
        END
        
        Log    Validacao OK - Produto encontrado    console=True
        
    EXCEPT    AS    ${error}
        Capturar Erro    Falha validação produto    ${error}
        Fail    Produto não encontrado: ${error}
    END

Validar Mensagem Produto Nao Encontrado
    [Documentation]    Valida mensagem quando não há resultados
    TRY
        # Tenta Amazon
        ${msg_amazon}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${MSG_NAO_ENCONTRADO}    visible    timeout=5s
        
        IF    ${msg_amazon}
            ${mensagem}=    Get Text    ${MSG_NAO_ENCONTRADO}
            Log    Mensagem Amazon: ${mensagem}    console=True
        ELSE
            # Tenta Mercado Livre
            ${msg_ml}=    Run Keyword And Return Status
            ...    Get Text    ${MSG_NAO_ENCONTRADO_ML}
            
            IF    ${msg_ml}
                ${mensagem}=    Get Text    ${MSG_NAO_ENCONTRADO_ML}
                Log    Mensagem ML: ${mensagem}    console=True
                Should Contain    ${mensagem}    Não encontramos resultados
                ...    msg=Mensagem esperada não encontrada: ${mensagem}
            ELSE
                # Tenta Casas Bahia
                ${msg_cb}=    Run Keyword And Return Status
                ...    Get Text    ${MSG_NAO_ENCONTRADO_CB}
                
                IF    ${msg_cb}
                    ${mensagem}=    Get Text    ${MSG_NAO_ENCONTRADO_CB}
                    Log    Mensagem Casas Bahia: ${mensagem}    console=True
                    Should Contain    ${mensagem}    Não encontramos resultados para a sua busca
                    ...    msg=Mensagem esperada não encontrada: ${mensagem}
                ELSE
                    # Fallback: valida lista vazia
                    ${count}=    Get Element Count    ${TITULO_PRODUTO}
                    Should Be Equal As Numbers    ${count}    0
                    ...    msg=Esperava 0 resultados, encontrou ${count}
                    Log    Lista vazia    console=True
                END
            END
        END
        
        Log    Nenhum resultado - correto    console=True
    EXCEPT    AS    ${error}
        Capturar Erro    Falha validar "não encontrado"    ${error}
        Fail    Erro: ${error}
    END

#---
#  UTILITÁRIOS
#---

Capturar Erro
    [Arguments]    ${contexto}    ${mensagem_erro}
    [Documentation]    Captura screenshot e salva log de erro
    
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${nome_arquivo}=    Set Variable    erro_${timestamp}
    
    TRY
        Take Screenshot    ${SCREENSHOTS_DIR}/${nome_arquivo}.png
        Log    Screenshot: ${nome_arquivo}.png    console=True
    EXCEPT
        Log    Erro ao capturar screenshot    console=True
    END
    
    ${log_completo}=    Catenate    SEPARATOR=\n
    ...    ============================================
    ...    ERRO: ${contexto}
    ...    Timestamp: ${timestamp}
    ...    Ambiente: ${ENVIRONMENT}
    ...    URL: ${BASE_URL}
    ...    Produto: ${PRODUTO}
    ...    Mensagem: ${mensagem_erro}
    ...    ============================================
    
    TRY
        Create Directory    ${REPORTS_DIR}
        Append To File    ${REPORTS_DIR}/erros.log    ${log_completo}\n\n
        Log    Log de erro salvo    console=True
    EXCEPT
        Log    Erro ao salvar log    console=True
    END
