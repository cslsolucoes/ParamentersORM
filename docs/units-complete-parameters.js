// Arquivo auxiliar com todas as units e métodos documentados do Parameters ORM
// Este arquivo será mesclado ao docs-data.js

const additionalUnits = [
    {
        id: "parameters",
        name: "Parameters.pas",
        path: "src/Paramenters/Parameters.pas",
        description: `
            <p>Ponto de entrada público do Sistema de Parâmetros. Contém a classe factory <code>TParameters</code> e a implementação <code>TParametersImpl</code> da interface <code>IParameters</code>.</p>
            <p><strong>Encapsulamento:</strong> Apenas este arquivo e Parameters.Interfaces.pas são públicos. Todas as implementações estão ocultas.</p>
        `,
        classes: [
            {
                name: "TParameters",
                description: "Factory class para criar instâncias de IParameters, IParametersDatabase, IParametersInifiles e IParametersJsonObject"
            },
            {
                name: "TParametersImpl",
                description: "Implementação da interface IParameters que gerencia múltiplas fontes de dados com fallback automático"
            }
        ],
        functions: [
            {
                signature: "class function New: IParameters; overload;",
                comment: "Cria nova instância de IParameters com configuração padrão (apenas Database)",
                example: "var Parameters: IParameters; Parameters := TParameters.New;"
            },
            {
                signature: "class function New(AConfig: TParameterConfig): IParameters; overload;",
                comment: "Cria nova instância de IParameters com configuração de fontes especificada",
                example: "Parameters := TParameters.New([pcfDataBase, pcfInifile, pcfJsonObject]);"
            },
            {
                signature: "class function NewDatabase: IParametersDatabase; overload;",
                comment: "Cria nova instância de IParametersDatabase (conexão interna automática)",
                example: "var DB: IParametersDatabase; DB := TParameters.NewDatabase;"
            }
        ]
    },
    {
        id: "parameters_interfaces",
        name: "Parameters.Interfaces.pas",
        path: "src/Paramenters/Parameters.Interfaces.pas",
        description: `
            <p>Define todas as interfaces públicas do módulo Parameters:</p>
            <ul>
                <li><code>IParameters</code> - Interface principal de convergência (múltiplas fontes com fallback)</li>
                <li><code>IParametersDatabase</code> - Interface para acesso a parâmetros em banco de dados</li>
                <li><code>IParametersInifiles</code> - Interface para acesso a parâmetros em arquivos INI</li>
                <li><code>IParametersJsonObject</code> - Interface para acesso a parâmetros em objetos JSON</li>
            </ul>
            <p><strong>Re-exportação:</strong> Este arquivo também re-exporta tipos, exceções e constantes das units internas.</p>
        `,
        interfaces: [
            {
                name: "IParameters",
                description: "Interface principal de convergência que gerencia múltiplas fontes de dados (Database, INI, JSON) com suporte a fallback automático",
                methods: [
                    {
                        signature: "function Source(ASource: TParameterSource): IParameters; overload;",
                        comment: "Define fonte ativa para operações",
                        example: "Parameters.Source(psDatabase);"
                    },
                    {
                        signature: "function Get(const AName: string): TParameter; overload;",
                        comment: "Busca parâmetro em cascata (Database → INI → JSON)",
                        example: "var Param: TParameter; Param := Parameters.Get('host');"
                    }
                ]
            },
            {
                name: "IParametersDatabase",
                description: "Interface para acesso a parâmetros em banco de dados com suporte a múltiplos engines e bancos",
                methods: [
                    {
                        signature: "function Connect: IParametersDatabase; overload;",
                        comment: "Conecta ao banco de dados",
                        example: "DB.Connect; // ou DB.Connect(LSuccess);"
                    },
                    {
                        signature: "function Get(const AName: string): TParameter; overload;",
                        comment: "Busca parâmetro por chave",
                        example: "var Param: TParameter; Param := DB.Get('host');"
                    },
                    {
                        signature: "function Title(const AValue: string): IParametersDatabase; overload;",
                        comment: "Define filtro de título (permite encadeamento)",
                        example: "DB.Title('ERP').Get('host');"
                    }
                ]
            },
            {
                name: "IParametersInifiles",
                description: "Interface para acesso a parâmetros em arquivos INI",
                methods: [
                    {
                        signature: "function FilePath(const AValue: string): IParametersInifiles; overload;",
                        comment: "Define caminho do arquivo INI",
                        example: "Ini.FilePath('C:\\config.ini');"
                    },
                    {
                        signature: "function Get(const AName: string): TParameter; overload;",
                        comment: "Busca parâmetro por chave",
                        example: "var Param: TParameter; Param := Ini.Get('host');"
                    }
                ]
            },
            {
                name: "IParametersJsonObject",
                description: "Interface para acesso a parâmetros em objetos JSON",
                methods: [
                    {
                        signature: "function JsonObject(AJsonObject: TJSONObject): IParametersJsonObject; overload;",
                        comment: "Define objeto JSON",
                        example: "Json.JsonObject(MyJsonObject);"
                    },
                    {
                        signature: "function Get(const AName: string): TParameter; overload;",
                        comment: "Busca parâmetro por chave",
                        example: "var Param: TParameter; Param := Json.Get('host');"
                    }
                ]
            }
        ]
    }
];

// Exporta para uso em outros scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = additionalUnits;
}
