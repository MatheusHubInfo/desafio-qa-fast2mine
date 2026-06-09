*** Settings ***
Documentation        Cenarios de teste automatizados para gestao de equipamentos (Mobile).
Resource             ../../resources/shared_keywords.resource

Test Setup           Iniciar Sessao Mobile
Test Teardown        Encerrar Sessao Mobile

*** Test Cases ***
CT-001 - Buscar equipamento existente no aplicativo
    [Tags]    positivo    alta
    Dado que o usuário abriu o app na tela de busca
    Quando buscar o equipamento cadastrado do ambiente
    Então o app deve listar o registro correto

CT-006 - Buscar equipamento inexistente no aplicativo
    [Tags]    negativo    alta
    Dado que o usuário abriu o app na tela de busca
    Quando buscar por um termo invalido no app
    Então o app deve mostrar o aviso de lista vazia
