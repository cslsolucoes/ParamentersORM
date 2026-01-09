# 🔧 Configuração FPC/Lazarus - Módulo Parameters

**Data:** 02/01/2026  
**Versão:** 1.0.0  
**Autor:** Claiton de Souza Linhares

---

## 📋 Informações do Sistema

### Caminhos Configurados

- **Lazarus:** `C:\lazarus`
- **Free Pascal:** `C:\lazarus\fpc\3.2.2`
- **Configurações:** `C:\lazarus\Configuracao`
- **Pacotes:** `C:\lazarus\Configuracao\onlinepackagemanager\packages`

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
2. Extraia em uma pasta (ex: `C:\lazarus\components\zeos`)
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

### Verificar Versão do FPC

1. **Help** → **About Lazarus**
2. Verifique a versão do FPC (deve ser 3.2.2 ou superior)

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
fpc -dUSE_ZEOS -dFPC ParamentersCSL.lpr
```

### Teste 2: Compilação com Debug

```bash
fpc -dUSE_ZEOS -dFPC -gl -gw ParamentersCSL.lpr
```

### Teste 3: Verificar Units

```bash
fpc -dUSE_ZEOS -dFPC -vu ParamentersCSL.lpr
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

- [ ] Lazarus instalado
- [ ] FPC 3.2.2 ou superior instalado
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

**Status:** 🟡 Em Adaptação  
**Última Atualização:** 02/01/2026

