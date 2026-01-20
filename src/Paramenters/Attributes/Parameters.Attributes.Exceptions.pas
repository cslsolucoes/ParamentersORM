unit Parameters.Attributes.Exceptions;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ ===============================================================================
  Parameters.Attributes.Exceptions - Exceções Específicas para Sistema de Attributes
  
  Descrição:
  Define exceções customizadas para o sistema de Attributes (RTTI e mapeamento).
  Herda de EParametersConfigurationException pois erros de atributos são erros
  de configuração/mapeamento de classes.
  
  Hierarquia:
  EParametersException → EParametersConfigurationException → EParametersAttributeException
  
  Códigos de Erro:
  Faixa 1900-1999 reservada para erros de Attributes
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 03/01/2026
  =============================================================================== }

interface

{$I ../../Paramenters.Defines.inc}

uses
  Parameters.Exceptions,
  Parameters.Attributes.Consts,
{$IF DEFINED(FPC)}
  SysUtils;
{$ELSE}
  System.SysUtils;
{$ENDIF}

type
  { =============================================================================
    EParametersAttributeException - Exceção Específica para Attributes
    =============================================================================
    Exceção específica para erros relacionados ao sistema de Attributes (RTTI e mapeamento).
    Herda de EParametersConfigurationException pois erros de atributos são erros de
    configuração/mapeamento de classes.
    
    Hierarquia:
    EParametersException → EParametersConfigurationException → EParametersAttributeException
    
    Códigos de Erro:
    Faixa 1900-1999 reservada para erros de Attributes
    ============================================================================= }
  
  EParametersAttributeException = class(EParametersConfigurationException)
  public
    { Cria exceção de Attribute
      Parâmetros:
        AMessage: Mensagem de erro descritiva
        AErrorCode: Código de erro (padrão: 0, usa código específico se não informado)
        AOperation: Nome da operação que gerou o erro (para rastreamento)
      Nota: Usa código de erro padrão da faixa 1900-1999 se AErrorCode = 0 }
    constructor Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = ''); reintroduce;
  end;

const
  { =============================================================================
    CÓDIGOS DE ERRO - Attributes (1900-1999)
    =============================================================================
    Faixa de códigos reservada para erros do sistema de Attributes.
    Cada código corresponde a um tipo específico de erro de mapeamento/parsing.
    ============================================================================= }
  
  { Código de erro quando atributo [Parameter] não é encontrado na classe }
  ERR_ATTRIBUTE_PARAMETER_NOT_FOUND_CODE = 1901;
  
  { Código de erro quando atributo [ParameterKey] não é encontrado na propriedade }
  ERR_ATTRIBUTE_PARAMETER_KEY_NOT_FOUND_CODE = 1902;
  
  { Código de erro quando classe é inválida ou sem RTTI habilitado }
  ERR_ATTRIBUTE_INVALID_CLASS_CODE = 1903;
  
  { Código de erro quando RTTI não está disponível para a classe }
  ERR_ATTRIBUTE_RTTI_NOT_AVAILABLE_CODE = 1904;
  
  { Código de erro quando propriedade é inválida ou sem atributos }
  ERR_ATTRIBUTE_INVALID_PROPERTY_CODE = 1905;
  
  { Código de erro quando parâmetro obrigatório não é encontrado }
  ERR_ATTRIBUTE_REQUIRED_PARAMETER_NOT_FOUND_CODE = 1906;
  
  { Código de erro quando parsing da classe falha }
  ERR_ATTRIBUTE_PARSING_FAILED_CODE = 1907;
  
  { Código de erro quando mapeamento Classe → TParameter falha }
  ERR_ATTRIBUTE_MAPPING_FAILED_CODE = 1908;
  
  { Código de erro quando validação da classe falha }
  ERR_ATTRIBUTE_VALIDATION_FAILED_CODE = 1909;
  
  { Código de erro quando conversão de valor falha }
  ERR_ATTRIBUTE_VALUE_CONVERSION_FAILED_CODE = 1910;

  { =============================================================================
    MENSAGENS DE ERRO - Formatáveis
    =============================================================================
    Mensagens de erro que podem ser formatadas com valores dinâmicos.
    ============================================================================= }
  
  { Mensagem formatável quando atributo [Parameter] não é encontrado
    Parâmetros: Nome da classe }
  MSG_ATTRIBUTE_PARAMETER_NOT_FOUND = 'Classe %s não possui atributo [Parameter]';
  
  { Mensagem formatável quando atributo [ParameterKey] não é encontrado
    Parâmetros: Nome da propriedade }
  MSG_ATTRIBUTE_PARAMETER_KEY_NOT_FOUND = 'Propriedade %s não possui atributo [ParameterKey]';
  
  { Mensagem formatável quando RTTI não está disponível
    Parâmetros: Nome da classe }
  MSG_ATTRIBUTE_RTTI_NOT_AVAILABLE = 'RTTI não disponível para classe %s (adicione {$M+} ou {$TYPEINFO ON})';
  
  { Mensagem formatável quando parâmetro obrigatório não é encontrado
    Parâmetros: Nome da chave do parâmetro }
  MSG_ATTRIBUTE_REQUIRED_PARAMETER_NOT_FOUND = 'Parâmetro obrigatório "%s" não encontrado';

implementation

{ ===============================================================================
  EParametersAttributeException
  =============================================================================== }

constructor EParametersAttributeException.Create(const AMessage: string; const AErrorCode: Integer = 0; const AOperation: string = '');
var
  LErrorCode: Integer;
begin
  // Se código não foi especificado, usa código padrão baseado na mensagem
  if AErrorCode = 0 then
  begin
    if Pos('não possui atributo [Parameter]', AMessage) > 0 then
      LErrorCode := ERR_ATTRIBUTE_PARAMETER_NOT_FOUND_CODE
    else if Pos('não possui atributo [ParameterKey]', AMessage) > 0 then
      LErrorCode := ERR_ATTRIBUTE_PARAMETER_KEY_NOT_FOUND_CODE
    else if Pos('RTTI não disponível', AMessage) > 0 then
      LErrorCode := ERR_ATTRIBUTE_RTTI_NOT_AVAILABLE_CODE
    else if Pos('Parâmetro obrigatório', AMessage) > 0 then
      LErrorCode := ERR_ATTRIBUTE_REQUIRED_PARAMETER_NOT_FOUND_CODE
    else
      LErrorCode := ERR_ATTRIBUTE_PARSING_FAILED_CODE;
  end
  else
    LErrorCode := AErrorCode;
  
  inherited Create(AMessage, LErrorCode, AOperation);
end;

end.
