*** Settings ***
Documentation        Cenarios de teste automatizados para gestao de equipamentos (Web).
Resource             ../../resources/shared_keywords.resource

Test Setup           Iniciar Sessao Web
Test Teardown        Encerrar Sessao Web

*** Test Cases ***
CT-001 - Buscar equipamento existente
    [Tags]    positivo    alta
    Dado que o usuário está na tela de equipamentos
    Quando informar o nome de um equipamento válido
    E clicar em "Buscar"
    Então o sistema deve retornar o equipamento correspondente
    E exibir suas informações corretamente

CT-002 - Editar nome do equipamento
    [Tags]    positivo    alta
    Dado que o usuário está na tela de equipamentos
    Quando informar o nome de um equipamento válido
    E clicar em "Buscar"
    Dado que o usuário localizou um equipamento cadastrado
    Quando clicar em "Editar"
    E alterar o nome do equipamento
    E salvar a alteração
    Então o sistema deve atualizar o nome com sucesso
    E exibir mensagem de confirmação

CT-003 - Alterar status do equipamento
    [Tags]    positivo    alta
    Dado que o usuário está na tela de equipamentos
    Quando informar o nome de um equipamento válido
    E clicar em "Buscar"
    Dado que existe um equipamento com status "Ativo"
    Quando o usuário alterar o status para "Inativo"
    E salvar a alteração
    Então o sistema deve persistir a alteração
    E exibir o status "Inativo"

CT-004 - Consultar status do equipamento
    [Tags]    positivo    media
    Dado que existe um equipamento cadastrado com status "Ativo"
    Quando o usuário realizar a busca pelo equipamento
    Então o sistema deve exibir o equipamento encontrado
    E apresentar o status "Ativo"

CT-005 - Limpar filtro de pesquisa
    [Tags]    positivo    media
    Dado que o usuário está na tela de equipamentos
    Dado que o usuário realizou uma busca por um equipamento
    Quando clicar na opção de limpar filtro
    Então o sistema deve remover os critérios da pesquisa
    E exibir novamente todos os equipamentos disponíveis

CT-006 - Buscar equipamento inexistente
    [Tags]    negativo    alta
    Dado que o usuário está na tela de equipamentos
    Quando informar um equipamento inexistente
    E clicar em "Buscar"
    Então o sistema deve exibir a mensagem "Equipamento não encontrado"
    E não apresentar registros na consulta

CT-007 - Salvar equipamento sem preencher nome
    [Tags]    negativo    alta
    Dado que o usuário está na tela de equipamentos
    Quando informar o nome de um equipamento válido
    E clicar em "Buscar"
    Dado que o usuário está editando um equipamento
    Quando remover o valor do campo nome
    E tentar salvar a alteração
    Então o sistema deve impedir a gravação
    E exibir mensagem informando que o campo é obrigatório
