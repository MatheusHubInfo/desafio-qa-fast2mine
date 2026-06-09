# Casos de Teste - Gestão de Equipamentos

## 📋 Informações de Controle
* **Autor do Teste:** Matheus Alves de Lima
* **Data de Criação:** 09/06/2026
* **Ferramenta de Documentação:** Markdown (VS Code)

### 🌍 Matriz de Ambientes e Massa de Dados (Multiambiente)
Abaixo estão mapeados os ambientes fictícios fornecidos para a execução destes cenários:

| Ambiente | Tipo/Propósito | URL Base (Fictícia) | Massa de Dados (Válida)    |               |
| **QA1**  | Testes Funcionais / Qualidade 1      | `https://gal.sistema.com`  | `Caminhão 01` |
| **QA2**  | Testes de Integração / Qualidade 2   | `https://gal2.sistema.com` | `Caminhão_02` |
| **QA3**  | Pré-Homologação / Qualidade 3        | `https://gal3.sistema.com` | `Caminhão_03` |

---

## CT-001 - Buscar equipamento existente
**Tipo:** Positivo
**Prioridade:** Alta
**Pré-condição:** O usuário está na tela de equipamentos e existe um equipamento válido cadastrado no ambiente.

**Cenário:**
* **Dado** que o usuário está na tela de equipamentos
* **Quando** informar o nome de um equipamento válido
* **E** clicar em "Buscar"
* **Então** o sistema deve retornar o equipamento correspondente
* **E** exibir suas informações corretamente

**Resultado Esperado:** O sistema recarrega a listagem exibindo com sucesso apenas o equipamento pesquisado e suas respectivas informações.

**Evidência Esperada:** `evidencias/manuais/CT-001_sucesso.png`

---

## CT-002 - Editar nome do equipamento
**Tipo:** Positivo
**Prioridade:** Alta
**Pré-condição:** O usuário localizou um equipamento cadastrado na listagem.

**Cenário:**
* **Dado** que o usuário localizou um equipamento cadastrado
* **Quando** clicar em "Editar"
* **E** alterar o nome do equipamento
* **E** salvar a alteração
* **Então** o sistema deve atualizar o nome com sucesso
* **E** exibir mensagem de confirmação

**Resultado Esperado:** O nome do equipamento é atualizado no banco de dados/Front e o sistema exibe uma mensagem confirmando o sucesso da alteração.

**Evidência Esperada:** `evidencias/manuais/CT-002_sucesso_produto_atualizado.png`
**Evidência Esperada:** `evidencias/manuais/CT-002_sucesso_banco_de_dados.png`

---

## CT-003 - Alterar status do equipamento
**Tipo:** Positivo
**Prioridade:** Alta
**Pré-condição:** O usuário está na tela de edição de um equipamento com status "Ativo".

**Cenário:**
* **Dado** que existe um equipamento com status "Ativo"
* **Quando** o usuário alterar o status para "Inativo"
* **E** salvar a alteração
* **Então** o sistema deve persistir a alteração
* **E** exibir o status "Inativo"

**Resultado Esperado:** O status do equipamento é modificado e a listagem passa a exibir o valor "Inativo" para o registro correspondente.

**Evidência Esperada:** `evidencias/manuais/CT-003_status_antes_da_alteracao.png`
**Evidência Esperada:** `evidencias/manuais/CT-003_status_apos_alteracao.png`

---

## CT-004 - Consultar status do equipamento
**Tipo:** Positivo
**Prioridade:** Média
**Pré-condição:** Existe um equipamento cadastrado e ativo no ambiente atual.

**Cenário:**
* **Dado** que existe um equipamento cadastrado com status "Ativo"
* **Quando** o usuário realizar a busca pelo equipamento
* **Então** o sistema deve exibir o equipamento encontrado
* **E** apresentar o status "Ativo"

**Resultado Esperado:** O equipamento é exibido na tela de consultas exibindo claramente a tag ou texto identificando o status como "Ativo".

**Evidência Esperada:** `evidencias/manuais/CT-004_sucesso.png`

---

## CT-005 - Limpar filtro de pesquisa
**Tipo:** Positivo
**Prioridade:** Média
**Pré-condição:** O usuário realizou uma busca prévia na tela de equipamentos.

**Cenário:**
* **Dado** que o usuário realizou uma busca por um equipamento
* **Quando** clicar na opção de limpar filtro
* **Então** o sistema deve remover os critérios da pesquisa
* **E** exibir novamente todos os equipamentos disponíveis

**Resultado Esperado:** O campo de busca é resetado e a listagem volta a exibir a totalidade de registros cadastrados para aquele ambiente.

**Evidência Esperada:** `evidencias/manuais/CT-005_sucesso.png`

---

## CT-006 - Buscar equipamento inexistente
**Tipo:** Negativo
**Prioridade:** Alta
**Pré-condição:** O usuário está na tela de equipamentos.

**Cenário:**
* **Dado** que o usuário está na tela de equipamentos
* **Quando** informar um equipamento inexistente
* **E** clicar em "Buscar"
* **Então** o sistema deve exibir a mensagem "Equipamento não encontrado"
* **E** não apresentar registros na consulta

**Resultado Esperado:** A tabela de dados fica vazia e uma mensagem de alerta avisa textualmente que nenhum registro foi localizado.

**Evidência Esperada:** `evidencias/manuais/CT-006_sucesso.png`

---

## CT-007 - Salvar equipamento sem preencher nome
**Tipo:** Negativo
**Prioridade:** Alta
**Pré-condição:** O usuário abriu o formulário de edição de um equipamento existente.

**Cenário:**
* **Dado** que o usuário está editando um equipamento
* **Quando** remover o valor do campo nome
* **E** tentar salvar a alteração
* **Então** o sistema deve impedir a gravação
* **E** exibir mensagem informando que o campo é obrigatório

**Resultado Esperado:** O sistema bloqueia o envio do formulário, mantém o usuário na mesma página e destaca o campo com o aviso de obrigatoriedade.

**Evidência Esperada:** `evidencias/manuais/CT-007_sucesso.png`

---

## CT-008 - Informar status inválido
**Tipo:** Negativo
**Prioridade:** Média
**Pré-condição:** O usuário está na tela de edição do equipamento.

**Cenário:**
* **Dado** que o usuário está editando um equipamento
* **Quando** informar um status não permitido pelo sistema
* **E** tentar salvar a alteração
* **Então** o sistema deve rejeitar a operação
* **E** exibir mensagem de validação

**Resultado Esperado:** A alteração é recusada pela aplicação e o usuário recebe um feedback visual indicando que o dado inserido é inválido.

**Evidência Esperada:** `evidencias/manuais/CT-008_sucesso.png`