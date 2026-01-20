// Arquivo auxiliar com todas as units e métodos documentados
// Este arquivo será mesclado ao docs-data.js

const additionalUnits = [
    {
        id: "table-interfaces",
        name: "Database.Table.Interfaces",
        path: "src/Tables/Database.Table.Interfaces.pas",
        description: `
            <p>Define a interface <code>ITable</code> que representa uma coleção de campos para uma tabela específica do banco de dados.</p>
            <p><strong>Hierarquia:</strong> Nível 3 - Field (IField) → Fields (IFields) → Table (ITable) → Tables (ITables)</p>
        `,
        interfaces: [
            {
                name: "ITable",
                guid: "{C1D2E3F4-A5B6-7890-CDEF-123456789ABC}",
                description: "Interface que representa uma coleção de campos para uma tabela específica do banco de dados. Fornece geração de SQL, auditoria e serialização.",
                methods: [
                    {
                        signature: "function TableName(Value: string): ITable; overload;",
                        comment: "Define o nome da tabela. Retorna Self para encadeamento.",
                        example: "Table.TableName('usuarios'); // Define nome da tabela"
                    },
                    {
                        signature: "function TableName: string; overload;",
                        comment: "Obtém o nome da tabela",
                        example: "var tableName := Table.TableName; // Retorna 'usuarios'"
                    },
                    {
                        signature: "function Alias(Value: string): ITable; overload;",
                        comment: "Define o alias da tabela. Retorna Self para encadeamento.",
                        example: "Table.Alias('u'); // Define alias da tabela"
                    },
                    {
                        signature: "function Alias: string; overload;",
                        comment: "Obtém o alias da tabela",
                        example: "var alias := Table.Alias; // Retorna alias da tabela"
                    },
                    {
                        signature: "function DatabaseTypes(Value: TDatabaseTypes): ITable; overload;",
                        comment: "Define o tipo de banco de dados. Retorna Self para encadeamento.",
                        example: "Table.DatabaseTypes(dtPostgreSQL); // Define tipo de banco"
                    },
                    {
                        signature: "function DatabaseTypes: TDatabaseTypes; overload;",
                        comment: "Obtém o tipo de banco de dados",
                        example: "var dbType := Table.DatabaseTypes; // Retorna tipo de banco"
                    },
                    {
                        signature: "function GenerateInsertSQL: string;",
                        comment: "Gera SQL INSERT com todos os campos",
                        example: "var sql := Table.GenerateInsertSQL; // Gera: INSERT INTO usuarios (id, nome) VALUES (1, 'João')"
                    },
                    {
                        signature: "function GenerateInsertSQLOptimized: string;",
                        comment: "Gera SQL INSERT apenas com campos alterados",
                        example: "var sql := Table.GenerateInsertSQLOptimized; // Gera INSERT apenas com campos que foram alterados"
                    },
                    {
                        signature: "function GenerateUpdateSQL: string;",
                        comment: "Gera SQL UPDATE com todos os campos",
                        example: "var sql := Table.GenerateUpdateSQL; // Gera: UPDATE usuarios SET id=1, nome='João' WHERE id=1"
                    },
                    {
                        signature: "function GenerateUpdateSQLOptimized: string;",
                        comment: "Gera SQL UPDATE apenas com campos alterados",
                        example: "var sql := Table.GenerateUpdateSQLOptimized; // Gera UPDATE apenas com campos alterados"
                    },
                    {
                        signature: "function GenerateWhereByPrimaryKey: string;",
                        comment: "Gera cláusula WHERE baseada nas Primary Keys",
                        example: "var where := Table.GenerateWhereByPrimaryKey; // Retorna: WHERE id=1"
                    },
                    {
                        signature: "procedure ValidateNotNullFields;",
                        comment: "Valida campos obrigatórios (NOT NULL)",
                        example: "Table.ValidateNotNullFields; // Lança exceção se campo obrigatório estiver vazio"
                    },
                    {
                        signature: "function HasChanges: Boolean;",
                        comment: "Verifica se há campos alterados",
                        example: "if Table.HasChanges then ShowMessage('Há alterações');"
                    },
                    {
                        signature: "function GetChangedFieldNames: TStringArray;",
                        comment: "Obtém nomes dos campos alterados",
                        example: "var changed := Table.GetChangedFieldNames; // Retorna array com nomes dos campos alterados"
                    },
                    {
                        signature: "function LoadFieldsFromDB(ADataSet: TDataSet): ITable;",
                        comment: "Carrega estrutura de campos do banco de dados",
                        example: "Table.LoadFieldsFromDB(DataSet); // Carrega campos do DataSet"
                    },
                    {
                        signature: "function LoadValuesFromDataSet(ADataSet: TDataSet): ITable;",
                        comment: "Carrega valores de um DataSet",
                        example: "Table.LoadValuesFromDataSet(DataSet); // Carrega valores do DataSet para os campos"
                    },
                    {
                        signature: "function ApplyValuesToDataSet(ADataSet: TDataSet): ITable;",
                        comment: "Aplica valores a um DataSet",
                        example: "Table.ApplyValuesToDataSet(DataSet); // Aplica valores dos campos ao DataSet"
                    },
                    {
                        signature: "function ToJSON: string;",
                        comment: "Serializa tabela para JSON",
                        example: "var json := Table.ToJSON; // Retorna JSON com dados da tabela"
                    },
                    {
                        signature: "function FromJSON(const AJSON: string): ITable;",
                        comment: "Deserializa tabela de JSON",
                        example: "Table.FromJSON('{\"table\":\"usuarios\",\"fields\":[...]}'); // Carrega dados de JSON"
                    },
                    {
                        signature: "function AuditFields(AEnabled: Boolean): ITable; overload;",
                        comment: "Habilita ou desabilita auditoria automática. Retorna Self para encadeamento.",
                        example: "Table.AuditFields(True); // Habilita auditoria automática"
                    },
                    {
                        signature: "function AuditFields: Boolean; overload;",
                        comment: "Obtém status da auditoria",
                        example: "if Table.AuditFields then ShowMessage('Auditoria ativa');"
                    },
                    {
                        signature: "function FieldDateCreated(const AFieldName: String): ITable; overload;",
                        comment: "Define nome do campo de data de criação. Retorna Self para encadeamento.",
                        example: "Table.FieldDateCreated('data_cadastro'); // Define campo de data de criação"
                    },
                    {
                        signature: "function FieldDateCreated: String; overload;",
                        comment: "Obtém nome do campo de data de criação",
                        example: "var fieldName := Table.FieldDateCreated; // Retorna 'data_cadastro'"
                    },
                    {
                        signature: "function FieldDateUpdated(const AFieldName: String): ITable; overload;",
                        comment: "Define nome do campo de data de atualização. Retorna Self para encadeamento.",
                        example: "Table.FieldDateUpdated('data_alteracao'); // Define campo de data de atualização"
                    },
                    {
                        signature: "function FieldDateUpdated: String; overload;",
                        comment: "Obtém nome do campo de data de atualização",
                        example: "var fieldName := Table.FieldDateUpdated; // Retorna 'data_alteracao'"
                    },
                    {
                        signature: "function FieldIsDeleted(const AFieldName: String): ITable; overload;",
                        comment: "Define nome do campo de soft delete. Retorna Self para encadeamento.",
                        example: "Table.FieldIsDeleted('is_deleted'); // Define campo de soft delete"
                    },
                    {
                        signature: "function FieldIsDeleted: String; overload;",
                        comment: "Obtém nome do campo de soft delete",
                        example: "var fieldName := Table.FieldIsDeleted; // Retorna 'is_deleted'"
                    },
                    {
                        signature: "function FieldIsActive(const AFieldName: String): ITable; overload;",
                        comment: "Define nome do campo de ativação. Retorna Self para encadeamento.",
                        example: "Table.FieldIsActive('is_active'); // Define campo de ativação"
                    },
                    {
                        signature: "function FieldIsActive: String; overload;",
                        comment: "Obtém nome do campo de ativação",
                        example: "var fieldName := Table.FieldIsActive; // Retorna 'is_active'"
                    },
                    {
                        signature: "function ExcludeFields(const AFields: String): ITable; overload;",
                        comment: "Define lista de campos excluídos. Retorna Self para encadeamento.",
                        example: "Table.ExcludeFields('id,created_at'); // Exclui campos do SQL gerado"
                    },
                    {
                        signature: "function ExcludeFields: String; overload;",
                        comment: "Obtém lista de campos excluídos",
                        example: "var excluded := Table.ExcludeFields; // Retorna lista de campos excluídos"
                    },
                    {
                        signature: "function Fields: IFields;",
                        comment: "Retorna interface IFields para acesso aos campos",
                        example: "var Fields: IFields := Table.Fields; // Obtém acesso aos campos"
                    },
                    {
                        signature: "function EndTable: IInterface;",
                        comment: "Retorna ao container pai (nível superior)",
                        example: "var parent := Table.EndTable; // Retorna ao container pai"
                    }
                ]
            }
        ]
    }
    // Mais units serão adicionadas aqui...
];
