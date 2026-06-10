# Guia de Capabilities do Appium

## O que são Capabilities?

**Capabilities** (ou Desired Capabilities) são configurações em formato de chave-valor que você passa para o Appium Server. Elas dizem ao Appium:
- Qual tipo de dispositivo usar (Android ou iOS)
- Qual aplicativo abrir
- Quais permissões conceder
- Como se comportar durante os testes

Pense nas capabilities como "instruções de configuração" para o Appium.

---

## Capabilities Básicas Obrigatórias

### Para Android:
```robot
platformName=Android              # Sistema operacional
deviceName=Android Emulator       # Nome do dispositivo (pode ser qualquer string)
appPackage=com.exemplo.app        # Identificador único do app
appActivity=.MainActivity          # Tela inicial do app
automationName=UiAutomator2       # Driver de automação (recomendado)
```

### Para iOS:
```robot
platformName=iOS
deviceName=iPhone 14
bundleId=com.exemplo.app          # Identificador do app iOS
automationName=XCUITest           # Driver de automação iOS
```

---

## Capabilities Úteis Adicionais

| Capability | Descrição | Exemplo |
|------------|-----------|---------|
| `platformVersion` | Versão do SO | `11.0`, `14.0` |
| `udid` | ID único do dispositivo físico | `emulator-5554`, `00008030-001A...` |
| `autoGrantPermissions` | Concede permissões automaticamente | `true` |
| `noReset` | Não limpa dados do app entre sessões | `true` |
| `fullReset` | Reinstala o app antes de cada teste | `true` |
| `newCommandTimeout` | Tempo de espera entre comandos (segundos) | `300` |
| `systemPort` | Porta do UiAutomator2 (evita conflitos) | `8200` |
| `app` | Caminho para o APK/IPA | `/path/to/app.apk` |

---

## Como Descobrir os Valores?

### 1. **appPackage** e **appActivity** (Android)

```bash
# Abra o app no dispositivo, depois execute:
adb shell dumpsys window | grep -E 'mCurrentFocus'

# Saída exemplo:
# mCurrentFocus=Window{abc com.fast2mine.sistema/com.fast2mine.sistema.MainActivity}
```

### 2. **bundleId** (iOS)

```bash
# Liste os apps instalados:
ideviceinstaller -l

# Ou procure no Xcode: Target > General > Bundle Identifier
```

### 3. **udid** (Identificador do Dispositivo)

```bash
# Android:
adb devices

# iOS:
idevice_id -l
```

---

## Exemplo Completo no Projeto

No arquivo [`resources/shared_keywords.resource`](resources/shared_keywords.resource):

```robot
Iniciar Sessao Mobile
    Configurar Ambiente De Execucao
    Open Application    http://localhost:4723/wd/hub
    ...                 platformName=Android
    ...                 platformVersion=11.0
    ...                 deviceName=Android Emulator
    ...                 appPackage=com.fast2mine.sistema
    ...                 appActivity=.MainActivity
    ...                 automationName=UiAutomator2
    ...                 autoGrantPermissions=true
    ...                 noReset=true
    ...                 newCommandTimeout=300
```

---

## Dicas Práticas

### ✅ Boas Práticas:
- Use `noReset=true` para manter login/dados entre testes
- Configure `newCommandTimeout` alto (300s) para testes longos
- Use `autoGrantPermissions=true` para evitar pop-ups de permissão

### ⚠️ Resolução de Problemas:

**Erro: "Could not find package/activity"**
- Verifique se `appPackage` e `appActivity` estão corretos
- Confirme que o app está instalado: `adb shell pm list packages | grep fast2mine`

**Erro: "Session creation timeout"**
- Aumente `uiautomator2ServerInstallTimeout=60000`
- Verifique se o Appium está rodando: `appium --version`

**Conflito de portas ao rodar múltiplos testes:**
- Use `systemPort` diferente para cada sessão: `8200`, `8201`, `8202`

---

## Para Saber Mais

- [Documentação Oficial Appium](https://appium.io/docs/en/writing-running-appium/caps/)
- [Capabilities Android](https://github.com/appium/appium-uiautomator2-driver#capabilities)
- [Capabilities iOS](https://github.com/appium/appium-xcuitest-driver#capabilities)

---

**Conclusão:** Capabilities não são difíceis! São apenas configurações que dizem ao Appium como conectar e controlar seu app mobile. 🚀
