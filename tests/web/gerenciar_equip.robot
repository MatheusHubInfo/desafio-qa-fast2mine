*** Settings ***
Documentation    Testes automatizados para gerenciamento de equipamentos (Web)
...              Implementa os casos de teste descritos em documentacao_testes/casos_de_teste.md

Resource         ../../resources/shared_keywords.resource
Resource         ../../resources/config/env_config.resource

Suite Setup      Iniciar Sessão Web
Suite Teardown   Encerrar Sessão Web

*** Variables ***
# Massa de Dados - Equipamentos
${EQUIP_NOME_VALIDO}          Escavadeira Hidráulica CAT 320
${EQUIP_TIPO}                 Escavadeira
${EQUIP_STATUS_OPERACIONAL}   Operacional
${EQUIP_STATUS_MANUTENCAO}    Em Manutenção
${EQUIP_LOCALIZACAO}          Mina Norte - Setor A

# Dados para Testes Negativos
${NOME_MUITO_LONGO}           ${'A' * 256}
${NOME_VAZIO}                 ${EMPTY}
${NOME_CARACTERES_ESPECIAIS}  <script>alert('XSS')</script>

*** Test Cases ***
CT001 - Cadastrar Equipamento Com Dados Válidos
    [Documentation]    Valida o cadastro bem-sucedido de um novo equipamento
    [Tags]    smoke    cadastro    positivo
    
    Cadastrar Novo Equipamento
    ...    nome=${EQUIP_NOME_VALIDO}
    ...    tipo=${EQUIP_TIPO}
    ...    status=${EQUIP_STATUS_OPERACIONAL}
    ...    localizacao=${EQUIP_LOCALIZACAO}
    
    Validar Equipamento Cadastrado    ${EQUIP_NOME_VALIDO}
    Sistema Deve Exibir Mensagem    Equipamento cadastrado com sucesso    sucesso

CT002 - Editar Equipamento Existente
    [Documentation]    Valida a edição de um equipamento já cadastrado
    [Tags]    edicao    positivo
    
    ${novo_nome}=    Set Variable    ${EQUIP_NOME_VALIDO} - Atualizado
    ${novo_status}=  Set Variable    ${EQUIP_STATUS_MANUTENCAO}
    
    Editar Equipamento Existente
    ...    nome_atual=${EQUIP_NOME_VALIDO}
    ...    novo_nome=${novo_nome}
    ...    novo_tipo=${EQUIP_TIPO}
    ...    novo_status=${novo_status}
    ...    nova_localizacao=${EQUIP_LOCALIZACAO}
    
    Validar Equipamento Cadastrado    ${novo_nome}
    Sistema Deve Exibir Mensagem    Equipamento atualizado com sucesso    sucesso

CT003 - Excluir Equipamento
    [Documentation]    Valida a exclusão de um equipamento do sistema
    [Tags]    exclusao    positivo
    
    Excluir Equipamento    ${EQUIP_NOME_VALIDO} - Atualizado
    Sistema Deve Exibir Mensagem    Equipamento excluído com sucesso    sucesso

CT004 - Validar Campo Nome Obrigatório
    [Documentation]    Tenta cadastrar equipamento sem preencher o campo nome
    [Tags]    validacao    negativo
    
    Clicar No Botão Novo Equipamento
    Preencher Campo Tipo    ${EQUIP_TIPO}
    Preencher Campo Status    ${EQUIP_STATUS_OPERACIONAL}
    Preencher Campo Localização    ${EQUIP_LOCALIZACAO}
    Clicar No Botão Salvar
    
    Sistema Deve Exibir Mensagem    O campo nome é obrigatório    erro

CT005 - Validar Limite De Caracteres No Campo Nome
    [Documentation]    Tenta cadastrar equipamento com nome excedendo o limite
    [Tags]    validacao    negativo
    
    Clicar No Botão Novo Equipamento
    Preencher Campo Nome    ${NOME_MUITO_LONGO}
    Preencher Campo Tipo    ${EQUIP_TIPO}
    Preencher Campo Status    ${EQUIP_STATUS_OPERACIONAL}
    Preencher Campo Localização    ${EQUIP_LOCALIZACAO}
    Clicar No Botão Salvar
    
    Sistema Deve Exibir Mensagem    O nome deve ter no máximo 255 caracteres    erro

CT006 - Validar Sanitização De Caracteres Especiais
    [Documentation]    Tenta cadastrar equipamento com caracteres especiais perigosos (XSS)
    [Tags]    seguranca    negativo
    
    Clicar No Botão Novo Equipamento
    Preencher Campo Nome    ${NOME_CARACTERES_ESPECIAIS}
    Preencher Campo Tipo    ${EQUIP_TIPO}
    Preencher Campo Status    ${EQUIP_STATUS_OPERACIONAL}
    Preencher Campo Localização    ${EQUIP_LOCALIZACAO}
    Clicar No Botão Salvar
    
    # Verifica se o sistema sanitizou ou rejeitou a entrada
    Sistema Deve Exibir Mensagem    caracteres especiais não são permitidos    erro
