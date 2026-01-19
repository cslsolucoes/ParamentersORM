# Exemplos: Buscar Parâmetro Específico

Este documento apresenta diferentes formas de buscar um parâmetro específico usando o módulo Parameters.

## 📋 Índice

1. [Buscar com IParametersDatabase](#1-buscar-com-iparametersdatabase)
2. [Verificar se existe antes de buscar](#2-verificar-se-existe-antes-de-buscar)
3. [Buscar com Fluent Interface](#3-buscar-com-fluent-interface)
4. [Buscar com filtros (ContratoID/ProdutoID)](#4-buscar-com-filtros-contratoidprodutoid)
5. [Buscar com IParameters (fallback automático)](#5-buscar-com-iparameters-fallback-automático)
6. [Buscar em fonte específica](#6-buscar-em-fonte-específica)
7. [Tratamento de erros](#7-tratamento-de-erros)
8. [Buscar múltiplos parâmetros](#8-buscar-múltiplos-parâmetros)

---

## 1. Buscar com IParametersDatabase

Busca direta usando a interface de banco de dados.

```pascal
var DB: IParametersDatabase;
var Param: TParameter;

DB := TParameters.NewDatabase;
DB.DatabaseType('SQLite')
  .Database('E:\Pacote\ORM\Data\Config.db')
  .TableName('config')
  .Connect;

// Busca o parâmetro
Param := DB.Get('database_host');

if Assigned(Param) then
begin
  WriteLn('Nome: ' + Param.Name);
  WriteLn('Valor: ' + Param.Value);
  Param.Free; // IMPORTANTE: Liberar o objeto
end
else
begin
  WriteLn('Parâmetro não encontrado!');
end;
```

**Características:**
- ✅ Busca direta no banco de dados
- ✅ Retorna `nil` se não encontrar (não lança exceção)
- ⚠️ **Sempre libere o objeto** com `Param.Free` após usar

---

## 2. Verificar se existe antes de buscar

Verifica se o parâmetro existe antes de buscar (otimização).

```pascal
var DB: IParametersDatabase;
var Param: TParameter;
var LExists: Boolean;

// Verifica se existe
LExists := DB.Exists('api_timeout');

if LExists then
begin
  // Busca apenas se existir
  Param := DB.Get('api_timeout');
  try
    WriteLn('Valor: ' + Param.Value);
  finally
    Param.Free;
  end;
end
else
begin
  WriteLn('Parâmetro não existe!');
end;
```

**Características:**
- ✅ Evita buscar se não existir (otimização)
- ✅ Útil quando você só quer verificar existência

---

## 3. Buscar com Fluent Interface

Usa o método com `out` parameter para encadeamento.

```pascal
var DB: IParametersDatabase;
var Param: TParameter;

// Busca usando Fluent Interface
DB.Get('max_connections', Param);

if Assigned(Param) then
begin
  WriteLn('Valor: ' + Param.Value);
  Param.Free;
end;
```

**Características:**
- ✅ Permite encadeamento de métodos
- ✅ Mesma funcionalidade do método direto

---

## 4. Buscar com filtros (ContratoID/ProdutoID)

Busca parâmetros filtrados por ContratoID e ProdutoID.

```pascal
var DB: IParametersDatabase;
var Param: TParameter;

// Define filtros
DB.ContratoID(1).ProdutoID(1);

// Busca com filtros aplicados
Param := DB.Get('erp_host');

if Assigned(Param) then
begin
  WriteLn('Nome: ' + Param.Name);
  WriteLn('Valor: ' + Param.Value);
  WriteLn('ContratoID: ' + IntToStr(Param.ContratoID));
  WriteLn('ProdutoID: ' + IntToStr(Param.ProdutoID));
  Param.Free;
end;
```

**Características:**
- ✅ Filtra por ContratoID e ProdutoID
- ✅ Útil para parâmetros específicos de contrato/produto

---

## 5. Buscar com IParameters (fallback automático)

Busca em múltiplas fontes com fallback automático.

```pascal
var Parameters: IParameters;
var Param: TParameter;

// Configura múltiplas fontes
Parameters := TParameters.New([pcfDataBase, pcfInifile]);

// Configura Database
Parameters.Database
  .DatabaseType('SQLite')
  .Database('E:\Pacote\ORM\Data\Config.db')
  .TableName('config')
  .Connect;

// Configura INI como fallback
Parameters.Inifiles
  .FilePath('E:\Pacote\ORM\Data\config.ini')
  .Section('Parameters');

// Define ordem de prioridade
Parameters.Priority([psDatabase, psInifiles]);

// Busca em cascata: Database → INI
Param := Parameters.Get('database_port');

if Assigned(Param) then
begin
  WriteLn('Valor: ' + Param.Value);
  Param.Free;
end;
```

**Características:**
- ✅ Busca em cascata (Database → INI → JSON)
- ✅ Fallback automático se uma fonte falhar
- ✅ Útil para contingência

---

## 6. Buscar em fonte específica

Busca apenas em uma fonte específica (sem fallback).

```pascal
var Parameters: IParameters;
var Param: TParameter;

// Busca APENAS no Database (não tenta outras fontes)
Param := Parameters.Get('test_key', psDatabase);

if Assigned(Param) then
begin
  WriteLn('Valor: ' + Param.Value);
  Param.Free;
end;
```

**Características:**
- ✅ Busca apenas na fonte especificada
- ✅ Não faz fallback para outras fontes
- ✅ Útil quando você quer garantir a fonte

---

## 7. Tratamento de erros

Tratamento adequado de erros e validações.

```pascal
var DB: IParametersDatabase;
var Param: TParameter;

try
  Param := DB.Get('invalid_parameter_name');
  
  if Assigned(Param) then
  begin
    WriteLn('Parâmetro encontrado!');
    WriteLn('Valor: ' + Param.Value);
    Param.Free;
  end
  else
  begin
    WriteLn('Parâmetro não encontrado (retornou nil)');
    WriteLn('Isso é normal - não é um erro, apenas não existe.');
  end;
except
  on E: Exception do
  begin
    WriteLn('ERRO ao buscar parâmetro:');
    WriteLn('  Classe: ' + E.ClassName);
    WriteLn('  Mensagem: ' + E.Message);
  end;
end;
```

**Características:**
- ✅ Tratamento de exceções
- ✅ Validação de retorno `nil` (não é erro)
- ✅ Mensagens de erro claras

---

## 8. Buscar múltiplos parâmetros

Busca vários parâmetros em um loop.

```pascal
var DB: IParametersDatabase;
var Param: TParameter;
var ParamNames: array[0..2] of string;
var FoundCount: Integer;
var I: Integer;

// Define lista de parâmetros
ParamNames[0] := 'database_host';
ParamNames[1] := 'database_port';
ParamNames[2] := 'database_name';

FoundCount := 0;
for I := 0 to High(ParamNames) do
begin
  Param := DB.Get(ParamNames[I]);
  if Assigned(Param) then
  begin
    Inc(FoundCount);
    WriteLn(ParamNames[I] + ' = ' + Param.Value);
    Param.Free;
  end
  else
  begin
    WriteLn(ParamNames[I] + ' = (não encontrado)');
  end;
end;

WriteLn('Total encontrado: ' + IntToStr(FoundCount));
```

**Características:**
- ✅ Busca múltiplos parâmetros eficientemente
- ✅ Conta quantos foram encontrados
- ✅ Trata cada parâmetro individualmente

---

## ⚠️ Observações Importantes

### Liberação de Memória

**SEMPRE** libere o objeto `TParameter` após usar:

```pascal
Param := DB.Get('nome_parametro');
try
  // Usar Param...
finally
  Param.Free; // IMPORTANTE!
end;
```

### Retorno `nil` não é erro

O método `Get()` retorna `nil` se o parâmetro não existir. Isso **não é um erro**, apenas indica que o parâmetro não foi encontrado.

### Filtros

Quando usar `ContratoID()` e `ProdutoID()`, os filtros são aplicados a **todas** as operações subsequentes até serem alterados.

### Thread-Safety

Todas as operações são thread-safe. Você pode usar de múltiplas threads sem problemas.

---

## 📚 Referências

- `Parameters.pas`: Ponto de entrada público
- `Parameters.Interfaces.pas`: Interfaces públicas
- `Parameters.Types.pas`: Tipos (TParameter, TParameterList)
- `Parameters.Consts.pas`: Constantes

---

**Autor:** Claiton de Souza Linhares  
**Data:** 02/01/2026
