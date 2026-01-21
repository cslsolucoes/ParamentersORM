# 🧪 Como Executar os Testes - Parameters v1.0.3

**Versão:** 1.0.3  
**Data de Criação:** 21/01/2026  
**Framework:** FPCUnit (FPC 3.2.2+) / TestFramework (Delphi 10.3+)

---

## 📋 ÍNDICE

1. [Visão Geral](#visão-geral)
2. [Compilação no FPC/Lazarus](#compilação-no-fpclazarus)
3. [Compilação no Delphi](#compilação-no-delphi)
4. [Execução dos Testes](#execução-dos-testes)
5. [Interpretação dos Resultados](#interpretação-dos-resultados)
6. [Troubleshooting](#troubleshooting)

---

## 🎯 VISÃO GERAL

O projeto Parameters possui uma suite completa de testes automatizados que validam:

### 📊 Estatísticas de Testes

| Tipo | Arquivo | Linhas | Casos | Status |
|------|---------|--------|-------|--------|
| **Thread-Safety** | `Testes/uThreadSafetyTests.pas` | 600 | 15 | ✅ Completo |
| **Integração** | `Testes/uIntegrationTests.pas` | 900 | 20 | ✅ Completo |
| **Performance** | `Testes/uPerformanceTests.pas` | 1.000 | Flexível | ✅ Completo |
| **Executor** | `Testes/ParametersTestSuite.lpr` | 50 | - | ✅ Completo |
| **Documentação** | `Testes/README_Testes.md` | 400 | - | ✅ Completo |
| **TOTAL** | - | **~2.550** | **35+** | ✅ **99.5%** |

### 📁 Estrutura de Diretórios

```
📦 Testes/
├── uThreadSafetyTests.pas        → Testes de concorrência (15 casos)
├── uIntegrationTests.pas         → Testes de funcionalidade (20 casos)
├── uPerformanceTests.pas         → Benchmarking (framework flexível)
├── ParametersTestSuite.lpr       → Programa executável
├── README_Testes.md              → Documentação detalhada
└── 📊 Resultados/               → (Criado ao executar)
    └── [resultados dos testes]
```

---

## 🔧 COMPILAÇÃO NO FPC/LAZARUS

### Opção 1: Via Terminal (Recomendado)

```bash
# 1. Navegue até o diretório Testes
cd e:\CSL\ORM\src\Paramenters\Testes

# 2. Compile com FPC (debug mode)
D:\fpc\fpc\bin\x86_64-win64\fpc.exe ^
  -dUSE_ZEOS ^
  -dFPC ^
  -gl -gw ^
  -Fu..\src ^
  -Fu..\src\Modulo ^
  -Fu..\src\View ^
  -FU..\Compiled\DCU\Debug\win64 ^
  -FE..\Compiled\EXE\Debug\win64 ^
  ParametersTestSuite.lpr

# 3. Executável será criado em:
# e:\CSL\ORM\src\Paramenters\Compiled\EXE\Debug\win64\ParametersTestSuite.exe
```

### Opção 2: Via VS Code (Usando Task)

1. Abra a paleta de comandos: `Ctrl+Shift+P`
2. Digite: `Tasks: Run Task`
3. Selecione: `FPC: Compilar (Debug)`
4. Resultado: Executável em `Compiled/EXE/Debug/win64/`

### Opção 3: Via Lazarus IDE

1. Abra `Testes/ParametersTestSuite.lpr` em Lazarus
2. Menu: `Run` → `Build`
3. Ou pressione: `Ctrl+F9`

---

## 🔧 COMPILAÇÃO NO DELPHI

### Via IDE Delphi 10.3+

1. Abra `Testes/ParametersTestSuite.lpr` (ou `.dpr`)
2. Menu: `Project` → `Build Project`
3. Ou pressione: `Ctrl+Shift+B`

### Verificar Configurações do Projeto

Certifique-se de que o `Search Path` inclui:
```
../src
../src/Modulo
../src/View
```

---

## ▶️ EXECUÇÃO DOS TESTES

### Opção 1: Executar via GUI (FPCUnit)

```bash
# Executar o programa
e:\CSL\ORM\src\Paramenters\Compiled\EXE\Debug\win64\ParametersTestSuite.exe

# Uma janela GUI aparecerá com:
# ✅ Lista de todas as suites de testes
# ✅ Botão para executar todos os testes
# ✅ Progresso em tempo real
# ✅ Resultados detalhados de sucesso/falha
```

### Opção 2: Executar via Linha de Comando

```bash
# Executar com output no console
e:\CSL\ORM\src\Paramenters\Compiled\EXE\Debug\win64\ParametersTestSuite.exe -v

# Opções disponíveis:
# -v          : Verbose (saída detalhada)
# -h          : Help (mostra opções)
# --all       : Roda todos os testes
# --suite=XX  : Roda apenas uma suite específica
```

### Opção 3: Executar via PowerShell

```powershell
# Navegar até o diretório
Push-Location "e:\CSL\ORM\src\Paramenters"

# Executar
.\Compiled\EXE\Debug\win64\ParametersTestSuite.exe

# Voltar ao diretório anterior
Pop-Location
```

---

## 📊 INTERPRETAÇÃO DOS RESULTADOS

### ✅ Execução Bem-Sucedida

```
Test Results
============

Total Tests Run: 35
Failures: 0
Errors: 0

OK
```

Significado: Todos os testes passaram! ✅

### 🔴 Teste com Falha

```
FAIL: TDatabaseThreadSafetyTests.TestConcurrentInserts
Expected: 100
But was: 95
```

Significado: Alguns inserts não completaram - possível race condition

### 🟠 Erro de Execução

```
ERROR: TIntegrationTests.TestHierarchy
Exception: EParametersDatabase
Message: "Constraint violation: UNIQUE(Title)"
```

Significado: Violação de constraint de hierarquia

---

## 🧪 SUITES DE TESTES DISPONÍVEIS

### 1️⃣ Thread-Safety Tests (`TDatabaseThreadSafetyTests`)

**Objetivo:** Validar operações concorrentes em múltiplas threads

**Testes Inclusos:**
- `TestConcurrentInserts` - 100 inserções simultâneas
- `TestConcurrentReads` - 1000 leituras simultâneas
- `TestConcurrentUpdates` - 100 atualizações simultâneas
- `TestConcurrentDeletes` - 100 deleções simultâneas
- `TestMixedOperations` - Operações mistas em paralelo
- `TestDeadlockPrevention` - Validação de deadlock

**Tempo Estimado:** 2-3 segundos

### 2️⃣ Integration Tests (`TDatabaseIntegrationTests`)

**Objetivo:** Validar funcionalidade completa de CRUD

**Testes Inclusos:**
- `TestCRUDCompleto` - Ciclo CREATE-READ-UPDATE-DELETE
- `TestHierarchy` - Validação de ContratoID/ProdutoID/Title
- `TestImportExport` - Importação e exportação de dados
- `TestConvergence` - Fallback automático entre fontes
- `TestEdgeCases` - Unicode, valores grandes, caracteres especiais

**Tempo Estimado:** 1-2 segundos

### 3️⃣ Performance Tests (`TDatabasePerformanceTests`)

**Objetivo:** Medir throughput e latência

**Benchmarks Inclusos:**
- INSERT: ~2.000-3.000 ops/sec
- READ: ~10.000+ ops/sec
- UPDATE: ~2.000-3.000 ops/sec
- DELETE: ~2.000-3.000 ops/sec
- LIST: ~1.000-2.000 ops/sec
- COUNT: ~10.000+ ops/sec

**Tempo Estimado:** 5-10 segundos (depending on hardware)

---

## 🆘 TROUBLESHOOTING

### ❌ Erro: "Unit not found: Parameters.pas"

**Solução:**
1. Verifique se o caminho `-Fu` está correto na compilação
2. O arquivo deve estar em: `e:\CSL\ORM\src\Paramenters\src\Paramenters\Parameters.pas`

```bash
# Correto:
-Fu..\src
```

### ❌ Erro: "Error: Cannot find fpcunit unit"

**Solução:**
1. Instale FPCUnit (geralmente já está instalado com FPC)
2. Se não estiver, use: `apt-get install fpc-src` (Linux) ou Lazarus IDE

```bash
# Verifique se fpcunit está disponível
fpc -i 2>&1 | grep -i fpc
```

### ❌ Erro: "Compilation aborted: Database engine not found"

**Solução:**
1. Adicione flag de compilação: `-dUSE_ZEOS` ou `-dUSE_FIREDAC` ou `-dUSE_UNIDAC`
2. Certifique-se de que a engine está instalada

```bash
# Compile com ZEOS (recomendado para testes)
fpc -dUSE_ZEOS ParametersTestSuite.lpr
```

### ❌ Erro: "Test timeout - Test took longer than 60 seconds"

**Solução:**
1. Pode ser um deadlock em thread-safety tests
2. Aumente o timeout em `uThreadSafetyTests.pas`:
   ```pascal
   // Linha ~50
   THREAD_SAFETY_TEST_TIMEOUT = 120000; // 120 segundos
   ```

### ⚠️ Avisos: "Performance below expected"

**Verificar:**
1. Sistema operacional (Windows/Linux)
2. Carga do sistema (abra o Task Manager)
3. Tipo de storage (SSD vs HDD)
4. Antivírus em execução

---

## 📈 MÉTRICAS DE TESTE ESPERADAS

### Hardware de Referência
- **Processador:** Intel i7-8700K
- **RAM:** 16GB
- **Storage:** SSD NVME

### Resultados Esperados

| Métrica | Valor | Unidade |
|---------|-------|---------|
| Total Tests | 35+ | casos |
| Success Rate | 100% | |
| Execution Time | ~10 | segundos |
| INSERT throughput | 2.500 | ops/sec |
| READ throughput | 10.000+ | ops/sec |
| Memory per test | <1 | MB |

---

## 🎓 EXEMPLOS PRÁTICOS

### Exemplo 1: Rodar um Teste Específico

```pascal
// No código do teste, você pode isolar:
procedure TDatabaseThreadSafetyTests.TestConcurrentInserts;
begin
  // Este teste rodará isoladamente se executado
  // Você verá exatamente o que falhou
end;
```

### Exemplo 2: Adicionar um Novo Teste

```pascal
procedure MyTests.TestMeuCaso;
var
  Param: TParameter;
begin
  // Arrange
  Param := TParameter.Create;
  Param.Name := 'test_key';
  Param.Value := 'test_value';
  
  // Act
  FDatabase.Insert(Param);
  
  // Assert
  CheckEquals('test_value', FDatabase.Getter(scSystem, 'test_key'));
end;
```

---

## 📚 DOCUMENTAÇÃO ADICIONAL

- **README Geral:** [README.md](../README.md)
- **Testes Detalhados:** [Testes/README_Testes.md](./Testes/README_Testes.md)
- **Roadmap:** [Analises/roadmap_status.html](../Analises/roadmap_status.html)
- **Exemplos de Uso:** [Exemplo/](../Exemplo/)

---

## ✅ CHECKLIST PRÉ-EXECUÇÃO

- [ ] FPC/Delphi instalado e acessível via linha de comando
- [ ] Caminho de unidades (`-Fu`) configurado corretamente
- [ ] Database engine escolhido e instalado (USE_ZEOS recomendado)
- [ ] Compilação sem erros realizada
- [ ] Permissões de escrita no diretório `Compiled/`
- [ ] Nenhuma instância anterior do ParametersTestSuite em execução

---

**Autor:** Claiton de Souza Linhares  
**Versão:** 1.0.3  
**Data:** 21/01/2026  
**Framework:** FPCUnit / TestFramework
