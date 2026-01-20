unit Parameters.Attributes.Consts;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ ===============================================================================
  Parameters.Attributes.Consts - Constantes para Sistema de Attributes
  
  Descrição:
  Define constantes usadas pelo sistema de Attributes para mapeamento runtime.
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 03/01/2026
  =============================================================================== }

interface

{$I ../../Paramenters.Defines.inc}

uses
{$IF DEFINED(FPC)}
  SysUtils;
{$ELSE}
  System.SysUtils;
{$ENDIF}

const
  { =============================================================================
    Mensagens de Erro - Constantes de Mensagem
    ============================================================================= }
  
  { Mensagem de erro quando classe não possui atributo [Parameter]
    Usado quando uma classe é processada mas não tem o atributo obrigatório [Parameter] }
  ERR_ATTRIBUTE_PARAMETER_NOT_FOUND = 'Classe não possui atributo [Parameter]';
  
  { Mensagem de erro quando propriedade não possui atributo [ParameterKey]
    Usado quando uma propriedade é processada mas não tem o atributo [ParameterKey] }
  ERR_ATTRIBUTE_PARAMETER_KEY_NOT_FOUND = 'Propriedade não possui atributo [ParameterKey]';
  
  (* Mensagem de erro quando classe é inválida ou sem RTTI habilitado
    Usado quando RTTI não está disponível para a classe (falta {$M+} ou {$TYPEINFO ON}) *)
  ERR_ATTRIBUTE_INVALID_CLASS = 'Classe inválida ou sem RTTI habilitado';
  
  { Mensagem de erro quando RTTI não está disponível para a classe
    Usado quando não é possível obter informações RTTI da classe }
  ERR_ATTRIBUTE_RTTI_NOT_AVAILABLE = 'RTTI não disponível para esta classe';
  
  { Mensagem de erro quando propriedade é inválida ou sem atributos
    Usado quando propriedade não pode ser processada corretamente }
  ERR_ATTRIBUTE_INVALID_PROPERTY = 'Propriedade inválida ou sem atributos';
  
  { Mensagem de erro quando parâmetro obrigatório não é encontrado
    Usado quando propriedade tem [ParameterRequired] mas parâmetro não existe }
  ERR_ATTRIBUTE_REQUIRED_PARAMETER_NOT_FOUND = 'Parâmetro obrigatório não encontrado';

  { =============================================================================
    Valores Padrão - Constantes de Configuração
    ============================================================================= }
  
  { ContratoID padrão quando não especificado via [ContratoID]
    Valor padrão: 1 }
  DEFAULT_CONTRATO_ID = 1;
  
  { ProdutoID padrão quando não especificado via [ProdutoID]
    Valor padrão: 1 }
  DEFAULT_PRODUTO_ID = 1;
  
  { Ordem padrão quando não especificado via [ParameterOrder]
    Valor padrão: 0 (ordem automática) }
  DEFAULT_PARAMETER_ORDER = 0;
  
  { Fonte padrão quando não especificado via [ParameterSource]
    Valor padrão: psDatabase }
  DEFAULT_PARAMETER_SOURCE = 1; // psDatabase

implementation

end.
