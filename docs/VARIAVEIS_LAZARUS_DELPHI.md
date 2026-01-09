# 🔧 Variáveis e Macros: Delphi vs Lazarus

**Data:** 02/01/2026  
**Versão:** 1.0.0

---

## 📊 Mapeamento de Variáveis

### Delphi → Lazarus

| Delphi | Lazarus | Descrição | Exemplo |
|--------|---------|-----------|---------|
| `$(Config)` | `$(BuildMode)` | Configuração de build | `Debug`, `Release` |
| `$(Platform)` | `$(TargetCPU)-$(TargetOS)` | Plataforma alvo | `i386-win32`, `x86_64-win64` |
| `$(Platform)` | `$(TargetOS)` | Sistema operacional | `win32`, `win64`, `linux`, `darwin` |
| `$(Platform)` | `$(TargetCPU)` | Arquitetura CPU | `i386`, `x86_64`, `arm`, `aarch64` |
| `$(BDS)` | `$(LazarusDir)` | Diretório de instalação | `C:\lazarus` |
| `$(BDSBIN)` | `$(LazarusDir)\fpc\$(FPCVersion)\bin\$(TargetCPU)-$(TargetOS)` | Diretório binário | `C:\lazarus\fpc\3.2.2\bin\i386-win32` |
| `$(DCC_ExeOutput)` | `$(Target)` | Diretório de saída do executável | `Compiled\EXE\...` |
| `$(DCC_DcuOutput)` | `$(UnitOutputDirectory)` | Diretório de saída das units | `Compiled\DCU\...` |
| `$(DCC_DcpOutput)` | *(Não disponível)* | Diretório de saída dos packages | - |

---

## 🔍 Variáveis Disponíveis no Lazarus

### Variáveis do Sistema

| Variável | Descrição | Exemplo |
|----------|-----------|---------|
| `$(BuildMode)` | Modo de build atual | `Default`, `Debug`, `Release` |
| `$(TargetCPU)` | Arquitetura da CPU | `i386`, `x86_64`, `arm`, `aarch64` |
| `$(TargetOS)` | Sistema operacional | `win32`, `win64`, `linux`, `darwin` |
| `$(TargetCPU)-$(TargetOS)` | Plataforma completa | `i386-win32`, `x86_64-win64` |
| `$(LazarusDir)` | Diretório do Lazarus | `C:\lazarus` |
| `$(FPCVersion)` | Versão do FPC | `3.2.2` |
| `$(ProjOutDir)` | Diretório de saída do projeto | `Compiled\EXE\...` |
| `$(ProjPath)` | Caminho do projeto | `E:\CSL\ParamentersORM\` |
| `$(ProjName)` | Nome do projeto | `ParamentersCSL` |
| `$(ProjFile)` | Arquivo do projeto | `ParamentersCSL.lpi` |
| `$(ProjUnitPath)` | Caminho das units | `src\View;src\Paramenters\...` |
| `$(Target)` | Caminho do executável | `Compiled\EXE\...\ParamentersCSL` |
| `$(UnitOutputDirectory)` | Diretório de saída das units | `Compiled\DCU\...` |

---

## ⚠️ Limitações do Lazarus

### ❌ Não é Possível Criar Variáveis Customizadas

No Lazarus, **não é possível criar variáveis customizadas** diretamente no arquivo `.lpi` como no Delphi. O Lazarus não suporta:

- Variáveis definidas pelo usuário
- Macros customizadas
- Variáveis de ambiente do projeto

### ✅ Soluções Alternativas

#### 1. Usar Variáveis do Sistema Existentes

Use as variáveis disponíveis para criar estruturas compatíveis:

```xml
<!-- Delphi -->
<DCC_ExeOutput>.\Compiled\EXE\$(Config)\$(Platform)</DCC_ExeOutput>

<!-- Lazarus (equivalente) -->
<Target>
  <Filename Value="Compiled\EXE\$(BuildMode)\$(TargetCPU)-$(TargetOS)\ParamentersCSL"/>
</Target>
```

#### 2. Usar Estrutura de Diretórios Fixa

Se precisar de uma estrutura específica, use caminhos fixos ou combine variáveis:

```xml
<!-- Estrutura compatível com Delphi -->
<Filename Value="Compiled\EXE\$(BuildMode)\$(TargetOS)\ParamentersCSL"/>
```

#### 3. Usar BuildModes com Configurações Específicas

Cada BuildMode pode ter suas próprias configurações:

```xml
<BuildModes>
  <Item Name="Debug">
    <CompilerOptions>
      <Target>
        <Filename Value="Compiled\EXE\Debug\$(TargetOS)\ParamentersCSL"/>
      </Target>
    </CompilerOptions>
  </Item>
  <Item Name="Release">
    <CompilerOptions>
      <Target>
        <Filename Value="Compiled\EXE\Release\$(TargetOS)\ParamentersCSL"/>
      </Target>
    </CompilerOptions>
  </Item>
</BuildModes>
```

---

## 📁 Estrutura de Diretórios Recomendada

### Compatível com Delphi e Lazarus

```
Compiled\
├── EXE\
│   ├── Debug\
│   │   ├── win32\          # Lazarus: $(TargetOS)
│   │   └── win64\          # Lazarus: $(TargetOS)
│   └── Release\
│       ├── win32\
│       └── win64\
├── DCU\
│   ├── Debug\
│   │   ├── win32\
│   │   └── win64\
│   └── Release\
│       ├── win32\
│       └── win64\
└── DCP\                     # Apenas Delphi
    ├── Debug\
    │   ├── Win32\
    │   └── Win64\
    └── Release\
        ├── Win32\
        └── Win64\
```

### Configuração no Lazarus (`.lpi`)

```xml
<Target>
  <Filename Value="Compiled\EXE\$(BuildMode)\$(TargetOS)\ParamentersCSL"/>
</Target>
<SearchPaths>
  <UnitOutputDirectory Value="Compiled\DCU\$(BuildMode)\$(TargetOS)"/>
</SearchPaths>
```

### Configuração no Delphi (`.dproj`)

```xml
<DCC_ExeOutput>.\Compiled\EXE\$(Config)\$(Platform)</DCC_ExeOutput>
<DCC_DcuOutput>.\Compiled\DCU\$(Config)\$(Platform)</DCC_DcuOutput>
<DCC_DcpOutput>.\Compiled\DCP\$(Config)\$(Platform)</DCC_DcpOutput>
```

---

## 🎯 Exemplos Práticos

### Exemplo 1: Estrutura Simples (apenas OS)

**Lazarus:**
```xml
<Filename Value="Compiled\EXE\$(BuildMode)\$(TargetOS)\ParamentersCSL"/>
```

**Resultado:**
- Debug Win32: `Compiled\EXE\Debug\win32\ParamentersCSL.exe`
- Release Win64: `Compiled\EXE\Release\win64\ParamentersCSL.exe`

### Exemplo 2: Estrutura Completa (CPU-OS)

**Lazarus:**
```xml
<Filename Value="Compiled\EXE\$(BuildMode)\$(TargetCPU)-$(TargetOS)\ParamentersCSL"/>
```

**Resultado:**
- Debug Win32: `Compiled\EXE\Debug\i386-win32\ParamentersCSL.exe`
- Release Win64: `Compiled\EXE\Release\x86_64-win64\ParamentersCSL.exe`

### Exemplo 3: Compatível com Delphi

**Lazarus:**
```xml
<Filename Value="Compiled\EXE\$(BuildMode)\$(TargetOS)\ParamentersCSL_$(TargetOS)"/>
```

**Resultado:**
- Debug Win32: `Compiled\EXE\Debug\win32\ParamentersCSL_win32.exe`
- Release Win64: `Compiled\EXE\Release\win64\ParamentersCSL_win64.exe`

---

## 📝 Notas Importantes

1. **Variáveis são substituídas em tempo de compilação** pelo Lazarus
2. **Não é possível criar variáveis customizadas** no `.lpi`
3. **Use BuildModes** para diferentes configurações
4. **Combine variáveis existentes** para criar estruturas complexas
5. **Mantenha compatibilidade** entre Delphi e Lazarus usando estruturas similares

---

## 🔗 Referências

- [Lazarus IDE Documentation - Macros](https://wiki.lazarus.freepascal.org/IDE_Macros)
- [Free Pascal Compiler - Target OS](https://www.freepascal.org/docs-html/prog/progse5.html)
- [Delphi MSBuild Variables](https://docwiki.embarcadero.com/RADStudio/Alexandria/en/MSBuild_Variables)

---

**Autor:** Claiton de Souza Linhares  
**Data:** 02/01/2026  
**Versão:** 1.0.0

