# Desafio Técnico QA - Fast2Mine

Projeto de automação de testes (Web e Mobile) para o sistema de Gestão de Equipamentos, desenvolvido em Robot Framework.

## 📁 Estrutura Básica
* `documentacao_testes/`: Casos de teste manuais e reporte de bugs.
* `resources/`: Configurações de ambiente, seletores das telas e keywords.
  * `config/`: Configurações dinâmicas de ambientes (QA1, QA2, QA3)
  * `pages/`: Mapeamento de elementos (Page Objects)
* `tests/`: Scripts de testes automatizados para Web e Mobile.
  * `web/`: 7 cenários automatizados (5 positivos + 2 negativos)
  * `mobile/`: 7 cenários automatizados (5 positivos + 2 negativos)

## 🚀 Como Instalar

1. Instale o Robot Framework e as bibliotecas necessárias:
```bash
pip install robotframework robotframework-browser robotframework-appiumlibrary
```

2. Inicialize o driver do Browser (Playwright):
```bash
rfbrowser init
```

3. *(Opcional)* Para testes mobile, instale e configure o Appium:
```bash
npm install -g appium
appium driver install uiautomator2
```

## 💻 Como Executar os Testes

O projeto foi estruturado para rodar em múltiplos ambientes de forma dinâmica. Basta passar o ambiente desejado (`QA1`, `QA2` ou `QA3`) via terminal.

### Testes Web (Browser)
```bash
# Rodar no ambiente padrão (QA1)
robot tests/web/

# Rodar mudando para o ambiente QA2
robot -v ENVIRONMENT:QA2 tests/web/

# Rodar apenas testes de alta prioridade
robot -i alta tests/web/

# Rodar apenas testes positivos
robot -i positivo tests/web/
```

### Testes Mobile (Appium)
*(Certifique-se de estar com o Appium Server rodando)*

```bash
# Inicie o Appium em um terminal separado
appium

# Execute os testes mobile
robot tests/mobile/

# Rodar em ambiente específico
robot -v ENVIRONMENT:QA3 tests/mobile/
```

## 📱 Configuração do Appium (Capabilities)

As **capabilities** são configurações que informam ao Appium como se conectar ao dispositivo/emulador e qual aplicativo abrir. No projeto, as capabilities estão configuradas em [`shared_keywords.resource`](resources/shared_keywords.resource):

```robot
Open Application    http://localhost:4723/wd/hub
    ...             platformName=Android          # Sistema: Android ou iOS
    ...             platformVersion=11.0          # Versão do Android/iOS
    ...             deviceName=Android Emulator   # Nome do dispositivo
    ...             appPackage=com.fast2mine.sistema      # Pacote do app
    ...             appActivity=.MainActivity              # Activity inicial
    ...             automationName=UiAutomator2           # Driver de automação
    ...             autoGrantPermissions=true             # Conceder permissões automaticamente
    ...             noReset=true                          # Não resetar o app entre sessões
```

### Para usar com dispositivo físico:
```robot
# Adicione estas capabilities:
...             udid=seu_device_id_aqui    # ID único do dispositivo (via 'adb devices')
...             systemPort=8200            # Porta do UiAutomator2 (evita conflitos)
```

## 🎯 Cenários Implementados

### Web (Browser Library + Playwright)
- ✅ CT-001: Buscar equipamento existente
- ✅ CT-002: Editar nome do equipamento
- ✅ CT-003: Alterar status do equipamento
- ✅ CT-004: Consultar status do equipamento
- ✅ CT-005: Limpar filtro de pesquisa
- ✅ CT-006: Buscar equipamento inexistente (negativo)
- ✅ CT-007: Salvar sem preencher nome (validação - negativo)

### Mobile (Appium Library)
- ✅ CT-001: Buscar equipamento existente no app
- ✅ CT-002: Editar nome do equipamento no app
- ✅ CT-003: Alterar status do equipamento no app
- ✅ CT-004: Consultar status do equipamento no app
- ✅ CT-005: Limpar filtro de pesquisa no app
- ✅ CT-006: Buscar equipamento inexistente no app (negativo)
- ✅ CT-007: Salvar sem preencher nome no app (validação - negativo)

## ✨ Destaques Técnicos

- **Estrutura multiambiente**: Troca de ambiente (QA1/QA2/QA3) sem alterar código
- **Separação de responsabilidades**: Page Objects, Keywords e Testes separados
- **Massa de dados parametrizada**: Dados dinâmicos por ambiente
- **Waits inteligentes**: Esperas dinâmicas para garantir estabilidade
- **Reutilização de código**: Keywords compartilhadas entre testes
- **Escalabilidade**: Fácil adicionar novos ambientes ou cenários

## 📝 Documentação de Testes Manuais

- **8 casos de teste** documentados (5 positivos + 3 negativos)
- **1 bug report** estruturado com evidências
- Localização: [`documentacao_testes/`](documentacao_testes/)

**Autor:** Matheus Alves
