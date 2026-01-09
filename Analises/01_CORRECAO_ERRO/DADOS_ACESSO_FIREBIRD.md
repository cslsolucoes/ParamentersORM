# Dados de Acesso ao Firebird

**Data:** 01/01/2026  
**Banco:** DEXION.FDB

## Configurações de Conexão

- **Firebird Path:** `C:\Program Files\Firebird\Firebird_2_5\bin\isql.exe`
- **Host:** `10.100.2.30`
- **Database:** `D:\Dados\DEXION.FDB`
- **Usuário:** `SYSDBA`
- **Senha:** `masterkey`

## String de Conexão

```
10.100.2.30:D:\Dados\DEXION.FDB
```

## Comandos ISQL

### Conectar ao banco:
```bash
isql.exe -user SYSDBA -password masterkey 10.100.2.30:D:\Dados\DEXION.FDB
```

### Verificar se tabela existe:
```sql
SELECT COUNT(*) FROM RDB$RELATIONS 
WHERE UPPER(RDB$RELATION_NAME) = 'CONFIG' 
AND RDB$SYSTEM_FLAG = 0;
```

### Listar todas as tabelas:
```sql
SELECT TRIM(RDB$RELATION_NAME) as TABLE_NAME 
FROM RDB$RELATIONS 
WHERE RDB$SYSTEM_FLAG = 0 
ORDER BY RDB$RELATION_NAME;
```

### Dropar tabela (se existir):
```sql
DROP TABLE "CONFIG";
```

## Observações

- Firebird armazena nomes de tabelas em UPPERCASE no RDB$RELATIONS
- Tabelas criadas sem aspas são convertidas para UPPERCASE
- Tabelas criadas com aspas duplas mantêm o case original
- Para dropar, usar o nome exato como está armazenado (geralmente UPPERCASE)



