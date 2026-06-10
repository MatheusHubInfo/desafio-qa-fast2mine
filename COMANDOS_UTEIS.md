# 📚 Comandos Úteis - Cola de Referência Rápida

## 🚀 Execução Rápida

```bash
# Teste mais rápido - valida que tudo está funcionando
./teste_rapido.sh

# Execução paralela - roda tudo em 3 ambientes
./rodar_paralelo.sh

# Execução normal em um ambiente
robot tests/web/                               # Mercado Livre (padrão)
robot -v ENVIRONMENT:AMAZON tests/web/         # Amazon
robot -v ENVIRONMENT:SAMSUNG tests/web/        # Samsung
```

---

## 🎯 Filtros e Seleção de Testes

```bash
# Rodar apenas um teste específico
robot --test "CT-001*" tests/web/

# Rodar por tags
robot -i smoke tests/web/          # Apenas smoke tests
robot -i alta tests/web/           # Apenas alta prioridade
robot -i positivo tests/web/       # Apenas testes positivos
robot -i negativo tests/web/       # Apenas testes negativos

# Excluir testes por tag
robot -e lento tests/web/          # Pula testes lentos

# Combinar filtros
robot -i alta -i positivo tests/web/    # Alta E positivo
```

---

## 📊 Opções de Relatório

```bash
# Personalizar saída dos relatórios
robot --outputdir results/custom \
      --name "Minha Suite" \
      --loglevel DEBUG \
      tests/web/

# Incluir timestamp no nome do relatório
robot --timestampoutputs tests/web/

# Não gerar log.html (só report.html) - mais rápido
robot --log NONE tests/web/

# Modo silencioso no console
robot --console quiet tests/web/
```

---

## 🐛 Debug e Troubleshooting

```bash
# Modo debug - mostra TUDO que está acontecendo
robot --loglevel DEBUG \
      --console verbose \
      tests/web/

# Pausar execução para investigar (adicione no teste)
# Import Library DebugLibrary
# Debug

# Rodar com Dry Run - valida sintaxe sem executar
robot --dryrun tests/web/

# Ver variáveis disponíveis
robot --variable ENVIRONMENT:AMAZON \
      --dryrun \
      --loglevel TRACE \
      tests/web/
```

---

## 🔄 Reexecutar Apenas Falhas

```bash
# Primeira execução
robot --outputdir results/run1 tests/web/

# Reexecutar apenas os que falharam
robot --rerunfailed results/run1/output.xml \
      --outputdir results/run2 \
      tests/web/

# Mesclar resultados
rebot --merge results/run1/output.xml results/run2/output.xml
```

---

## 📸 Screenshots e Capturas

```bash
# Tirar screenshot em qualquer keyword:
# Take Screenshot    nome_do_arquivo

# Screenshots automáticos em falhas já estão configurados!
# Veja em: results/screenshots/
```

---

## 🌐 Configuração de Browser

```bash
# Rodar em modo headless (sem abrir janela)
# Edite shared_keywords.resource:
# New Browser    browser=chromium    headless=True

# Trocar navegador
# browser=chromium    # Chrome/Edge (padrão)
# browser=firefox
# browser=webkit      # Safari
```

---

## 📱 Comandos Appium (Mobile)

```bash
# Verificar dispositivos conectados
adb devices

# Listar apps instalados
adb shell pm list packages | grep fast2mine

# Ver logs do dispositivo em tempo real
adb logcat | grep -i error

# Iniciar Appium Server
appium

# Appium com log detalhado
appium --log-level debug
```

---

## 🎨 Visualização de Resultados

```bash
# Abrir relatório no navegador padrão (Linux)
xdg-open results/amazon/report.html

# Mac
open results/amazon/report.html

# Windows
start results/amazon/report.html

# Ou simplesmente navegue até a pasta e clique duplo no report.html
```

---

## 🔧 Manutenção e Limpeza

```bash
# Limpar resultados antigos
rm -rf results/

# Reinstalar dependências
pip install --upgrade robotframework robotframework-browser
rfbrowser init

# Verificar versões instaladas
robot --version
pip list | grep robot
```

---

## 📦 Exportar Resultados

```bash
# Zipar resultados para enviar
zip -r resultados_testes.zip results/

# Converter XML para diferentes formatos
rebot --output custom.xml results/output.xml

# Gerar apenas o report de um XML existente
rebot results/output.xml
```

---

## 🎓 Dicas Pro

```bash
# Variáveis via linha de comando
robot -v BROWSER:firefox \
      -v TIMEOUT:30 \
      tests/web/

# Rodar com profile de performance
robot --listener RetryFailed:2 tests/web/  # Retry falhas 2x

# Paralelizar com pabot (instale: pip install robotframework-pabot)
pabot --processes 3 tests/web/

# Gerar relatório consolidado de múltiplas execuções
rebot --name "Consolidado" \
      --merge \
      results/*/output.xml
```

---

## 🚀 Pipeline Local (Simula CI/CD)

```bash
# Script que simula o que o GitHub Actions faz
echo "Rodando pipeline..."
./rodar_paralelo.sh

if [ $? -eq 0 ]; then
    echo "✅ Pipeline passou! Pode fazer deploy!"
else
    echo "❌ Pipeline falhou! Fix antes de commitar."
fi
```

---

## 📝 Atalhos Úteis

| Ação | Comando |
|------|---------|
| Teste rápido | `./teste_rapido.sh` |
| Todos ambientes | `./rodar_paralelo.sh` |
| Um ambiente | `robot tests/web/` |
| Debug | `robot --loglevel DEBUG tests/web/` |
| Smoke tests | `robot -i smoke tests/web/` |
| Ver relatório | `xdg-open results/*/report.html` |

---

💡 **Dica:** Salve este arquivo como favorito! Copie e cole os comandos conforme precisar.

🔖 **Bookmark:** Pressione `Ctrl+D` neste arquivo no VS Code para acesso rápido!
