*** Settings ***
Documentation        Testes Mobile - Gestão de equipamentos com Appium
Resource             ../../resources/mobile_keywords.resource

Test Setup           Iniciar Sessao Mobile
Test Teardown        Encerrar Sessao Mobile

*** Test Cases ***
CT-001 - Buscar equipamento existente no aplicativo
    [Tags]    positivo    alta
    Dado que o usuário abriu o app na tela de busca
    Quando buscar o equipamento cadastrado do ambiente
    Então o app deve listar o registro correto

CT-002 - Editar nome do equipamento no aplicativo
    [Tags]    positivo    alta
    Dado que o usuário abriu o app na tela de busca
    Quando buscar o equipamento cadastrado do ambiente
    Dado que o usuário localizou um equipamento no app
    Quando tocar em "Editar" no app
    E alterar o nome do equipamento no app
    E salvar a alteração no app
    Então o app deve atualizar o nome com sucesso
    E exibir mensagem de confirmação no app

CT-003 - Alterar status do equipamento no aplicativo
    [Tags]    positivo    alta
    Dado que o usuário abriu o app na tela de busca
    Quando buscar o equipamento cadastrado do ambiente
    Dado que existe um equipamento com status "Ativo" no app
    Quando tocar em "Editar" no app
    Quando o usuário alterar o status para "Inativo" no app
    E salvar a alteração no app
    Então o app deve persistir a alteração do status
    E exibir o status "Inativo" no app

CT-004 - Consultar status do equipamento no aplicativo
    [Tags]    positivo    media
    Dado que existe um equipamento cadastrado com status "Ativo" no app
    Quando o usuário realizar a busca pelo equipamento no app
    Então o app deve exibir o equipamento encontrado
    E apresentar o status "Ativo" no app

CT-005 - Limpar filtro de pesquisa no aplicativo
    [Tags]    positivo    media
    Dado que o usuário abriu o app na tela de busca
    Dado que o usuário realizou uma busca no app
    Quando tocar na opção de limpar filtro no app
    Então o app deve remover os critérios da pesquisa
    E exibir novamente todos os equipamentos no app

CT-006 - Buscar equipamento inexistente no aplicativo
    [Tags]    negativo    alta
    Dado que o usuário abriu o app na tela de busca
    Quando buscar por um termo invalido no app
    Então o app deve mostrar o aviso de lista vazia

CT-007 - Salvar equipamento sem preencher nome no aplicativo
    [Tags]    negativo    alta
    Dado que o usuário abriu o app na tela de busca
    Quando buscar o equipamento cadastrado do ambiente
    Dado que o usuário está editando um equipamento no app
    Quando remover o valor do campo nome no app
    E tentar salvar a alteração no app
    Então o app deve impedir a gravação
    E exibir mensagem informando que o campo é obrigatório no app
