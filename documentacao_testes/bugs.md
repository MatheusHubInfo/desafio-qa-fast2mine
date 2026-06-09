## BUG-001 - Status não é persistido após edição

**Tipo:** Funcional
**Prioridade:** Alta
**Severidade:** Média
**Ambiente:** QA1

### Passos para Reprodução:
1. Acessar a tela de listagem de equipamentos.
2. Identificar um equipamento com status "Ativo" e clicar em "Editar".
3. Alterar o status do equipamento para "Inativo".
4. Clicar no botão "Salvar".
5. Realizar uma nova busca pelo equipamento editado.

### Cenário (Comportamento)
**Dado** que existe um equipamento com status "Ativo"
**Quando** o usuário altera o status para "Inativo" e salva
**Então** o sistema deveria exibir o status "Inativo" nas consultas futuras
**Mas** o sistema continua exibindo o status "Ativo"

---

**Resultado Esperado:** Status atualizado e exibido como "Inativo".
**Resultado Obtido:** Status permanece "Ativo" na listagem após salvar.
**Evidência:** `evidencias/BUG-001.png`