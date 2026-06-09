# Desafio Técnico QA - Fast2Mine

Projeto de automação de testes (Web e Mobile) para o sistema de Gestão de Equipamentos, desenvolvido em Robot Framework.

## 📁 Estrutura Básica
* `documentacao_testes/`: Casos de teste manuais e reporte de bugs.
* `resources/`: Configurações de ambiente, seletores das telas e keywords.
* `tests/`: Scripts de testes automatizados para Web e Mobile.

## 🚀 Como Instalar

1. Instale o Robot Framework e as bibliotecas necessárias:
```bash
pip install robotframework robotframework-browser robotframework-appiumlibrary
```

2. Inicialize o driver do Browser (Playwright):
```bash
rfbrowser init
```

## 💻 Como Executar os Testes
O projeto foi estruturado para rodar em múltiplos ambientes de forma dinâmica. Basta passar o ambiente desejado (`QA1`, `QA2` ou `QA3`) via terminal.

### Testes Web (Browser)
```bash
# Rodar no ambiente padrão (QA1)
robot tests/web/

# Rodar mudando para o ambiente QA2
robot -v ENVIRONMENT:QA2 tests/web/
```

### Testes Mobile (Appium)
*(Certifique-se de estar com o Appium Server rodando)*

```bash
robot tests/mobile/
```

**Autor:** Matheus Alves
