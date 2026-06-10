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
# ═══════════════════════════════════════════════════════════════
#  SETUP & TEARDOWN
# ═══════════════════════════════════════════════════════════════

Iniciar Sessao Web
    [Documentation]    Abre navegador e carrega URL do ambiente selecionado
    Configurar Ambiente De Execucao
    Create Directory    ${SCREENSHOTS_DIR}
    
    TRY
        New Browser    browser=chromium    headless=True
        New Page       ${BASE_URL}
        Wait For Load State    networkidle    timeout=15s
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

# ═══════════════════════════════════════════════════════════════
#  BUSCA DE PRODUTOS
# ═══════════════════════════════════════════════════════════════

Acessar Campo De Busca
    [Documentation]    Localiza campo de busca (multi-seletor para diferentes sites)
    
    TRY
        Wait For Elements State    ${CAMPO_BUSCA_1}    visible    timeout=3s
        ${CAMPO_ENCONTRADO}=    Set Variable    ${CAMPO_BUSCA_1}
    EXCEPT
        TRY
            Wait For Elements State    ${CAMPO_BUSCA_3}    visible    timeout=3s
            ${CAMPO_ENCONTRADO}=    Set Variable    ${CAMPO_BUSCA_3}
        EXCEPT
            Wait For Elements State    ${CAMPO_BUSCA_4}    visible    timeout=5s
            ${CAMPO_ENCONTRADO}=    Set Variable    ${CAMPO_BUSCA_4}
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
        ${btn_visible}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${BTN_BUSCA_1}    visible    timeout=2s
        
        IF    ${btn_visible}
            Click    ${BTN_BUSCA_1}
        ELSE
            Keyboard Key    press    Enter
        END
        
        Wait For Load State    networkidle    timeout=15s
        Sleep    1s
        Log    Busca executada    console=True
    EXCEPT    AS    ${error}
        Capturar Erro    Falha ao buscar    ${error}
        Fail    Erro na busca: ${error}
    END

Validar Produto Nos Resultados
    [Arguments]    ${produto_esperado}
    [Documentation]    Valida se produto aparece nos resultados
    
    TRY
        ${lista_visivel}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${LISTA_PRODUTOS}    visible    timeout=5s
        
        IF    ${lista_visivel}
            Log    Lista carregada    console=True
        ELSE
            Wait For Elements State    ${LISTA_PRODUTOS_ML}    visible    timeout=5s
        END
        
        ${titulo}=    Get Text    ${TITULO_PRODUTO}
        Log    Titulo encontrado: ${titulo}    console=True
        
        # Valida primeira palavra do produto
        ${palavras_produto}=    Split String    ${produto_esperado}
        ${primeira_palavra}=    Get From List    ${palavras_produto}    0
        
        Should Contain    ${titulo}    ${primeira_palavra}    ignore_case=True
        ...    msg=Produto "${primeira_palavra}" não encontrado
        
        Log    Validacao OK    console=True
        
    EXCEPT    AS    ${error}
        Capturar Erro    Falha validação produto    ${error}
        Fail    Produto não encontrado: ${error}
    END

Validar Mensagem Produto Nao Encontrado
    [Documentation]    Valida mensagem quando não há resultados
    TRY
        ${msg_encontrada}=    Run Keyword And Return Status
        ...    Wait For Elements State    ${MSG_NAO_ENCONTRADO}    visible    timeout=5s
        
        IF    ${msg_encontrada}
            ${mensagem}=    Get Text    ${MSG_NAO_ENCONTRADO}
            Log    Mensagem: ${mensagem}    console=True
        ELSE
            ${count}=    Get Element Count    ${TITULO_PRODUTO}
            Should Be Equal As Numbers    ${count}    0
            ...    msg=Esperava 0 resultados, encontrou ${count}
            Log    Lista vazia    console=True
        END
        
        Log    Nenhum resultado - correto    console=True
    EXCEPT    AS    ${error}
        Capturar Erro    Falha validar "não encontrado"    ${error}
        Fail    Erro: ${error}
    END

# ═══════════════════════════════════════════════════════════════
#  UTILITÁRIOS
# ═══════════════════════════════════════════════════════════════

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

Gerar Relatorio HTML
    [Documentation]    Gera relatório HTML customizado
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    
    ${html_content}=    Catenate    SEPARATOR=\n
    ...    <!DOCTYPE html>
    ...    <html lang="pt-BR">
    ...    <head>
    ...        <meta charset="UTF-8">
    ...        <title>Relatório - ${ENVIRONMENT}</title>
    ...        <style>
    ...            body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; }
    ...            .container { max-width: 1000px; margin: 0 auto; background: white; border-radius: 15px; padding: 30px; box-shadow: 0 10px 40px rgba(0,0,0,0.3); }
    ...            h1 { color: #667eea; text-align: center; }
    ...            .info { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-top: 20px; }
    ...            .card { background: #f8f9fa; padding: 15px; border-radius: 8px; }
    ...            .card h3 { color: #667eea; margin-bottom: 8px; }
    ...        </style>
    ...    </head>
    ...    <body>
    ...        <div class="container">
    ...            <h1>Relatório de Testes</h1>
    ...            <div class="info">
    ...                <div class="card"><h3>Ambiente</h3><p>${ENVIRONMENT}</p></div>
    ...                <div class="card"><h3>URL</h3><p>${BASE_URL}</p></div>
    ...                <div class="card"><h3>Produto</h3><p>${PRODUTO}</p></div>
    ...                <div class="card"><h3>Data/Hora</h3><p>${timestamp}</p></div>
    ...            </div>
    ...            <p style="text-align: center; margin-top: 30px; color: #666;">Matheus Alves</p>
    ...        </div>
    ...    </body>
    ...    </html>
    
    TRY
        Create Directory    ${REPORTS_DIR}
        Create File    ${REPORTS_DIR}/relatorio_customizado.html    ${html_content}
        Log    Relatorio HTML gerado    console=True
    EXCEPT    AS    ${error}
        Log    Erro ao gerar relatorio: ${error}    console=True
    END
