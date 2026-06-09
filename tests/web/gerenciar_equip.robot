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

CT-006 - Buscar equipamento inexistente
    [Tags]    negativo    alta
    Dado que o usuário está na tela de equipamentos
    Quando informar um equipamento inexistente
    E clicar em "Buscar"
    Então o sistema deve exibir a mensagem "Equipamento não encontrado"
    E não apresentar registros na consulta
