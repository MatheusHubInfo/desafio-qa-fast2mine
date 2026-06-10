# Desafio Técnico QA - Fast2Mine

Projeto de automação de testes (Web e Mobile) desenvolvido em Robot Framework com Browser Library (Playwright) e Appium.

## Sobre o Projeto

Implementação de testes automatizados em sites reais de e-commerce:
- Amazon Brasil
- Mercado Livre
- Casas Bahia

Os testes validam funcionalidades de busca de produtos. A arquitetura multiambiente permite rodar os mesmos testes em sites diferentes apenas mudando uma variável.

---

## Estrutura do Projeto

```
prova_tecnica/
├── .github/workflows/
│   └── testes-automatizados.yml    # Pipeline CI/CD automático
├── documentacao_testes/
│   ├── casos_de_teste.md           # 8 casos de teste documentados
│   ├── bugs.md                     # 1 bug report
│   └── evidencias/                 # Screenshots das execuções
├── resources/
│   ├── config/
│   │   └── env_config.resource     # Configuração dos 3 ambientes
│   ├── pages/
│   │   ├── web_equipamentos.page       # Localizadores Web
│   │   └── mobile_equip_page.resource  # Localizadores Mobile
│   ├── web_keywords.resource       # Keywords Web 
│   ├── mobile_keywords.resource    # Keywords Mobile 
│   └── shared_keywords.resource    # Importa Web + Mobile
├── tests/
│   ├── web/gerenciar_equip.robot       # 3 testes Web
│   └── mobile/gerenciar_equip.robot    # 7 testes Mobile
├── rodar_paralelo.sh               # Roda os 3 ambientes ao mesmo tempo
└── README.md                       # Você está aqui!
```

---

## Instalação

### Pré-requisitos
- Python 3.10+
- Node.js 20+ (obrigatório para Playwright)
- Git

### 1. Clone o repositório
```bash
git clone https://github.com/MatheusHubInfo/desafio-qa-fast2mine.git
cd desafio-qa-fast2mine
```

### 2. Instale Node.js 20 com NVM
```bash
# Instala NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Carrega NVM no terminal atual
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Instala Node.js 20
nvm install 20
nvm use 20
```

### 3. Instale as dependências Python
```bash
pip3 install robotframework robotframework-browser robotframework-appiumlibrary
```

### 4. Inicialize o Playwright
```bash
rfbrowser init
```

---

## Como Executar os Testes

### Execução Simples (Script automático)
```bash
# Roda testes na Amazon
./rodar_teste.sh AMAZON

# Roda testes no Mercado Livre
./rodar_teste.sh MERCADOLIVRE

# Roda testes na Casas Bahia
./rodar_teste.sh CASASBAHIA
```

### Testes Web - Execução Individual

#### Executar em um ambiente específico:
```bash
# Amazon (ambiente padrão se não especificar)
robot tests/web/

# Mercado Livre
robot -v ENVIRONMENT:MERCADOLIVRE tests/web/

# Casas Bahia
robot -v ENVIRONMENT:CASASBAHIA tests/web/
```

#### Filtrar por tags:
```bash
# Apenas testes de alta prioridade
robot -i alta tests/web/

# Apenas testes positivos
robot -i positivo tests/web/

# Apenas smoke tests (os mais importantes)
robot -i smoke tests/web/
```

---

### Execução Paralela - Roda 3 ambientes ao mesmo tempo

```bash
# No Linux/Mac:
./rodar_paralelo.sh

# No Windows (PowerShell):
# Execute manualmente em 3 terminais diferentes:
robot -v ENVIRONMENT:AMAZON tests/web/
robot -v ENVIRONMENT:MERCADOLIVRE tests/web/
robot -v ENVIRONMENT:CASASBAHIA tests/web/
```

Vantagens da execução paralela:
- 3x mais rápido que rodar sequencial
- Valida todos os ambientes de uma vez
- Relatórios separados para cada ambiente

---

### Testes Mobile (Appium)

```bash
# 1. Inicie o Appium Server em um terminal separado
appium

# 2. Execute os testes mobile
robot tests/mobile/

# Com ambiente específico
robot -v ENVIRONMENT:MERCADOLIVRE tests/mobile/
```

Guia completo de configuração mobile: APPIUM_CAPABILITIES.md

---

## Cenários Implementados

### Web (Browser Library + Playwright)
| ID | Cenário | Tipo | Prioridade |
|----|---------|------|------------|
| CT-001 | Buscar produto existente e validar título | Positivo | Alta |
| CT-002 | Buscar produto inexistente | Negativo | Alta |
| CT-003 | Buscar produto com termo parcial | Positivo | Média |

### Mobile (Appium Library) - 7 cenários
Todos os cenários web + cenários específicos de mobile (edição, validação, etc.)

---

## CI/CD e Reports

O projeto utiliza **GitHub Actions** para automação, configurado para rodar a cada push ou via agendamento (cron). 

**Destaques da implementação:**
*   **Execução Paralela:** Os ambientes (Amazon, ML, Casas Bahia) rodam em containers separados simultaneamente, reduzindo o tempo total da pipeline.
*   **Gestão de Evidências:** O framework está configurado para gerar screenshots apenas em casos estritos de falha (Teardown). Para execuções de sucesso, o log detalhado é a principal evidência.
*   **Relatórios Consolidados:** Ao final da execução, os artefatos de todos os ambientes são armazenados no GitHub.
*   **Tratamento de Erros (Anti-Bot):** O ambiente **Casas Bahia** apresenta falha controlada na pipeline. Isso ocorre devido às políticas rigorosas de segurança do site que bloqueiam automações em modo `headless` (CI), servindo como demonstração de logs de erro e tratamento de exceções do framework.

---

## Visualizando Resultados

Após executar os testes, verifique os relatórios gerados:

```
results/
├── amazon/
│   ├── report.html          # Relatório principal
│   ├── log.html             # Log detalhado
│   ├── output.xml           # Dados estruturados
│   └── browser/screenshot/  # Screenshots dos testes
├── mercadolivre/
│   └── ...
└── casasbahia/
    └── ...
```

Abra o report.html no navegador para ver:
- Taxa de sucesso/falha
- Tempo de execução
- Screenshots
- Logs detalhados (Verificar `log.html` para rastreabilidade completa)

---

## Ambientes Configurados

| Ambiente | URL | Produto Teste | Uso |
|----------|-----|---------------|-----|
| **AMAZON** | https://www.amazon.com.br | Apple iphone 16 plus rosa | Testes de produtos eletrônicos |
| **MERCADOLIVRE** | https://www.mercadolivre.com.br | nitendo switch lite azul | Testes de marketplace |
| **CASASBAHIA** | https://www.casasbahia.com.br | tv samsung 50 | Testes de varejo eletrônicos |

---

## Tecnologias Utilizadas

- Robot Framework 7.0+ - Framework de automação
- Browser Library (Playwright) - Automação Web
- Appium Library - Automação Mobile
- Python 3.11 - Linguagem base
- GitHub Actions - CI/CD
- Bash - Scripts de automação

---

## Documentação Adicional

- Guia de Capabilities do Appium: APPIUM_CAPABILITIES.md
- Casos de Teste Manuais: documentacao_testes/casos_de_teste.md
- Bug Reports: documentacao_testes/bugs.md

---

## Destaques Técnicos

- Código modular: Keywords separadas por contexto (Web/Mobile)
- Arquitetura escalável: Fácil adicionar novos ambientes/sites
- Seletores inteligentes: Múltiplos fallbacks para confiabilidade
- Waits dinâmicos: Esperas inteligentes para sincronização
- Tratamento de erros: TRY/EXCEPT em pontos críticos
- Page Object Pattern: Separação clara de responsabilidades
- Multiambiente: Troca de ambiente via parâmetro

---

## Autor

Matheus Alves
- GitHub: @MatheusHubInfo

---

## Licença

Projeto desenvolvido como parte de um desafio técnico para demonstração de conhecimentos em automação de testes.
