# 🏰 Configuração do Castle Engine

**Data:** 02/01/2026  
**Versão:** 1.0.0

---

## 📋 O que é o Castle Engine?

O **Castle Game Engine** é um framework de desenvolvimento de jogos 3D para Pascal/Object Pascal, compatível com Free Pascal e Delphi. Ele fornece:

- ✅ Renderização 3D (OpenGL, Vulkan)
- ✅ Física (usando Physics Integration)
- ✅ Áudio (OpenAL)
- ✅ Input (teclado, mouse, joystick, touch)
- ✅ Multi-plataforma (Windows, Linux, macOS, Android, iOS)
- ✅ Editor visual integrado

---

## 🔧 Instalação

### 1. Baixar o Castle Engine

1. Acesse: https://castle-engine.io/download
2. Baixe a versão para Windows
3. Extraia em um local de sua preferência (ex: `D:\castle-engine`)

### 2. Configurar Variável de Ambiente

**Windows (PowerShell como Administrador):**

```powershell
# Definir variável de ambiente do sistema
[System.Environment]::SetEnvironmentVariable("CASTLE_ENGINE_PATH", "D:\castle-engine", "Machine")

# Ou apenas para a sessão atual:
$env:CASTLE_ENGINE_PATH = "D:\castle-engine"
```

**Windows (CMD como Administrador):**

```cmd
setx CASTLE_ENGINE_PATH "D:\castle-engine" /M
```

**Verificar se foi configurado:**

```powershell
echo $env:CASTLE_ENGINE_PATH
```

### 3. Adicionar ao PATH

Adicione o caminho do build-tool ao PATH do sistema:

```powershell
# Adicionar ao PATH do sistema
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$newPath = "$currentPath;D:\castle-engine\tools\build-tool"
[System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
```

---

## ⚙️ Configuração no Cursor/VSCode

As configurações já foram adicionadas ao `settings.json`:

### Configurações Aplicadas:

1. **Caminhos de Busca (searchPaths):**
   - `${env:CASTLE_ENGINE_PATH}/src`
   - `${env:CASTLE_ENGINE_PATH}/tools/build-tool/data/units`

2. **IntelliSense (includePaths):**
   - Mesmos caminhos adicionados para autocomplete

3. **Variáveis de Ambiente do Terminal:**
   - `CASTLE_ENGINE_PATH` configurado
   - `CASTLE_FPC` apontando para o FPC
   - PATH atualizado com build-tool

4. **Configurações Específicas do Castle Engine:**
   ```json
   "castleEngine.path": "${env:CASTLE_ENGINE_PATH}",
   "castleEngine.buildTool": "${env:CASTLE_ENGINE_PATH}/tools/build-tool/castle-engine.exe",
   "castleEngine.editor": "${env:CASTLE_ENGINE_PATH}/bin/castle-editor.exe",
   "castleEngine.enabled": false,
   "castleEngine.platforms": ["win64", "linux", "android", "ios"]
   ```

---

## 🚀 Como Usar

### Habilitar Castle Engine no Projeto

1. **Defina a variável de ambiente `CASTLE_ENGINE_PATH`** (veja seção Instalação)

2. **Habilite no settings.json:**
   ```json
   "castleEngine.enabled": true
   ```

3. **Recarregue a janela do Cursor:**
   - `Ctrl+Shift+P` → "Reload Window"

### Compilar um Projeto Castle Engine

**Via Terminal:**

```powershell
# No diretório do projeto Castle Engine:
castle-engine compile

# Para uma plataforma específica:
castle-engine compile --os=win64
castle-engine compile --os=linux
castle-engine compile --os=android

# Modo Release:
castle-engine compile --mode=release
```

**Via Build Task (se configurado):**

- `Ctrl+Shift+B` → Selecionar task "Castle Engine: Compile"

### Criar um Novo Projeto Castle Engine

```powershell
# Criar projeto básico:
castle-engine generate-program MyGame

# Criar projeto 3D:
castle-engine generate-program My3DGame --template=3d_fps_game
```

---

## 📝 Exemplo de Uso no Código

### Exemplo 1: Programa Básico

```pascal
program MyGame;

uses
  CastleWindow, CastleApplicationProperties, CastleLog;

var
  Window: TCastleWindowBase;
begin
  ApplicationProperties.OnWarning.Add(@OnWarningWrite);
  
  Window := TCastleWindowBase.Create(Application);
  Window.Open;
  Application.Run;
end.
```

### Exemplo 2: Usando Units do Castle Engine

```pascal
uses
  CastleWindow,
  CastleScene,
  CastleViewport,
  CastleVectors,
  CastleTransform,
  CastleFilesUtils,
  CastleApplicationProperties;
```

---

## 🔍 Verificações

### Verificar Instalação

```powershell
# Verificar se o build-tool está no PATH:
castle-engine --version

# Verificar variável de ambiente:
echo $env:CASTLE_ENGINE_PATH

# Verificar se o FPC está configurado:
castle-engine --compiler-version
```

### Verificar Configuração no Cursor

1. Abra um arquivo `.pas` que use units do Castle Engine
2. Verifique se há autocomplete funcionando
3. Verifique se não há erros de "unit not found"

---

## 🎮 Integração com o Projeto Atual

### Usar Castle Engine em um Projeto Separado

O Castle Engine é principalmente para desenvolvimento de jogos. Se você quiser usar em um projeto separado:

1. Crie um novo diretório para o projeto de jogo
2. Configure o Castle Engine nesse projeto
3. Use o ParametersORM como biblioteca de configuração para o jogo

### Exemplo: Usar Parameters no Jogo

```pascal
uses
  Parameters,  // Seu módulo Parameters
  CastleWindow;

var
  Window: TCastleWindowBase;
  Params: IParameters;
begin
  // Carregar parâmetros do jogo
  Params := TParameters.NewInifiles
    .FilePath('game_config.ini')
    .Section('Game');
  
  // Usar parâmetros
  Window.Width := StrToInt(Params.Get('window_width').Value);
  Window.Height := StrToInt(Params.Get('window_height').Value);
  
  Window.Open;
  Application.Run;
end.
```

---

## 🐛 Solução de Problemas

### Problema: "castle-engine: command not found"

**Solução:**
1. Verifique se `CASTLE_ENGINE_PATH` está configurado
2. Adicione `D:\castle-engine\tools\build-tool` ao PATH
3. Reinicie o terminal/Cursor

### Problema: "Unit not found: CastleWindow"

**Solução:**
1. Verifique se `CASTLE_ENGINE_PATH` está configurado corretamente
2. Verifique se os caminhos estão no `fpc.searchPaths` do settings.json
3. Recarregue a janela do Cursor

### Problema: IntelliSense não funciona com Castle Engine

**Solução:**
1. Verifique se `castleEngine.enabled` está `true` no settings.json
2. Verifique se os caminhos estão em `pascal.intellisense.includePaths`
3. Recarregue a janela: `Ctrl+Shift+P` → "Reload Window"

---

## 📚 Recursos Adicionais

### Documentação Oficial
- **Site:** https://castle-engine.io
- **Manual:** https://castle-engine.io/manual_intro.php
- **API Reference:** https://castle-engine.io/apidoc/html/

### Exemplos
- **Exemplos Oficiais:** https://github.com/castle-engine/castle-engine/tree/master/examples
- **Demos:** https://castle-engine.io/demos.php

### Comunidade
- **Fórum:** https://forum.castle-engine.io
- **GitHub:** https://github.com/castle-engine/castle-engine

---

## ✅ Checklist de Configuração

- [ ] Castle Engine baixado e extraído
- [ ] Variável `CASTLE_ENGINE_PATH` configurada
- [ ] Build-tool adicionado ao PATH
- [ ] Configurações no `settings.json` aplicadas
- [ ] `castleEngine.enabled` definido como `true` (se necessário)
- [ ] Cursor recarregado
- [ ] Testado com `castle-engine --version`
- [ ] IntelliSense funcionando com units do Castle Engine

---

## 🎯 Status Atual

**Castle Engine:** ✅ **CONFIGURADO E FUNCIONANDO**

### ✅ Configuração Concluída (02/01/2026)

- ✅ **Castle Engine instalado:** `D:\castle-engine`
- ✅ **Versão:** 7.0-alpha.3.snapshot
- ✅ **Variável de ambiente:** `CASTLE_ENGINE_PATH` configurada para o usuário
- ✅ **Build-tool:** Adicionado ao PATH do usuário
- ✅ **Configurações VSCode/Cursor:** Aplicadas em `.vscode/settings.json`
- ✅ **Tasks de build:** Configuradas em `.vscode/tasks.json`
- ✅ **Caminhos de busca:** Configurados para IntelliSense
- ✅ **Verificação:** `castle-engine --version` funcionando

### 📋 Tasks Disponíveis

As seguintes tasks foram adicionadas ao `.vscode/tasks.json`:

1. **Castle Engine: Verificar Versão** - Verifica a versão instalada
2. **Castle Engine: Compilar (Debug)** - Compila em modo debug
3. **Castle Engine: Compilar (Release)** - Compila em modo release
4. **Castle Engine: Limpar Projeto** - Limpa arquivos compilados

### 🚀 Como Usar

1. **Via Terminal:**
   ```powershell
   castle-engine compile
   ```

2. **Via Build Tasks:**
   - `Ctrl+Shift+B` → Selecionar task do Castle Engine

3. **Para habilitar no projeto (se necessário):**
   - Defina `"castleEngine.enabled": true` no `.vscode/settings.json`
   - Recarregue o Cursor: `Ctrl+Shift+P` → "Reload Window"

---

**Nota:** O Castle Engine é opcional e não é necessário para o projeto ParametersORM atual. Ele foi configurado caso você queira criar projetos de jogos separados usando o mesmo ambiente de desenvolvimento.
