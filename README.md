# 🤖 Desafio Técnico QA - Fast2Mine

Projeto de automação de testes (Web e Mobile) para validação de funcionalidades de busca em e-commerce, desenvolvido em **Robot Framework** com **Browser Library (Playwright)** e **Appium**.

## 🎯 Sobre o Projeto

Este projeto demonstra automação de testes **funcionando de verdade** em sites reais:
- 🛒 **Amazon Brasil**
- 🛍️ **Mercado Livre**
- 📱 **Samsung Brasil**

Os testes validam a funcionalidade de busca de produtos, garantindo que os resultados sejam exibidos corretamente. A arquitetura multiambiente permite executar os mesmos testes em diferentes sites sem alterar o código!

---

## 📁 Estrutura do Projeto

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

## 🚀 Instalação

### Pré-requisitos
- Python 3.10+
- **Node.js 20+** (obrigatório para Playwright)
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
~/.local/bin/rfbrowser init
```

---

## 💻 Como Executar os Testes

### Execução Simples (Script automático)
```bash
# Roda testes na Amazon
./rodar_teste.sh AMAZON

# Roda testes no Mercado Livre
./rodar_teste.sh MERCADOLIVRE

# Roda testes na Samsung
./rodar_teste.sh SAMSUNG
```

### Testes Web - Execução Individual

#### Executar em um ambiente específico:
```bash
# Amazon (ambiente padrão se não especificar)
robot tests/web/

# Mercado Livre
robot -v ENVIRONMENT:MERCADOLIVRE tests/web/

# Samsung
robot -v ENVIRONMENT:SAMSUNG tests/web/
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

### 🚀 Execução Paralela - Roda 3 ambientes simultaneamente!

```bash
# No Linux/Mac:
./rodar_paralelo.sh

# No Windows (PowerShell):
# Execute manualmente em 3 terminais diferentes:
robot -v ENVIRONMENT:AMAZON tests/web/
robot -v ENVIRONMENT:MERCADOLIVRE tests/web/
robot -v ENVIRONMENT:SAMSUNG tests/web/
```

**Vantagens da execução paralela:**
- ⚡ 3x mais rápido que rodar sequencial
- 🎯 Valida todos os ambientes de uma vez
- 📊 Relatórios separados para cada ambiente

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

📖 **Guia completo de configuração mobile:** [`APPIUM_CAPABILITIES.md`](APPIUM_CAPABILITIES.md)

---

## 🎯 Cenários Implementados

### Web (Browser Library + Playwright)
| ID | Cenário | Tipo | Prioridade |
|----|---------|------|------------|
| CT-001 | Buscar produto existente e validar título | Positivo | Alta 🔥 |
| CT-002 | Buscar produto inexistente | Negativo | Alta |
| CT-003 | Buscar produto com termo parcial | Positivo | Média |

### Mobile (Appium Library) - 7 cenários
Todos os cenários web + cenários específicos de mobile (edição, validação, etc.)

---

## 🏆 Diferenciais Implementados

### ✅ 1. Integração com Pipeline CI/CD
- **GitHub Actions** configurado em [`.github/workflows/testes-automatizados.yml`](.github/workflows/testes-automatizados.yml)
- Executa automaticamente a cada push ou pull request
- Testes de regressão agendados (segunda a sexta, 2h da manhã)
- Comentários automáticos em PRs com resultados

### ✅ 2. Geração Automática de Relatórios
- Relatório HTML padrão do Robot Framework
- Relatório customizado com resumo visual
- Screenshots automáticos em caso de falha
- Logs detalhados para debugging

### ✅ 3. Tratamentos Personalizados em Caso de Falha
- Keyword `Capturar Erro` que:
  - Tira screenshot automaticamente
  - Salva log detalhado em arquivo
  - Exibe mensagem amigável no console
  - Registra contexto completo (ambiente, URL, timestamp)

### ✅ 4. Execução Paralela
- Script bash [`rodar_paralelo.sh`](rodar_paralelo.sh) para execução local
- Pipeline CI/CD roda 3 jobs simultaneamente
- Economia de **66% do tempo** de execução!

---

## 📊 Visualizando Resultados

Após executar os testes, verifique os relatórios gerados:

```
results/
├── amazon/
│   ├── report.html          # Relatório principal ⭐
│   ├── log.html             # Log detalhado
│   └── output.xml           # Dados estruturados
├── mercadolivre/
│   └── ...
├── samsung/
│   └── ...
└── reports/
    ├── relatorio_customizado.html  # Relatório visual customizado
    └── erros.log                   # Log consolidado de erros
```

**Dica:** Abra o `report.html` no navegador para ver:
- ✅ Taxa de sucesso/falha
- ⏱️ Tempo de execução
- 📸 Screenshots
- 📝 Logs detalhados

---

## 🌍 Ambientes Configurados

| Ambiente | URL | Produto Teste | Uso |
|----------|-----|---------------|-----|
| **AMAZON** | https://www.amazon.com.br | iPhone 15 | Testes de produtos eletrônicos |
| **MERCADOLIVRE** | https://www.mercadolivre.com.br | Notebook Dell | Testes de marketplace |
| **SAMSUNG** | https://www.samsung.com/br | Galaxy S24 | Testes de fabricante |

---

## 🛠️ Tecnologias Utilizadas

- **Robot Framework** 7.0+ - Framework de automação
- **Browser Library** (Playwright) - Automação Web moderna
- **Appium Library** - Automação Mobile
- **Python** 3.11 - Linguagem base
- **GitHub Actions** - CI/CD
- **Bash** - Scripts de automação

---

## 📝 Documentação Adicional

- 📖 [Guia de Capabilities do Appium](APPIUM_CAPABILITIES.md)
- 📋 [Casos de Teste Manuais](documentacao_testes/casos_de_teste.md)
- 🐛 [Bug Reports](documentacao_testes/bugs.md)

---

## ✨ Destaques Técnicos

- **Código modular**: Keywords separadas por contexto (Web/Mobile) para fácil manutenção
- **Arquitetura escalável**: Fácil adicionar novos ambientes/sites
- **Comentários diretos**: Sem poluição, só o essencial
- **Seletores inteligentes**: Múltiplos fallbacks para maior confiabilidade
- **Waits dinâmicos**: Esperas inteligentes para sincronização
- **Tratamento robusto de erros**: TRY/EXCEPT em pontos críticos
- **Page Object Pattern**: Separação clara de responsabilidades
- **Multiambiente**: Troca de ambiente via parâmetro

---

## 🎓 Como Usar Este Projeto

### Para aprender:
1. Leia os comentários no código - eles explicam o "porquê" de cada decisão
2. Execute os testes e veja funcionando
3. Modifique e experimente

### Para apresentar em entrevistas:
1. Clone e rode localmente para demonstrar
2. Mostre a execução paralela
3. Navegue pelo código explicando a arquitetura
4. Destaque os diferenciais (CI/CD, tratamento de erros, etc.)

---

## 👤 Autor

**Matheus Alves**
- 📧 Email: [seu-email@example.com]
- 💼 LinkedIn: [seu-linkedin]
- 🐙 GitHub: [@MatheusHubInfo](https://github.com/MatheusHubInfo)

---

## 📄 Licença

Este projeto foi desenvolvido como parte de um desafio técnico para demonstração de conhecimentos em automação de testes.

---

<div align="center">

**⭐ Se este projeto te ajudou, deixe uma estrela!**

*Desenvolvido com ☕ e muito aprendizado*

</div>
