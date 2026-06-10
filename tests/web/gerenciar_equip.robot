*** Settings ***
Documentation        Testes Web - Pesquisa de produtos em e-commerce
Resource             ../../resources/web_keywords.resource

Test Setup           Iniciar Sessao Web
Test Teardown        Run Keywords
...                  Gerar Relatorio HTML    AND
...                  Encerrar Sessao Web

Suite Teardown       Log To Console    \n✨ Execução finalizada! Veja: results/

*** Test Cases ***
CT-001 - Buscar produto existente e validar título
    [Documentation]    Valida busca de produto e título nos resultados
    [Tags]    positivo    alta    smoke
    
    Acessar Campo De Busca
    Digitar Termo De Busca    ${PRODUTO}
    Clicar No Botao Buscar
    Validar Produto Nos Resultados    ${PRODUTO}

CT-002 - Buscar produto inexistente
    [Documentation]    Valida tratamento quando não encontra produto
    [Tags]    negativo    alta
    
    Acessar Campo De Busca
    Digitar Termo De Busca    ${PRODUTO_INVALIDO}
    Clicar No Botao Buscar
    Validar Mensagem Produto Nao Encontrado

CT-003 - Buscar produto com termo parcial
    [Documentation]    Valida busca com apenas parte do nome
    [Tags]    positivo    media
    
    # Extrai primeira palavra do produto (ex: "iPhone" de "iPhone 15")
    @{palavras}=    Split String    ${PRODUTO}
    ${primeira_palavra}=    Get From List    ${palavras}    0
    
    Acessar Campo De Busca
    Digitar Termo De Busca    ${primeira_palavra}
    Clicar No Botao Buscar
    Validar Produto Nos Resultados    ${primeira_palavra}
