# 📋 Proposta de Implementação - Critérios Faltantes

**Data:** 03/01/2026  
**Versão:** 1.0.2  
**Autor:** Claiton de Souza Linhares  
**Status:** 🟡 Proposta Detalhada

---

## 🎯 Objetivo

Implementar os critérios faltantes que são aplicáveis ao módulo Parameters:
1. **Attributes (Mapeamento Runtime)** - Prioridade ALTA
2. **Interfaces Genéricas (Generic)** - Prioridade MÉDIA
3. **LDAP (Implementação Completa)** - Prioridade BAIXA

---

## 1. 📝 Attributes (Mapeamento Runtime) - PRIORIDADE ALTA

### Status Atual
- ❌ Não implementado
- ✅ Proposta detalhada existe: `Analises/PROPOSTA_IMPLEMENTACAO_ATTRIBUTES.md`

### Proposta de Implementação

#### 1.1 Estrutura de Arquivos

```
src/Paramenters/
├── Attributes/
│   ├── Parameters.Attributes.Interfaces.pas    → Interfaces públicas
│   ├── Parameters.Attributes.pas               → Implementação
│   └── Parameters.Attributes.Types.pas         → Attributes customizados
```

#### 1.2 Attributes Propostos

**Nível de Classe:**
- `[Parameter(const ATitulo: string)]` - Define título do grupo de parâmetros
- `[ContratoID(const AValue: Integer)]` - Define ContratoID padrão
- `[ProdutoID(const AValue: Integer)]` - Define ProdutoID padrão
- `[ParameterSource(const ASource: TParameterSource)]` - Define fonte preferencial

**Nível de Propriedade:**
- `[ParameterKey(const AKey: string)]` - Define chave do parâmetro (obrigatório)
- `[ParameterValue(const AValue: Variant)]` - Define valor padrão
- `[ParameterDescription(const ADescription: string)]` - Define descrição
- `[ParameterType(const AType: TParameterValueType)]` - Define tipo do valor
- `[ParameterOrder(const AOrder: Integer)]` - Define ordem de exibição
- `[ParameterRequired]` - Indica que parâmetro é obrigatório

#### 1.3 Interfaces Propostas

```pascal
type
  { Parser de Attributes via RTTI }
  IAttributeParser = interface
    function ParseClassAttributes(AClassType: TClass): TClassAttributeMetadata;
    function ParsePropertyAttributes(AProperty: TRttiProperty): TPropertyAttributeMetadata;
  end;
  
  { Mapper Classe ↔ TParameter }
  IAttributeMapper = interface
    function ClassToParameters(AInstance: TObject): TParameterList;
    function ParametersToClass(AParameters: TParameterList; AInstance: TObject): Boolean;
    function LoadFromParameters(AParameters: IParameters; AInstance: TObject): Boolean;
    function SaveToParameters(AParameters: IParameters; AInstance: TObject): Boolean;
  end;
```

#### 1.4 Extensão de IParameters

```pascal
type
  IParameters = interface
    // ... métodos existentes ...
    
    { ========== MÉTODOS COM ATTRIBUTES ========== }
    
    { Carrega parâmetros do banco/INI/JSON para uma classe com Attributes }
    function LoadFromClass(AInstance: TObject): IParameters; overload;
    function LoadFromClass(AInstance: TObject; out ASuccess: Boolean): IParameters; overload;
    
    { Salva parâmetros de uma classe com Attributes para o banco/INI/JSON }
    function SaveFromClass(AInstance: TObject): IParameters; overload;
    function SaveFromClass(AInstance: TObject; out ASuccess: Boolean): IParameters; overload;
    
    { Retorna o mapper de Attributes }
    function AttributeMapper: IAttributeMapper;
  end;
```

#### 1.5 Exemplo de Uso

```pascal
{$M+}  // Habilita RTTI
uses Parameters, Parameters.Attributes;

type
  [Parameter('ERP')]
  [ContratoID(1)]
  [ProdutoID(1)]
  TConfigERP = class
  private
    FDatabaseHost: string;
    FDatabasePort: Integer;
    FDatabaseName: string;
  public
    [ParameterKey('database_host')]
    [ParameterValue('localhost')]
    [ParameterDescription('Host do banco de dados ERP')]
    property DatabaseHost: string read FDatabaseHost write FDatabaseHost;
    
    [ParameterKey('database_port')]
    [ParameterValue(5432)]
    [ParameterType(pvtInteger)]
    property DatabasePort: Integer read FDatabasePort write FDatabasePort;
    
    [ParameterKey('database_name')]
    [ParameterRequired]
    property DatabaseName: string read FDatabaseName write FDatabaseName;
  end;

var
  Config: TConfigERP;
  Parameters: IParameters;
begin
  Config := TConfigERP.Create;
  try
    Parameters := TParameters.NewDatabase
      .Host('localhost')
      .Database('mydb')
      .Connect;
    
    // Carrega parâmetros do banco para a classe
    Parameters.LoadFromClass(Config);
    
    // Usa os valores
    ShowMessage(Format('Host: %s, Port: %d', [Config.DatabaseHost, Config.DatabasePort]));
    
    // Modifica e salva
    Config.DatabaseHost := 'novo_host';
    Parameters.SaveFromClass(Config);
  finally
    Config.Free;
  end;
end;
```

#### 1.6 Estimativa de Implementação

- **Fase 1:** Attributes customizados (3-4 dias)
- **Fase 2:** Parser de RTTI (3-4 dias)
- **Fase 3:** Mapper Classe ↔ TParameter (3-4 dias)
- **Fase 4:** Integração com IParameters (2-3 dias)
- **Fase 5:** Validação e testes (2-3 dias)
- **Total:** 14-18 dias

---

## 2. 🔄 Interfaces Genéricas (Generic) - PRIORIDADE MÉDIA

### Status Atual
- ❌ Não implementado
- ✅ Delphi/FPC suportam generics desde versões modernas

### Proposta de Implementação

#### 2.1 Interface Genérica Proposta

```pascal
type
  { Interface genérica para type-safety com Attributes }
  IParameters<T: class> = interface
    ['{G1H2I3J4-K5L6-7890-MNOP-QRSTUVWXYZ01}']
    
    { Carrega parâmetros para instância do tipo T }
    function LoadFromClass(AInstance: T): IParameters<T>; overload;
    function LoadFromClass(AInstance: T; out ASuccess: Boolean): IParameters<T>; overload;
    
    { Salva parâmetros de instância do tipo T }
    function SaveFromClass(AInstance: T): IParameters<T>; overload;
    function SaveFromClass(AInstance: T; out ASuccess: Boolean): IParameters<T>; overload;
    
    { Retorna instância tipada }
    function AsTyped: IParameters<T>;
  end;
```

#### 2.2 Factory Method Genérico

```pascal
type
  TParameters = class
    // ... métodos existentes ...
    
    { Cria instância genérica }
    class function New<T: class>: IParameters<T>; overload;
  end;
```

#### 2.3 Exemplo de Uso

```pascal
{$M+}
uses Parameters, Parameters.Attributes;

type
  [Parameter('ERP')]
  TConfigERP = class
    [ParameterKey('database_host')]
    property DatabaseHost: string;
  end;

var
  Config: TConfigERP;
  Parameters: IParameters<TConfigERP>;
begin
  Config := TConfigERP.Create;
  try
    Parameters := TParameters.New<TConfigERP>
      .Database.Host('localhost')
      .Connect;
    
    // Type-safe: só aceita TConfigERP
    Parameters.LoadFromClass(Config);
    
    // IntelliSense completo
    ShowMessage(Config.DatabaseHost);
  finally
    Config.Free;
  end;
end;
```

#### 2.4 Vantagens

- ✅ Type-safety em tempo de compilação
- ✅ IntelliSense completo
- ✅ Menos erros de tipo em runtime
- ✅ Código mais limpo

#### 2.5 Estimativa de Implementação

- **Dia 1-2:** Criar interfaces genéricas
- **Dia 3-4:** Implementar e testar
- **Dia 5:** Documentação
- **Total:** 3-5 dias

---

## 3. 🔌 LDAP (Implementação Completa) - PRIORIDADE BAIXA

### Status Atual
- 🟡 Enum existe (`pdtLDAP`, `pteLDAP`)
- ❌ Implementação não existe

### Proposta de Implementação

#### 3.1 Biblioteca LDAP Recomendada

**Opções:**
1. **Synapse** (FreePascal) - Recomendado para FPC
2. **Indy** (Delphi/FPC) - Já usado em muitos projetos
3. **LDAP Client** (Delphi) - Específico para Delphi

**Recomendação:** Usar **Synapse** (compatível com Delphi e FPC)

#### 3.2 Estrutura Proposta

```pascal
type
  TParametersLDAP = class(TInterfacedObject, IParametersDatabase)
  private
    FLDAPConnection: TLDAPSend;  // Synapse
    FBaseDN: string;
    FFilter: string;
  public
    // Implementa IParametersDatabase
    // Adapta operações CRUD para LDAP
  end;
```

#### 3.3 Mapeamento LDAP ↔ TParameter

**Estrutura LDAP:**
```
dn: cn=database_host,ou=Parameters,dc=example,dc=com
objectClass: parameter
cn: database_host
parameterValue: localhost
parameterType: String
parameterDescription: Host do banco de dados
contratoID: 1
produtoID: 1
titulo: ERP
ordem: 1
ativo: TRUE
```

#### 3.4 Operações CRUD para LDAP

**Getter (Search):**
```pascal
// LDAP Search equivalente a SELECT
LDAPConnection.Search(
  BaseDN: 'ou=Parameters,dc=example,dc=com',
  Filter: '(&(cn=database_host)(contratoID=1)(produtoID=1)(titulo=ERP))'
);
```

**Setter (Add/Modify):**
```pascal
// LDAP Add (INSERT) ou Modify (UPDATE)
if Exists then
  LDAPConnection.Modify(...)
else
  LDAPConnection.Add(...);
```

**Delete:**
```pascal
// LDAP Delete
LDAPConnection.Delete('cn=database_host,ou=Parameters,dc=example,dc=com');
```

#### 3.5 Estimativa de Implementação

- **Dia 1-2:** Pesquisa e escolha de biblioteca
- **Dia 3-5:** Implementação de conexão e CRUD
- **Dia 6-7:** Testes e documentação
- **Total:** 5-7 dias

---

## 📊 Comparação: Implementado vs Proposto

| Critério | Status | Complexidade | Impacto | Prioridade |
|----------|--------|--------------|---------|------------|
| **Attributes** | ❌ Não | Alta | Alto | 🔴 ALTA |
| **Interfaces Genéricas** | ❌ Não | Média | Médio | 🟡 MÉDIA |
| **LDAP Completo** | 🟡 Parcial | Média | Baixo | 🟢 BAIXA |

---

## 🎯 Recomendação de Implementação

### Ordem Sugerida:

1. **Attributes (14-18 dias)** - Maior impacto, reduz verbosidade, melhora type-safety
2. **Interfaces Genéricas (3-5 dias)** - Complementa Attributes, melhora type-safety
3. **LDAP (5-7 dias)** - Baixa prioridade, uso menos comum

**Total Estimado:** 22-30 dias de desenvolvimento

---

## ⚠️ Considerações Importantes

### Attributes
- ✅ **100% opcional** - não quebra código existente
- ✅ **Compatível** - funciona junto com forma tradicional
- ⚠️ **Requer RTTI** - precisa de `{$M+}` nas classes

### Interfaces Genéricas
- ✅ **Melhora type-safety** - erros em tempo de compilação
- ✅ **IntelliSense completo** - melhor experiência de desenvolvimento
- ⚠️ **Delphi 2009+** - requer suporte a generics

### LDAP
- ⚠️ **Biblioteca externa** - requer Synapse ou similar
- ⚠️ **Uso menos comum** - maioria dos projetos não usa LDAP para parâmetros
- ✅ **Completa suporte** - fecha o gap do enum existente

---

## 🚫 Critérios Fora do Escopo

### Relationships (HasOne, HasMany, BelongsTo)
**Motivo:** Parameters trabalha com parâmetros simples (chave-valor), não entidades relacionadas.

**Solução:** Usar **Database ORM v2.0** (que está no roadmap do ProvidersORM) para relacionamentos.

---

### ActiveRecord Pattern (Data Mapper Puro)
**Motivo:** Parameters é um sistema de configuração, não um ORM de entidades de domínio.

**Solução:** Usar **Database ORM v2.0** (que está no roadmap do ProvidersORM) para Active Record.

---

**Autor:** Claiton de Souza Linhares  
**Data:** 03/01/2026  
**Versão:** 1.0.2
