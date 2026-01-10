# 🔧 Configuração FPC/Lazarus - Módulo Parameters

**Data:** 02/01/2026  
**Versão:** 1.0.0  
**Autor:** Claiton de Souza Linhares

---

## 📋 Informações do Sistema

### Caminhos Configurados

- **Base de Instalação:** `D:\fpc`
- **Lazarus IDE:** `D:\fpc\lazarus` (versão 4.4)
- **Free Pascal Compiler (FPC):** `D:\fpc\fpc` (versão 3.2.2)
- **Binários FPC:** `D:\fpc\fpc\bin\x86_64-win64` (64-bit)
- **Build Date:** 2026-01-10 01:46
- **Revision:** lazarus_4_4
- **Código-fonte FPC:** `D:\fpc\fpcsrc`
- **Configurações Lazarus:** `D:\fpc\config_lazarus`
- **Pacotes OPM:** `D:\fpc\config_lazarus\onlinepackagemanager\packages`
- **Componentes CCR:** `D:\fpc\ccr`
- **Cross-compilation:** `D:\fpc\cross`
- **Projetos:** `D:\fpc\projects`

---

## 🚀 Passo a Passo para Configurar

### 1. Instalar Zeos Library

O módulo Parameters requer a biblioteca **Zeos** para acesso a banco de dados no FPC.

#### Opção A: Via Online Package Manager (Recomendado)

1. Abra o Lazarus
2. Vá em **Package** → **Online Package Manager**
3. Procure por **"Zeos"** ou **"zeoslib"**
4. Instale o pacote **ZeosLib**
5. Recompile o IDE se solicitado

#### Opção B: Instalação Manual

1. Baixe Zeos de: https://sourceforge.net/projects/zeoslib/
2. Extraia em uma pasta (ex: `D:\fpc\ccr\zeos` ou `D:\fpc\lazarus\components\zeos`)
3. No Lazarus: **Package** → **Open Package File**
4. Abra `packages\lazarus\zeoslib.lpk`
5. Clique em **Compile**
6. Clique em **Install**

### 2. Configurar Diretivas de Compilação

O arquivo `src/ParamentersORM.Defines.inc` já está configurado para FPC:

```pascal
{$DEFINE USE_ZEOS}  // Já está ativo para FPC
```

**Nota:** FireDAC não está disponível no FPC, então apenas Zeos ou UniDAC podem ser usados.

### 3. Criar Projeto no Lazarus

#### Opção A: Usar arquivo .lpr existente

1. Abra o Lazarus
2. **File** → **Open**
3. Selecione `ParamentersCSL.lpr`
4. O Lazarus criará automaticamente o arquivo `.lpi`

#### Opção B: Criar novo projeto

1. **File** → **New** → **Application**
2. Salve como `ParamentersCSL.lpr`
3. Adicione as units na seção `uses`:
   ```pascal
   uses
     Interfaces, Forms, LResources,
     Parameters.Consts in 'src/Paramenters/Commons/Parameters.Consts.pas',
     Parameters.Exceptions in 'src/Paramenters/Commons/Parameters.Exceptions.pas',
     Parameters.Types in 'src/Paramenters/Commons/Parameters.Types.pas',
     Parameters.Database in 'src/Paramenters/Database/Parameters.Database.pas',
     Parameters.Inifiles in 'src/Paramenters/IniFiles/Parameters.Inifiles.pas',
     Parameters.JsonObject in 'src/Paramenters/JsonObject/Parameters.JsonObject.pas',
     Parameters.Intefaces in 'src/Paramenters/Parameters.Intefaces.pas',
     Parameters in 'src/Paramenters/Parameters.pas',
     ufrmParamenters_Test in 'src/View/ufrmParamenters_Test.pas';
   ```

### 4. Configurar Caminhos de Bibliotecas

1. **Project** → **Project Options**
2. Aba **Compiler Options** → **Paths**
3. Adicione os caminhos:
   - **Other unit files (-Fu):**
     - `src/Paramenters`
     - `src/Paramenters/Commons`
     - `src/Paramenters/Database`
     - `src/Paramenters/IniFiles`
     - `src/Paramenters/JsonObject`
     - `src/View`
   - **Include files (-Fi):**
     - `src`

### 5. Configurar Diretivas de Compilação

1. **Project** → **Project Options**
2. Aba **Compiler Options** → **Other**
3. Em **Custom Options**, adicione:
   ```
   -dUSE_ZEOS
   -dFPC
   ```

### 6. Compilar o Projeto

1. **Run** → **Build** (ou F9)
2. Verifique se há erros de compilação
3. Se houver erros, consulte a seção **Problemas Comuns** abaixo

---

## 🔍 Verificações

### Verificar se Zeos está Instalado

1. **Package** → **Installed Packages**
2. Procure por **"ZeosLib"** ou **"Zeos"**
3. Se não estiver instalado, instale via Online Package Manager

### Verificar Versões

1. **Help** → **About Lazarus**
2. Verifique as versões:
   - **Lazarus:** 4.4 (detectado)
   - **FPC:** 3.2.2 (deve ser 3.2.2 ou superior)
   - **Target Architectures:** x86_64-win64-win32/win64

---

## ⚠️ Problemas Comuns

### Erro: "Unit ZConnection not found"

**Causa:** Zeos não está instalado ou não está no caminho.

**Solução:**
1. Instale Zeos via Online Package Manager
2. Verifique se o caminho de Zeos está em **Project Options** → **Paths**

### Erro: "Unit Vcl.Forms not found"

**Causa:** O código ainda está usando unidades VCL do Delphi.

**Solução:**
1. Verifique se o arquivo tem `{$IFDEF FPC}` nas seções `uses`
2. Os arquivos já foram adaptados, mas verifique se não há referências diretas a `Vcl.*`

### Erro: "Unit System.IOUtils not found"

**Causa:** `System.IOUtils` não existe no FPC.

**Solução:**
1. O código já foi adaptado para usar `SysUtils` no FPC
2. Verifique se não há uso direto de `TPath` no código

### Erro: "Unit ComObj not found" (Linux/macOS)

**Causa:** `ComObj` e `ActiveX` são específicos do Windows.

**Solução:**
1. O código já está condicionado com `{$IFDEF WINDOWS}`
2. Funcionalidades de Access (.mdb) só funcionam no Windows

---

## 📝 Diferenças entre Delphi e FPC

### Units

| Delphi | FPC |
|--------|-----|
| `Vcl.Forms` | `Forms` |
| `System.SysUtils` | `SysUtils` |
| `System.Classes` | `Classes` |
| `Data.DB` | `DB` |
| `System.JSON` | `fpjson` |
| `System.IniFiles` | `IniFiles` |
| `System.SyncObjs` | `SyncObjs` |
| `System.StrUtils` | `StrUtils` |

### Funcionalidades Específicas do Windows

- **Access Database (.mdb):** Apenas Windows (usa ADOX)
- **SetEnvironmentVariable:** Apenas Windows
- **Registry:** Apenas Windows

### Engines de Banco de Dados

- **FireDAC:** ❌ Não disponível no FPC
- **UniDAC:** ✅ Disponível (se tiver licença)
- **Zeos:** ✅ Disponível (open-source, recomendado)

---

## 🧪 Testando a Compilação

### Teste 1: Compilação Básica

```bash
# No terminal do Lazarus ou linha de comando
# Usando o caminho completo do FPC
D:\fpc\fpc\bin\x86_64-win64\fpc.exe -dUSE_ZEOS -dFPC ParamentersCSL.lpr

# Ou se o PATH estiver configurado:
fpc -dUSE_ZEOS -dFPC ParamentersCSL.lpr
```

### Teste 2: Compilação com Debug

```bash
D:\fpc\fpc\bin\x86_64-win64\fpc.exe -dUSE_ZEOS -dFPC -gl -gw ParamentersCSL.lpr
```

### Teste 3: Verificar Units

```bash
D:\fpc\fpc\bin\x86_64-win64\fpc.exe -dUSE_ZEOS -dFPC -vu ParamentersCSL.lpr
```

### Teste 4: Verificar Versão do FPC

```bash
D:\fpc\fpc\bin\x86_64-win64\fpc.exe -iV
# Deve retornar: 3.2.2
```

---

## 📚 Recursos Adicionais

### Documentação Zeos

- Site: https://sourceforge.net/projects/zeoslib/
- Documentação: https://sourceforge.net/p/zeoslib/wiki/Home/

### Documentação FPC

- Site: https://www.freepascal.org/
- Documentação: https://www.freepascal.org/docs.html

### Documentação Lazarus

- Site: https://www.lazarus-ide.org/
- Documentação: https://wiki.lazarus.freepascal.org/

---

## ✅ Checklist de Configuração

- [x] Lazarus 4.4 instalado (detectado)
- [x] FPC 3.2.2 instalado (detectado)
- [ ] Zeos Library instalado
- [ ] Arquivo `.lpr` criado/adaptado
- [ ] Caminhos de bibliotecas configurados
- [ ] Diretivas de compilação configuradas (`USE_ZEOS`, `FPC`)
- [ ] Projeto compila sem erros
- [ ] Formulários abrem corretamente
- [ ] Conexão com banco de dados funciona

---

## 🎯 Próximos Passos

1. ✅ Análise de compatibilidade concluída
2. ✅ Código adaptado para FPC
3. ⏳ Criar arquivo `.lpi` no Lazarus
4. ⏳ Testar compilação
5. ⏳ Testar funcionalidades básicas
6. ⏳ Documentar diferenças específicas

---

---

## 📁 Estrutura de Instalação Detectada

### Estrutura Completa em `D:\fpc`

```
D:\fpc\
├── fpc\                      # Free Pascal Compiler
│   ├── bin\
│   │   └── x86_64-win64\     # Binários 64-bit
│   │       ├── fpc.exe       # Compilador principal
│   │       ├── ppcx64.exe   # Compilador cross-platform
│   │       └── ...
│   ├── units\                # Units compiladas
│   │   ├── i386-win32\       # Units 32-bit
│   │   ├── x86_64-win64\     # Units 64-bit
│   │   └── x86_64-linux\     # Units Linux (cross-compilation)
│   └── ...
├── fpcsrc\                   # Código-fonte do FPC
├── lazarus\                  # IDE Lazarus
│   ├── lazarus.exe           # Executável principal
│   ├── components\           # Componentes do Lazarus
│   └── ...
├── config_lazarus\          # Configurações do Lazarus
│   ├── onlinepackagemanager\ # Pacotes OPM
│   └── ...
├── ccr\                      # Componentes e bibliotecas
├── cross\                    # Ferramentas de cross-compilation
│   ├── bin\
│   └── lib\
├── packages.fppkg\          # Pacotes FPC
├── projects\                # Projetos de exemplo
└── tmp\                     # Arquivos temporários
```

### Plataformas Disponíveis

- ✅ **x86_64-win64** (Windows 64-bit) - Principal
- ✅ **i386-win32** (Windows 32-bit) - Units disponíveis
- ✅ **x86_64-linux** (Linux 64-bit) - Cross-compilation disponível

---

**Status:** ✅ Configurado e Funcional  
**Última Atualização:** 02/01/2026  
**Versão FPC:** 3.2.2  
**Versão Lazarus:** 4.4 (Build: 2026-01-10 01:46, Revision: lazarus_4_4)  
**Localização:** D:\fpc

