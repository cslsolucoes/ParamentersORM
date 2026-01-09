# 🔍 Análise de Compatibilidade FPC/Lazarus - Módulo Parameters

**Data:** 02/01/2026  
**Versão:** 1.0.0  
**Autor:** Claiton de Souza Linhares

---

## 📋 Resumo Executivo

Este documento analisa o projeto **ParametersORM** para compatibilidade com **Free Pascal Compiler (FPC)** e **Lazarus IDE**.

### Status Atual

- ✅ **Código Core:** Possui diretivas `{$IFDEF FPC}` em todos os arquivos
- ✅ **Defines.inc:** Tem lógica de detecção automática para FPC
- ✅ **Projeto Principal:** Adaptado para LCL (`ParamentersCSL.lpr` criado)
- ✅ **Formulários:** Adaptados para LCL (uses condicionais)
- ✅ **Windows API:** `ComObj`, `ActiveX`, `Winapi.Windows` condicionados apenas para Windows
- ✅ **Arquivo .lpi:** Criado para Lazarus
- ✅ **Documentação:** Guias de configuração criados

---

## 🔧 Problemas Identificados

### 1. Projeto Principal (ParamentersCSL.dpr)

**Problema:**
```pascal
uses
  Vcl.Forms,  // ❌ Não existe no FPC
  ...
```

**Solução:**
```pascal
uses
{$IFDEF FPC}
  Forms, Interfaces, LResources,
{$ELSE}
  Vcl.Forms,
{$ENDIF}
  ...
```

### 2. Formulários (ufrmParamenters_Test.pas, ufrmConfigCRUD.pas)

**Problema:**
```pascal
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.StrUtils, System.Win.Registry,  // ❌ System.Win.Registry não existe no FPC
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.Mask, Vcl.FileCtrl,
```

**Solução:**
```pascal
uses
{$IFDEF FPC}
  LCLType, LCLIntf, SysUtils, Variants, Classes, StrUtils,
  Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, Grids, DBGrids, ComCtrls, Mask, FileCtrl,
{$ELSE}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.StrUtils, System.Win.Registry,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.Mask, Vcl.FileCtrl,
{$ENDIF}
```

### 3. Parameters.Database.pas - Windows API

**Problema:**
```pascal
{$ELSE}
  System.SysUtils, System.Classes, System.Variants, Data.DB,
  System.JSON, System.DateUtils, System.StrUtils, System.Math, System.TypInfo,
  System.IOUtils,
  System.SyncObjs,
  ComObj, ActiveX,  // ❌ Não existe no FPC/Linux
  Winapi.Windows,   // ❌ Não existe no FPC/Linux
{$ENDIF}
```

**Solução:**
```pascal
{$IFDEF FPC}
  SysUtils, Classes, DB, fpjson, Math, TypInfo, SyncObjs,
  {$IFDEF WINDOWS}
  ComObj, ActiveX, Windows,  // Apenas no Windows
  {$ENDIF}
{$ELSE}
  System.SysUtils, System.Classes, System.Variants, Data.DB,
  System.JSON, System.DateUtils, System.StrUtils, System.Math, System.TypInfo,
  System.IOUtils,
  System.SyncObjs,
  ComObj, ActiveX,
  Winapi.Windows,
{$ENDIF}
```

### 4. System.IOUtils (TPath)

**Problema:** `System.IOTools` não existe no FPC. Usar `SysUtils` no FPC.

**Solução:**
```pascal
{$IFDEF FPC}
  // TPath não existe, usar ExtractFilePath, ExtractFileName, etc.
{$ELSE}
  System.IOUtils,  // TPath
{$ENDIF}
```

### 5. System.Win.Registry

**Problema:** Não existe no FPC. Usar `Registry` do FPC.

**Solução:**
```pascal
{$IFDEF FPC}
  Registry,  // Registry do FPC
{$ELSE}
  System.Win.Registry,
{$ENDIF}
```

---

## 📝 Arquivos que Precisam de Adaptação

### Prioridade ALTA

1. **ParamentersCSL.dpr** - Projeto principal
2. **src/View/ufrmParamenters_Test.pas** - Formulário principal
3. **src/View/ufrmConfigCRUD.pas** - Formulário CRUD
4. **src/Paramenters/Database/Parameters.Database.pas** - Windows API

### Prioridade MÉDIA

5. **src/Paramenters/IniFiles/Parameters.Inifiles.pas** - Verificar System.IOUtils
6. **src/Paramenters/JsonObject/Parameters.JsonObject.pas** - Verificar System.IOUtils

---

## 🛠️ Plano de Ação

### Fase 1: Adaptar Projeto Principal

1. Criar arquivo `.lpi` (Lazarus Project)
2. Adaptar `ParamentersCSL.dpr` para FPC
3. Adaptar uses dos formulários

### Fase 2: Adaptar Código Core

1. Adaptar `Parameters.Database.pas` (Windows API)
2. Verificar `Parameters.Inifiles.pas`
3. Verificar `Parameters.JsonObject.pas`

### Fase 3: Testes

1. Compilar no Lazarus
2. Testar funcionalidades básicas
3. Documentar diferenças

---

## 📦 Dependências FPC/Lazarus

### Bibliotecas Necessárias

1. **Zeos Library** (para acesso a banco de dados)
   - Disponível via Online Package Manager do Lazarus
   - Ou baixar de: https://sourceforge.net/projects/zeoslib/

2. **Synapse** (para LDAP, se necessário)
   - Disponível via Online Package Manager

### Configuração do Lazarus

1. Abrir Lazarus
2. Instalar Zeos via Package Manager
3. Configurar caminhos de bibliotecas
4. Compilar projeto

---

## 🔍 Verificações Necessárias

### 1. Verificar se Zeos está instalado

```pascal
{$IFDEF USE_ZEOS}
  {$IFDEF FPC}
    // Verificar se ZConnection, ZDataset estão disponíveis
  {$ENDIF}
{$ENDIF}
```

### 2. Verificar compatibilidade de tipos

- `System.Variants` → `Variants` (FPC)
- `System.Classes` → `Classes` (FPC)
- `Data.DB` → `DB` (FPC)
- `System.JSON` → `fpjson` (FPC)

### 3. Verificar métodos específicos do Windows

- `CreateAccessDatabase` - Usa ADOX (apenas Windows)
- `SetEnvironmentVariable` - Windows API
- `TRegistry` - Windows Registry

---

## 📚 Próximos Passos

1. ✅ Criar este documento de análise
2. ⏳ Adaptar projeto principal
3. ⏳ Adaptar formulários
4. ⏳ Adaptar código core
5. ⏳ Criar arquivo .lpi
6. ⏳ Testar compilação
7. ⏳ Documentar diferenças

---

**Status:** 🟡 Em Análise  
**Próxima Ação:** Adaptar projeto principal para FPC

