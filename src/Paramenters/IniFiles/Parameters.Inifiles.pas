unit Parameters.Inifiles;

{$IF DEFINED(FPC)}
  {$MODE DELPHI} // Ensures DEFINED() and other Delphi features work
{$ENDIF}

{ =============================================================================
  Modulo.Parameters.Inifiles - Implementação de Acesso a Parâmetros em Arquivos INI
  
  Descrição:
  Implementa IParametersInifiles para acesso a parâmetros em arquivos INI.
  Suporta importação/exportação bidirecional com Database.
  
  Formato INI:
  - Título = Sessão
  - Chave e valor = itens da sessão
  - Itens inativos começam com "#" na frente
  - Descrição = comentário na frente de cada item
  - Contrato e produto = sessão separada
  - Ordem = sequência de colocação
  
  Author: Claiton de Souza Linhares
  Version: 1.0.0
  Date: 02/01/2026
  ============================================================================= }

interface

{$I E:\CSL\ORM\src\Paramenters\src\Paramenters.Defines.inc}

Uses
{$IF DEFINED(FPC)}
  SysUtils, Classes, IniFiles, SyncObjs, StrUtils,
{$ELSE}
  System.SysUtils, System.Classes, System.IniFiles,
  System.IOUtils,System.SyncObjs, System.StrUtils,
{$ENDIF}
  Parameters.Interfaces, Parameters.Types, Parameters.Consts,
  Parameters.Exceptions;

type
  { =============================================================================
    TParametersInifiles - Implementação de IParametersInifiles
    ============================================================================= }
  
  TParametersInifiles = class(TInterfacedObject, IParametersInifiles)
  private
    FIniFile: TIniFile;
    FFilePath: string;
    FSection: string;
    FAutoCreateFile: Boolean;
    FContratoID: Integer;
    FProdutoID: Integer;
    FTituloFilter: string; // Filtro de Título para Get (temporário, usado apenas no próximo Get)
    FLock: TCriticalSection;
    
    // Métodos auxiliares privados
    function EnsureFile: Boolean;
    function GetSectionName(const ATitulo: string): string;
    function GetTituloFromSection(const ASection: string): string;
    function ParseComment(const ALine: string): string; // Extrai comentário da linha
    function ParseKey(const ALine: string): string; // Extrai chave da linha (remove # se inativo)
    function ParseValue(const ALine: string): string; // Extrai valor da linha
    function FormatIniLine(const AParameter: TParameter): string; // Formata linha INI com comentário
    function ReadParameterFromIni(const ASection, AKey: string): TParameter;
    procedure WriteParameterToIni(const AParameter: TParameter);
    function GetAllSections: TStringList;
    function ReadIniFileLines: TStringList; // Lê arquivo INI linha por linha preservando comentários
    procedure WriteIniFileLines(ALines: TStringList); // Escreve arquivo INI linha por linha preservando comentários
    function FindSectionInLines(ALines: TStringList; const ASection: string): Integer; // Encontra índice da seção
    function FindKeyInSection(ALines: TStringList; AStartIndex: Integer; const AKey: string): Integer; // Encontra índice da chave na seção
    procedure RemoveEmptySection(ALines: TStringList; ASectionIndex: Integer); // Remove seção vazia (sem chaves válidas)
    function ExistsInSection(const AName, ASection: string): Boolean; // Verifica se chave existe na seção específica
    function GetKeysCountInSection(ALines: TStringList; ASectionIndex: Integer): Integer; // Conta quantas chaves válidas existem na seção
    function GetInsertPositionByOrder(ALines: TStringList; ASectionIndex: Integer; AOrder: Integer): Integer; // Retorna posição de inserção baseada na ordem
    procedure WriteContratoSection(AContratoID, AProdutoID: Integer); // Escreve seção [Contrato] com Contrato_ID e Produto_ID
    procedure ReadContratoSection(out AContratoID, AProdutoID: Integer); // Lê seção [Contrato] com Contrato_ID e Produto_ID
    
  public
    constructor Create; overload;
    constructor Create(const AFilePath: string); overload;
    destructor Destroy; override;
    
    // ========== CONFIGURAÇÃO (Fluent Interface) ==========
    function FilePath(const AValue: string): IParametersInifiles; overload;
    function FilePath: string; overload;
    function Section(const AValue: string): IParametersInifiles; overload;
    function Section: string; overload;
    function AutoCreateFile(const AValue: Boolean): IParametersInifiles; overload;
    function AutoCreateFile: Boolean; overload;
    function ContratoID(const AValue: Integer): IParametersInifiles; overload;
    function ContratoID: Integer; overload;
    function ProdutoID(const AValue: Integer): IParametersInifiles; overload;
    function ProdutoID: Integer; overload;
    function Title(const AValue: string): IParametersInifiles; overload;
    function Title: string; overload;
    
    // ========== CRUD ==========
    function List: TParameterList; overload;
    function List(out AList: TParameterList): IParametersInifiles; overload;
    function Getter(const AName: string): TParameter; overload;
    function Getter(const AName: string; out AParameter: TParameter): IParametersInifiles; overload;
    function Insert(const AParameter: TParameter): IParametersInifiles; overload;
    function Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles; overload;
    function Setter(const AParameter: TParameter): IParametersInifiles; overload;
    function Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles; overload;
    function Update(const AParameter: TParameter): IParametersInifiles; overload; // Deprecated: usar Setter
    function Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles; overload; // Deprecated: usar Setter
    function Delete(const AName: string): IParametersInifiles; overload;
    function Delete(const AName: string; out ASuccess: Boolean): IParametersInifiles; overload;
    function Exists(const AName: string): Boolean; overload;
    function Exists(const AName: string; out AExists: Boolean): IParametersInifiles; overload;
    
    // ========== UTILITÁRIOS ==========
    function Count: Integer; overload;
    function Count(out ACount: Integer): IParametersInifiles; overload;
    function FileExists: Boolean; overload;
    function FileExists(out AExists: Boolean): IParametersInifiles; overload;
    function Refresh: IParametersInifiles;
    
    // ========== IMPORTAÇÃO/EXPORTAÇÃO ==========
    function ImportFromDatabase(ADatabase: IParametersDatabase): IParametersInifiles; overload;
    function ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles; overload;
    function ExportToDatabase(ADatabase: IParametersDatabase): IParametersInifiles; overload;
    function ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles; overload;
    
    // ========== NAVEGAÇÃO ==========
    function EndInifiles: IInterface;
  end;

implementation

{ TParametersInifiles }

constructor TParametersInifiles.Create;
begin
  inherited;
  FIniFile := nil;
  FFilePath := '';
  FSection := '';
  FAutoCreateFile := True;
  FContratoID := 0;
  FProdutoID := 0;
  FTituloFilter := '';
  FLock := TCriticalSection.Create;
end;

constructor TParametersInifiles.Create(const AFilePath: string);
begin
  Create;
  FFilePath := AFilePath;
  EnsureFile;
end;

destructor TParametersInifiles.Destroy;
begin
  FLock.Enter;
  try
    if Assigned(FIniFile) then
      FreeAndNil(FIniFile);
  finally
    FLock.Leave;
  end;
  FreeAndNil(FLock);
  inherited;
end;

function TParametersInifiles.EnsureFile: Boolean;
var
  LDirectory: string;
begin
  Result := False;
  
  if Trim(FFilePath) = '' then
    Exit;
  
  FLock.Enter;
  try
    // Cria diretório se não existir
    LDirectory := ExtractFilePath(FFilePath);
    if (LDirectory <> '') and not DirectoryExists(LDirectory) then
      ForceDirectories(LDirectory);
    
    // Cria arquivo se não existir e AutoCreateFile estiver ativo
    if not {$IFDEF FPC}SysUtils{$ELSE}System.SysUtils{$ENDIF}.FileExists(FFilePath) then
    begin
      if FAutoCreateFile then
      begin
        // Cria arquivo vazio
        TFileStream.Create(FFilePath, fmCreate).Free;
      end
      else
        Exit;
    end;
    
    // Cria ou recria TIniFile
    if Assigned(FIniFile) then
      FreeAndNil(FIniFile);
    
    FIniFile := TIniFile.Create(FFilePath);
    Result := True;
  finally
    FLock.Leave;
  end;
end;

function TParametersInifiles.GetSectionName(const ATitulo: string): string;
begin
  // Seção é o título (sem espaços especiais, pode usar underscore)
  Result := Trim(ATitulo);
  if Result = '' then
    Result := 'Default';
end;

function TParametersInifiles.GetTituloFromSection(const ASection: string): string;
begin
  // Título é o nome da seção
  Result := Trim(ASection);
end;

{ =============================================================================
  ParseComment - Extrai comentário de uma linha INI
  
  Descrição:
  Extrai o comentário de uma linha INI. Comentários em arquivos INI seguem
  o formato padrão: aparecem após o caractere ";" no final da linha.
  
  Formato esperado:
  - chave=valor ; comentário aqui
  
  Comportamento:
  - Busca pelo primeiro ";" na linha
  - Retorna o texto após ";" (trimmed)
  - Se não houver ";", retorna string vazia
  
  Parâmetros:
  - ALine: Linha completa do arquivo INI
  
  Retorno:
  - Comentário extraído (sem o ";") ou string vazia se não houver
  ============================================================================= }
function TParametersInifiles.ParseComment(const ALine: string): string;
var
  LPos: Integer;
begin
  Result := '';
  // Comentário está no final da linha após ";"
  LPos := Pos(';', ALine);
  if LPos > 0 then
  begin
    Result := Trim(Copy(ALine, LPos + 1, MaxInt));
  end;
end;

{ =============================================================================
  ParseKey - Extrai chave de uma linha INI
  
  Descrição:
  Extrai a chave (nome) de uma linha INI, removendo prefixos de inativo (#)
  e comentários. A chave é a parte antes do "=" na linha.
  
  Formato esperado:
  - chave=valor ; comentário
  - #chave=valor ; comentário (inativo)
  
  Comportamento:
  - Remove "#" se a linha começar com ele (indica inativo)
  - Remove comentário (parte após ";")
  - Extrai chave (parte antes do "=")
  - Retorna chave trimmed
  
  Parâmetros:
  - ALine: Linha completa do arquivo INI
  
  Retorno:
  - Nome da chave extraído (sem "#" e sem comentário)
  ============================================================================= }
function TParametersInifiles.ParseKey(const ALine: string): string;
var
  LPos: Integer;
  LLine: string;
begin
  Result := '';
  LLine := Trim(ALine);
  
  // Remove "#" se for linha inativa
  if (LLine <> '') and (LLine[1] = '#') then
    LLine := Trim(Copy(LLine, 2, MaxInt));
  
  // Remove comentário (;)
  LPos := Pos(';', LLine);
  if LPos > 0 then
    LLine := Trim(Copy(LLine, 1, LPos - 1));
  
  // Extrai chave (antes do "=")
  LPos := Pos('=', LLine);
  if LPos > 0 then
    Result := Trim(Copy(LLine, 1, LPos - 1))
  else
    Result := Trim(LLine);
end;

{ =============================================================================
  ParseValue - Extrai valor de uma linha INI
  
  Descrição:
  Extrai o valor de uma linha INI, removendo prefixos de inativo (#) e
  comentários. O valor é a parte após o "=" na linha.
  
  Formato esperado:
  - chave=valor ; comentário
  - #chave=valor ; comentário (inativo)
  
  Comportamento:
  - Remove "#" se a linha começar com ele (indica inativo)
  - Remove comentário (parte após ";")
  - Extrai valor (parte após o "=")
  - Retorna valor trimmed
  
  Parâmetros:
  - ALine: Linha completa do arquivo INI
  
  Retorno:
  - Valor extraído (sem "#" e sem comentário)
  ============================================================================= }
function TParametersInifiles.ParseValue(const ALine: string): string;
var
  LPos: Integer;
  LLine: string;
begin
  Result := '';
  LLine := Trim(ALine);
  
  // Remove "#" se for linha inativa
  if (LLine <> '') and (LLine[1] = '#') then
    LLine := Trim(Copy(LLine, 2, MaxInt));
  
  // Remove comentário (;)
  LPos := Pos(';', LLine);
  if LPos > 0 then
    LLine := Trim(Copy(LLine, 1, LPos - 1));
  
  // Extrai valor (depois do "=")
  LPos := Pos('=', LLine);
  if LPos > 0 then
    Result := Trim(Copy(LLine, LPos + 1, MaxInt));
end;

{ =============================================================================
  FormatIniLine - Formata um parâmetro como linha INI
  
  Descrição:
  Formata um objeto TParameter como uma linha de arquivo INI, preservando
  o formato padrão com comentários e indicador de inativo.
  
  Formato gerado:
  - chave=valor ; comentário (ativo)
  - #chave=valor ; comentário (inativo)
  
  Comportamento:
  - Adiciona "#" na frente da chave se o parâmetro estiver inativo
  - Adiciona comentário após ";" se Description não estiver vazia
  - Preserva formatação padrão do INI
  
  Parâmetros:
  - AParameter: Parâmetro a ser formatado
  
  Retorno:
  - Linha formatada pronta para escrita no arquivo INI
  ============================================================================= }
function TParametersInifiles.FormatIniLine(const AParameter: TParameter): string;
var
  LKey: string;
  LValue: string;
  LComment: string;
begin
  LKey := AParameter.Name;
  LValue := AParameter.Value;
  LComment := AParameter.Description;
  
  // Se inativo, adiciona "#" na frente
  if not AParameter.Ativo then
    LKey := '#' + LKey;
  
  // Formata: chave=valor ; comentário
  Result := Format('%s=%s', [LKey, LValue]);
  if LComment <> '' then
    Result := Result + ' ; ' + LComment;
end;

function TParametersInifiles.ReadParameterFromIni(const ASection, AKey: string): TParameter;
var
  LValue: string;
  LComment: string;
  LIsInactive: Boolean;
  LKeyName: string;
  LLines: TStringList;
  LSectionIndex: Integer;
  LKeyIndex: Integer;
  LLine: string;
  LContratoID: Integer;
  LProdutoID: Integer;
begin
  Result := TParameter.Create;
  try
    Result.Titulo := GetTituloFromSection(ASection);
    LKeyName := AKey;
    LIsInactive := (LKeyName <> '') and (LKeyName[1] = '#');
    
    if LIsInactive then
      LKeyName := Copy(LKeyName, 2, MaxInt);
    
    Result.Name := LKeyName;
    Result.Ativo := not LIsInactive;
    
    // Lê ContratoID e ProdutoID da seção [Contrato]
    ReadContratoSection(LContratoID, LProdutoID);
    
    // Lê valor e comentário do INI linha por linha para preservar comentários
    LLines := ReadIniFileLines;
    try
      LSectionIndex := FindSectionInLines(LLines, ASection);
      if LSectionIndex >= 0 then
      begin
        // Busca pela chave sem o # (se houver)
        LKeyName := ParseKey(AKey);
        LKeyIndex := FindKeyInSection(LLines, LSectionIndex, LKeyName);
        if LKeyIndex >= 0 then
        begin
          LLine := LLines[LKeyIndex];
          LValue := ParseValue(LLine);
          LComment := ParseComment(LLine);
        end
        else
        begin
          LValue := '';
          LComment := '';
        end;
      end
      else
      begin
        LValue := '';
        LComment := '';
      end;
    finally
      LLines.Free;
    end;
    
    Result.Value := LValue;
    Result.Description := LComment;
    Result.ValueType := pvtString; // INI sempre retorna string
    Result.Ordem := 0; // Ordem será determinada pela sequência no arquivo
    Result.ContratoID := LContratoID;
    Result.ProdutoID := LProdutoID;
  except
    Result.Free;
    raise;
  end;
end;

procedure TParametersInifiles.WriteParameterToIni(const AParameter: TParameter);
var
  LSection: string;
  LKey: string;
  LValue: string;
  LComment: string;
  LLines: TStringList;
  LSectionIndex: Integer;
  LKeyIndex: Integer;
  LNewLine: string;
  LOrder: Integer;
  LInsertPosition: Integer;
  I: Integer;
  LKeysCount: Integer;
  LLine: string;
begin
  if Trim(FFilePath) = '' then
    Exit;
  
  // Determina seção: SEMPRE usa o Título (que corresponde à coluna "titulo" do database)
  // O Título é a seção do INI, independente de Contrato/Produto
  if AParameter.Titulo <> '' then
    LSection := GetSectionName(AParameter.Titulo)
  else if FSection <> '' then
    LSection := FSection
  else
    LSection := 'Default';
  
  // Formata chave (com # se inativo)
  LKey := AParameter.Name;
  if not AParameter.Ativo then
    LKey := '#' + LKey;
  
  LValue := AParameter.Value;
  LComment := AParameter.Description;
  
  // Escreve ContratoID e ProdutoID na seção [Contrato]
  WriteContratoSection(AParameter.ContratoID, AParameter.ProdutoID);
  
  // Lê arquivo linha por linha para preservar comentários
  LLines := ReadIniFileLines;
  try
    // Encontra seção
    LSectionIndex := FindSectionInLines(LLines, LSection);
    
    if LSectionIndex < 0 then
    begin
      // Seção não existe, cria no final
      if LLines.Count > 0 then
        LLines.Add('');
      LLines.Add(Format('[%s]', [LSection]));
      LSectionIndex := LLines.Count - 1;
    end;
    
    // Encontra chave na seção (busca pela chave sem o #)
    LKeyIndex := FindKeyInSection(LLines, LSectionIndex, AParameter.Name);
    
    // Determina a ordem desejada
    LOrder := AParameter.Ordem;
    
    // Se ordem vazia (0), calcula automaticamente a próxima ordem disponível
    if LOrder <= 0 then
    begin
      LKeysCount := GetKeysCountInSection(LLines, LSectionIndex);
      // Se a chave já existe, mantém a ordem atual; caso contrário, adiciona no final
      if LKeyIndex >= 0 then
      begin
        // Chave existe: calcula ordem baseada na posição atual
        LOrder := 0;
        I := LSectionIndex + 1;
        while (I < LLines.Count) and (I < LKeyIndex) do
        begin
          LLine := Trim(LLines[I]);
          if (LLine <> '') and (LLine[1] = '[') then
            Break;
          if (LLine <> '') and (LLine[1] <> ';') and (Pos('=', LLine) > 0) then
            Inc(LOrder);
          Inc(I);
        end;
        LOrder := LOrder + 1;
      end
      else
      begin
        // Chave não existe: adiciona no final
        LOrder := LKeysCount + 1;
      end;
    end;
    
    // Formata nova linha com comentário
    LNewLine := FormatIniLine(AParameter);
    
    if LKeyIndex >= 0 then
    begin
      // Chave existe: verifica se precisa mover para nova posição
      LInsertPosition := GetInsertPositionByOrder(LLines, LSectionIndex, LOrder);
      
      // Se a posição desejada é diferente da atual, move a chave
      if LInsertPosition <> LKeyIndex then
      begin
        // Remove da posição atual
        LLines.Delete(LKeyIndex);
        
        // Ajusta posição se necessário (pois a remoção alterou os índices)
        if LInsertPosition > LKeyIndex then
          Dec(LInsertPosition);
        
        // Insere na nova posição
        LLines.Insert(LInsertPosition, LNewLine);
      end
      else
      begin
        // Atualiza linha existente na mesma posição
        LLines[LKeyIndex] := LNewLine;
      end;
    end
    else
    begin
      // Chave não existe: insere na posição baseada na ordem
      LInsertPosition := GetInsertPositionByOrder(LLines, LSectionIndex, LOrder);
      
      // Se a ordem desejada já existe, incrementa as ordens existentes
      // (isso é feito automaticamente pelo GetInsertPositionByOrder que retorna a posição correta)
      LLines.Insert(LInsertPosition, LNewLine);
    end;
    
    // Salva arquivo preservando comentários
    WriteIniFileLines(LLines);
  finally
    LLines.Free;
  end;
end;

function TParametersInifiles.GetAllSections: TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;
  if Assigned(FIniFile) then
  begin
    FIniFile.ReadSections(Result);
    // Remove seção [Contrato] da lista (é apenas referência, não deve ser listada)
    I := Result.IndexOf('Contrato');
    if I >= 0 then
      Result.Delete(I);
  end;
end;

{ =============================================================================
  ReadIniFileLines - Lê arquivo INI linha por linha preservando formatação
  
  Descrição:
  Lê o arquivo INI completo linha por linha, preservando toda a formatação
  original incluindo espaços, comentários e linhas vazias. Isso permite
  modificar apenas as linhas necessárias sem perder a formatação original.
  
  Comportamento:
  - Carrega arquivo completo em TStringList
  - Preserva todas as linhas (incluindo vazias e comentários)
  - Retorna lista vazia se arquivo não existir
  
  Retorno:
  - TStringList com todas as linhas do arquivo (deve ser liberado pelo chamador)
  ============================================================================= }
function TParametersInifiles.ReadIniFileLines: TStringList;
begin
  Result := TStringList.Create;
  if (Trim(FFilePath) <> '') and {$IFDEF FPC}SysUtils{$ELSE}System.SysUtils{$ENDIF}.FileExists(FFilePath) then
    Result.LoadFromFile(FFilePath);
end;

{ =============================================================================
  WriteIniFileLines - Escreve arquivo INI linha por linha preservando formatação
  
  Descrição:
  Escreve o conteúdo de um TStringList de volta no arquivo INI, preservando
  toda a formatação original. Usado após modificações para manter a estrutura
  e comentários do arquivo original.
  
  Comportamento:
  - Salva todas as linhas do TStringList no arquivo
  - Preserva formatação, espaços e comentários
  - Cria arquivo se não existir (se AutoCreateFile estiver habilitado)
  
  Parâmetros:
  - ALines: TStringList com linhas a serem escritas (não é liberado pelo método)
  ============================================================================= }
procedure TParametersInifiles.WriteIniFileLines(ALines: TStringList);
begin
  if (Trim(FFilePath) <> '') and Assigned(ALines) then
  begin
    // Garante que o diretório existe
    ForceDirectories(ExtractFilePath(FFilePath));
    ALines.SaveToFile(FFilePath);
    // Recria TIniFile após salvar
    if Assigned(FIniFile) then
      FreeAndNil(FIniFile);
    FIniFile := TIniFile.Create(FFilePath);
  end;
end;

{ =============================================================================
  FindSectionInLines - Encontra índice de uma seção no arquivo INI
  
  Descrição:
  Busca o índice da linha que contém a seção especificada no formato [Nome].
  Usado para localizar onde começa uma seção antes de adicionar/modificar chaves.
  
  Comportamento:
  - Busca por seção no formato [Nome] (case-insensitive)
  - Retorna -1 se não encontrar
  - Retorna índice da linha se encontrar
  
  Parâmetros:
  - ALines: Lista de linhas do arquivo INI
  - ASection: Nome da seção (sem colchetes)
  
  Retorno:
  - Índice da linha da seção ou -1 se não encontrada
  ============================================================================= }
function TParametersInifiles.FindSectionInLines(ALines: TStringList; const ASection: string): Integer;
var
  I: Integer;
  LLine: string;
begin
  Result := -1;
  for I := 0 to ALines.Count - 1 do
  begin
    LLine := Trim(ALines[I]);
    // Verifica se é uma seção [SectionName]
    if (LLine <> '') and (LLine[1] = '[') and (LLine[Length(LLine)] = ']') then
    begin
      LLine := Copy(LLine, 2, Length(LLine) - 2);
      if SameText(Trim(LLine), ASection) then
      begin
        Result := I;
        Break;
      end;
    end;
  end;
end;

{ =============================================================================
  FindKeyInSection - Encontra índice de uma chave dentro de uma seção
  
  Descrição:
  Busca o índice da linha que contém a chave especificada dentro de uma seção.
  A busca começa após AStartIndex (linha da seção) e para quando encontrar
  outra seção ou fim do arquivo.
  
  Comportamento:
  - Busca apenas dentro da seção (até próxima seção ou fim)
  - Ignora linhas vazias e comentários de linha inteira
  - Remove "#" e comentários antes de comparar chaves
  - Retorna -1 se não encontrar
  
  Parâmetros:
  - ALines: Lista de linhas do arquivo INI
  - AStartIndex: Índice da linha da seção ([Nome])
  - AKey: Nome da chave a buscar
  
  Retorno:
  - Índice da linha da chave ou -1 se não encontrada
  ============================================================================= }
function TParametersInifiles.FindKeyInSection(ALines: TStringList; AStartIndex: Integer; const AKey: string): Integer;
var
  I: Integer;
  LLine: string;
  LKeyName: string;
begin
  Result := -1;
  for I := AStartIndex + 1 to ALines.Count - 1 do
  begin
    LLine := Trim(ALines[I]);
    
    // Se encontrar outra seção, para a busca
    if (LLine <> '') and (LLine[1] = '[') then
      Break;
    
    // Ignora linhas vazias e comentários de linha inteira
    if (LLine = '') or ((LLine[1] = ';') and (Pos('=', LLine) = 0)) then
      Continue;
    
    // Extrai a chave da linha
    LKeyName := ParseKey(LLine);
    if SameText(LKeyName, AKey) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TParametersInifiles.ExistsInSection(const AName, ASection: string): Boolean;
{ Verifica se a chave existe na seção específica.
  Permite chaves com mesmo nome em seções (títulos) diferentes. }
var
  LLines: TStringList;
  LSectionIndex: Integer;
  LKeyIndex: Integer;
begin
  Result := False;
  
  if not EnsureFile then
    Exit;
  
  LLines := ReadIniFileLines;
  try
    LSectionIndex := FindSectionInLines(LLines, ASection);
    if LSectionIndex < 0 then
      Exit; // Seção não existe
    
    LKeyIndex := FindKeyInSection(LLines, LSectionIndex, AName);
    Result := LKeyIndex >= 0;
  finally
    LLines.Free;
  end;
end;

function TParametersInifiles.GetKeysCountInSection(ALines: TStringList; ASectionIndex: Integer): Integer;
var
  I: Integer;
  LLine: string;
begin
  Result := 0;
  for I := ASectionIndex + 1 to ALines.Count - 1 do
  begin
    LLine := Trim(ALines[I]);
    
    // Se encontrar outra seção, para a contagem
    if (LLine <> '') and (LLine[1] = '[') then
      Break;
    
    // Ignora linhas vazias e comentários de linha inteira
    if (LLine = '') or ((LLine[1] = ';') and (Pos('=', LLine) = 0)) then
      Continue;
    
    // Conta apenas linhas com chave=valor (chaves válidas)
    if Pos('=', LLine) > 0 then
      Inc(Result);
  end;
end;

procedure TParametersInifiles.RemoveEmptySection(ALines: TStringList; ASectionIndex: Integer);
{ Remove uma seção vazia do arquivo INI.
  Remove a linha da seção [Nome] e todas as linhas vazias/comentários até a próxima seção ou fim do arquivo. }
var
  I: Integer;
  LLine: string;
  LStartIndex: Integer;
  LEndIndex: Integer;
begin
  if (ASectionIndex < 0) or (ASectionIndex >= ALines.Count) then
    Exit;
  
  // Encontra o início da seção (linha [Nome])
  LStartIndex := ASectionIndex;
  
  // Encontra o fim da seção (próxima seção ou fim do arquivo)
  LEndIndex := ALines.Count;
  for I := ASectionIndex + 1 to ALines.Count - 1 do
  begin
    LLine := Trim(ALines[I]);
    if (LLine <> '') and (LLine[1] = '[') then
    begin
      LEndIndex := I;
      Break;
    end;
  end;
  
  // Remove todas as linhas da seção (incluindo a linha [Nome] e linhas vazias/comentários seguintes)
  // Remove de trás para frente para não alterar os índices
  for I := LEndIndex - 1 downto LStartIndex do
  begin
    LLine := Trim(ALines[I]);
    // Remove linha da seção, linhas vazias e comentários até encontrar outra seção
    if (I = LStartIndex) or (LLine = '') or ((LLine[1] = ';') and (Pos('=', LLine) = 0)) then
      ALines.Delete(I)
    else
      Break; // Para se encontrar conteúdo válido
  end;
end;

function TParametersInifiles.GetInsertPositionByOrder(ALines: TStringList; ASectionIndex: Integer; AOrder: Integer): Integer;
var
  I: Integer;
  LLine: string;
  LCurrentOrder: Integer;
begin
  // Se ordem <= 0, insere no final da seção
  if AOrder <= 0 then
  begin
    Result := ASectionIndex + 1;
    while (Result < ALines.Count) do
    begin
      LLine := Trim(ALines[Result]);
      if (LLine <> '') and (LLine[1] = '[') then
        Break;
      Inc(Result);
    end;
    Exit;
  end;
  
  // Procura a posição correspondente à ordem desejada
  LCurrentOrder := 0;
  Result := ASectionIndex + 1;
  
  for I := ASectionIndex + 1 to ALines.Count - 1 do
  begin
    LLine := Trim(ALines[I]);
    
    // Se encontrar outra seção, para a busca
    if (LLine <> '') and (LLine[1] = '[') then
      Break;
    
    // Ignora linhas vazias e comentários de linha inteira
    if (LLine = '') or ((LLine[1] = ';') and (Pos('=', LLine) = 0)) then
    begin
      // Mantém a posição para inserir após comentários/linhas vazias
      if LCurrentOrder = 0 then
        Result := I + 1;
      Continue;
    end;
    
    // Conta apenas linhas com chave=valor (chaves válidas)
    if Pos('=', LLine) > 0 then
    begin
      Inc(LCurrentOrder);
      
      // Se encontrou a ordem desejada, retorna a posição atual
      // (insere antes desta chave, empurrando-a para baixo)
      if LCurrentOrder >= AOrder then
      begin
        Result := I;
        Exit;
      end;
      
      // Atualiza posição para inserir após esta chave
      Result := I + 1;
    end;
  end;
  
  // Se não encontrou a ordem desejada, insere no final da seção
  // (Result já está na posição correta do loop)
end;

// ========== CONFIGURAÇÃO (Fluent Interface) ==========

function TParametersInifiles.FilePath(const AValue: string): IParametersInifiles;
begin
  FLock.Enter;
  try
    FFilePath := AValue;
    EnsureFile;
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

function TParametersInifiles.FilePath: string;
begin
  FLock.Enter;
  try
    Result := FFilePath;
  finally
    FLock.Leave;
  end;
end;

function TParametersInifiles.Section(const AValue: string): IParametersInifiles;
begin
  FLock.Enter;
  try
    FSection := AValue;
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

function TParametersInifiles.Section: string;
begin
  FLock.Enter;
  try
    Result := FSection;
  finally
    FLock.Leave;
  end;
end;

function TParametersInifiles.AutoCreateFile(const AValue: Boolean): IParametersInifiles;
begin
  FLock.Enter;
  try
    FAutoCreateFile := AValue;
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

function TParametersInifiles.AutoCreateFile: Boolean;
begin
  FLock.Enter;
  try
    Result := FAutoCreateFile;
  finally
    FLock.Leave;
  end;
end;

function TParametersInifiles.ContratoID(const AValue: Integer): IParametersInifiles;
begin
  FLock.Enter;
  try
    FContratoID := AValue;
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

function TParametersInifiles.ContratoID: Integer;
begin
  FLock.Enter;
  try
    Result := FContratoID;
  finally
    FLock.Leave;
  end;
end;

function TParametersInifiles.ProdutoID(const AValue: Integer): IParametersInifiles;
begin
  FLock.Enter;
  try
    FProdutoID := AValue;
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

function TParametersInifiles.ProdutoID: Integer;
begin
  FLock.Enter;
  try
    Result := FProdutoID;
  finally
    FLock.Leave;
  end;
end;

function TParametersInifiles.Title(const AValue: string): IParametersInifiles;
begin
  FLock.Enter;
  try
    FTituloFilter := AValue;
  finally
    FLock.Leave;
  end;
  Result := Self;
end;

function TParametersInifiles.Title: string;
begin
  FLock.Enter;
  try
    Result := FTituloFilter;
  finally
    FLock.Leave;
  end;
end;

// ========== CRUD ==========

function TParametersInifiles.List: TParameterList;
var
  LList: TParameterList;
begin
  List(LList);
  Result := LList;
end;

{ =============================================================================
  List - Lista todos os parâmetros do arquivo INI
  
  Descrição:
  Retorna uma lista de todos os parâmetros do arquivo INI que correspondem
  aos filtros de ContratoID e ProdutoID configurados. A lista preserva a
  ordem dos parâmetros conforme aparecem no arquivo.
  
  Comportamento:
  - Lê todas as seções do arquivo INI (exceto [Contrato])
  - Filtra por ContratoID e ProdutoID se configurados
  - Preserva comentários e formatação do arquivo
  - Parâmetros inativos (prefixo "#") são incluídos com Ativo = False
  - Thread-safe (protegido com TCriticalSection)
  
  Parâmetros:
  - AList: Lista de parâmetros retornada (deve ser liberada pelo chamador)
  
  Retorno:
  - Self (permite encadeamento de métodos - Fluent Interface)
  
  Exceções:
  - EParametersFileException: Se o arquivo não existir e AutoCreateFile = False
  - EParametersInifilesException: Se houver erro ao ler o arquivo
  
  Exemplo:
  var
    Ini: IParametersInifiles;
    ParamList: TParameterList;
  begin
    Ini := TParameters.NewInifiles
      .FilePath('C:\Config\params.ini')
      .ContratoID(1)
      .ProdutoID(1);
    
    ParamList := Ini.List;
    try
      // Usar ParamList...
    finally
      ParamList.Free;
    end;
  end;
  ============================================================================= }
function TParametersInifiles.List(out AList: TParameterList): IParametersInifiles;
var
  LSections: TStringList;
  LKeys: TStringList;
  I, J: Integer;
  LParameter: TParameter;
  LSection: string;
begin
  Result := Self;
  
  if not EnsureFile then
    raise CreateInifilesException(Format(MSG_INI_FILE_CANNOT_READ, [FFilePath]), ERR_INI_FILE_CANNOT_READ, 'List');
  
  AList := TParameterList.Create;
  try
    FLock.Enter;
    try
      LSections := GetAllSections;
      try
        for I := 0 to LSections.Count - 1 do
        begin
          LSection := LSections[I];
          LKeys := TStringList.Create;
          try
            if Assigned(FIniFile) then
              FIniFile.ReadSection(LSection, LKeys);
            
            // Ordem reinicia a cada nova seção (título)
            for J := 0 to LKeys.Count - 1 do
            begin
              LParameter := ReadParameterFromIni(LSection, LKeys[J]);
              // Ordem baseada na sequência dentro da seção (reinicia a cada título)
              LParameter.Ordem := J + 1;
              AList.Add(LParameter);
            end;
          finally
            LKeys.Free;
          end;
        end;
      finally
        LSections.Free;
      end;
    finally
      FLock.Leave;
    end;
  except
    AList.Free;
    raise;
  end;
end;

function TParametersInifiles.Getter(const AName: string): TParameter;
var
  LParameter: TParameter;
begin
  Getter(AName, LParameter);
  Result := LParameter;
end;

function TParametersInifiles.Getter(const AName: string; out AParameter: TParameter): IParametersInifiles;
var
  LSections: TStringList;
  LKeys: TStringList;
  I, J: Integer;
  LSection: string;
  LKey: string;
  LFound: Boolean;
  LHasSpecificSection: Boolean; // Indica se foi especificada uma seção específica
begin
  Result := Self;
  AParameter := nil;
  LFound := False;
  LSection := '';
  LHasSpecificSection := False;
  
  if not EnsureFile then
    raise CreateInifilesException(Format(MSG_INI_FILE_CANNOT_READ, [FFilePath]), ERR_INI_FILE_CANNOT_READ, 'Getter');
  
  FLock.Enter;
  try
    // Se há filtro de título, usa ele para buscar na seção correspondente
    if Trim(FTituloFilter) <> '' then
    begin
      LSection := GetSectionName(FTituloFilter);
      LHasSpecificSection := True; // Marca que foi especificada uma seção específica
      FTituloFilter := ''; // Limpa o filtro após usar (é temporário)
    end
    else if FSection <> '' then
    begin
      // Busca apenas na seção especificada
      LSection := FSection;
      LHasSpecificSection := True; // Marca que foi especificada uma seção específica
    end;
    
    if LSection <> '' then
    begin
      // Verifica se a seção existe antes de buscar
      LSections := GetAllSections;
      try
        // Se a seção especificada não existe, retorna nil (não busca em todas)
        if LSections.IndexOf(LSection) < 0 then
        begin
          AParameter := nil;
          Exit; // Seção não existe, retorna nil
        end;
      finally
        LSections.Free;
      end;
      
      LKeys := TStringList.Create;
      try
        if Assigned(FIniFile) then
          FIniFile.ReadSection(LSection, LKeys);
        
        for J := 0 to LKeys.Count - 1 do
        begin
          LKey := ParseKey(LKeys[J]);
          if SameText(LKey, AName) then
          begin
            AParameter := ReadParameterFromIni(LSection, LKeys[J]);
            // Calcula a ordem baseada na posição dentro da seção (reinicia a cada título)
            AParameter.Ordem := J + 1;
            LFound := True;
            Break;
          end;
        end;
      finally
        LKeys.Free;
      end;
      
      // Se foi especificada uma seção específica e não encontrou, retorna nil
      // (não busca em todas as seções)
      if LHasSpecificSection and not LFound then
      begin
        AParameter := nil;
        Exit;
      end;
    end;
    
    // Só busca em todas as seções se NÃO foi especificada uma seção específica
    if not LHasSpecificSection and not LFound then
    begin
      // Busca em todas as seções
      LSections := GetAllSections;
      try
        for I := 0 to LSections.Count - 1 do
        begin
          LSection := LSections[I];
          LKeys := TStringList.Create;
          try
            if Assigned(FIniFile) then
              FIniFile.ReadSection(LSection, LKeys);
            
            for J := 0 to LKeys.Count - 1 do
            begin
              LKey := ParseKey(LKeys[J]);
              if SameText(LKey, AName) then
              begin
                AParameter := ReadParameterFromIni(LSection, LKeys[J]);
                LFound := True;
                Break;
              end;
            end;
          finally
            LKeys.Free;
          end;
          
          if LFound then
            Break;
        end;
      finally
        LSections.Free;
      end;
    end;
  finally
    FLock.Leave;
  end;
  
  // Retorna nil se não encontrou (não cria parâmetro vazio)
  // Isso permite que o código chamador verifique se Assigned(AParameter)
  if not LFound then
    AParameter := nil;
end;

function TParametersInifiles.Insert(const AParameter: TParameter): IParametersInifiles;
var
  LSuccess: Boolean;
begin
  Insert(AParameter, LSuccess);
  Result := Self;
end;

function TParametersInifiles.Insert(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;
var
  LSection: string;
  LExists: Boolean;
begin
  Result := Self;
  ASuccess := False;
  
  if not EnsureFile then
    raise CreateInifilesException(Format(MSG_INI_FILE_CANNOT_WRITE, [FFilePath]), ERR_INI_FILE_CANNOT_WRITE, 'Insert');
  
  FLock.Enter;
  try
    // Determina seção baseada no título
    if AParameter.Titulo <> '' then
      LSection := GetSectionName(AParameter.Titulo)
    else if FSection <> '' then
      LSection := FSection
    else
      LSection := 'Default';
    
    // Verifica se a chave já existe na mesma seção (título)
    // Permite chaves com mesmo nome em seções (títulos) diferentes
    LExists := ExistsInSection(AParameter.Name, LSection);
    
    if LExists then
    begin
      ASuccess := False;
      Exit;
    end;
    
    WriteParameterToIni(AParameter);
    ASuccess := True;
  finally
    FLock.Leave;
  end;
end;

function TParametersInifiles.Setter(const AParameter: TParameter): IParametersInifiles;
var
  LSuccess: Boolean;
begin
  Setter(AParameter, LSuccess);
  Result := Self;
end;

{ =============================================================================
  Setter - Insere ou atualiza um parâmetro no arquivo INI
  
  Descrição:
  Insere um novo parâmetro se não existir, ou atualiza se já existir.
  Sempre respeita a hierarquia: contrato_id, produto_id, titulo, chave.
  
  Comportamento:
  - Verifica se o parâmetro existe usando a hierarquia completa
  - Se existir: faz UPDATE (remove da seção antiga e escreve na nova)
  - Se não existir: faz INSERT
  - Thread-safe (protegido com TCriticalSection)
  
  Parâmetros:
  - AParameter: Parâmetro a ser inserido/atualizado (deve ter ContratoID, ProdutoID, Titulo e Name preenchidos)
  - ASuccess: Indica se a operação foi bem-sucedida
  
  Retorno:
  - Self (permite encadeamento de métodos - Fluent Interface)
  ============================================================================= }
function TParametersInifiles.Setter(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;
var
  LExists: Boolean;
begin
  Result := Self;
  ASuccess := False;
  
  // IMPORTANTE: Valida que todos os campos da hierarquia estão preenchidos
  // Hierarquia: contrato_id, produto_id, titulo, chave
  if (AParameter.ContratoID <= 0) or (AParameter.ProdutoID <= 0) or 
     (Trim(AParameter.Titulo) = '') or (Trim(AParameter.Name) = '') then
    raise CreateConfigurationException(
      Format('Setter requer ContratoID, ProdutoID, Titulo e Name preenchidos. Recebido: ContratoID=%d, ProdutoID=%d, Titulo=''%s'', Name=''%s''', 
        [AParameter.ContratoID, AParameter.ProdutoID, AParameter.Titulo, AParameter.Name]),
      ERR_INVALID_CONFIGURATION,
      'Setter'
    );
  
  if not EnsureFile then
    raise CreateInifilesException(Format(MSG_INI_FILE_CANNOT_WRITE, [FFilePath]), ERR_INI_FILE_CANNOT_WRITE, 'Setter');
  
  FLock.Enter;
  try
    // Verifica se existe usando a hierarquia completa (título + chave)
    FTituloFilter := AParameter.Titulo;
    LExists := Exists(AParameter.Name);
    FTituloFilter := ''; // Limpa após usar
    
    if LExists then
    begin
      // EXISTE: Faz UPDATE (remove da seção antiga e escreve na nova)
      FTituloFilter := AParameter.Titulo;
      Delete(AParameter.Name);
      FTituloFilter := ''; // Limpa após usar
    end;
    // Se não existir, apenas insere (não precisa deletar nada)
    
    // Escreve nova chave (com título do parâmetro)
    WriteParameterToIni(AParameter);
    ASuccess := True;
  finally
    FLock.Leave;
  end;
end;

// Método Update mantido para compatibilidade (deprecated - usar Setter)
function TParametersInifiles.Update(const AParameter: TParameter): IParametersInifiles;
var
  LSuccess: Boolean;
begin
  Result := Setter(AParameter, LSuccess);
end;

function TParametersInifiles.Update(const AParameter: TParameter; out ASuccess: Boolean): IParametersInifiles;
begin
  Result := Setter(AParameter, ASuccess);
end;

function TParametersInifiles.Delete(const AName: string): IParametersInifiles;
var
  LSuccess: Boolean;
begin
  Delete(AName, LSuccess);
  Result := Self;
end;

function TParametersInifiles.Delete(const AName: string; out ASuccess: Boolean): IParametersInifiles;
var
  LSections: TStringList;
  LLines: TStringList;
  I, J: Integer;
  LSection: string;
  LSectionIndex: Integer;
  LKeyIndex: Integer;
  LKeyName: string;
  LFound: Boolean;
begin
  Result := Self;
  ASuccess := False;
  LFound := False;
  
  if not EnsureFile then
    raise CreateInifilesException(Format(MSG_INI_FILE_CANNOT_WRITE, [FFilePath]), ERR_INI_FILE_CANNOT_WRITE, 'Delete');
  
  FLock.Enter;
  try
    // Lê arquivo linha por linha para preservar comentários
    LLines := ReadIniFileLines;
    try
      // IMPORTANTE: Usa título (seção) para identificar onde deletar
      // Se há filtro de título, usa ele; senão usa FSection se configurado
      if Trim(FTituloFilter) <> '' then
      begin
        // Remove apenas da seção correspondente ao título
        LSection := GetSectionName(FTituloFilter);
        FTituloFilter := ''; // Limpa após usar (é temporário)
        LSectionIndex := FindSectionInLines(LLines, LSection);
        
        if LSectionIndex >= 0 then
        begin
          // Busca pela chave na seção (busca pela chave sem o #)
          LKeyIndex := FindKeyInSection(LLines, LSectionIndex, AName);
          
          if LKeyIndex >= 0 then
          begin
            // Remove a linha
            LLines.Delete(LKeyIndex);
            LFound := True;
            
            // Verifica se a seção ficou vazia (sem chaves válidas) e remove se necessário
            // Ignora seções especiais como [Contrato]
            if (GetKeysCountInSection(LLines, LSectionIndex) = 0) and 
               (not SameText(LSection, 'Contrato')) then
            begin
              RemoveEmptySection(LLines, LSectionIndex);
            end;
          end;
        end;
      end
      else if FSection <> '' then
      begin
        // Remove apenas da seção especificada
        LSection := FSection;
        LSectionIndex := FindSectionInLines(LLines, LSection);
        
        if LSectionIndex >= 0 then
        begin
          // Busca pela chave na seção (busca pela chave sem o #)
          LKeyIndex := FindKeyInSection(LLines, LSectionIndex, AName);
          
          if LKeyIndex >= 0 then
          begin
            // Remove a linha
            LLines.Delete(LKeyIndex);
            LFound := True;
            
            // Verifica se a seção ficou vazia (sem chaves válidas) e remove se necessário
            // Ignora seções especiais como [Contrato]
            if (GetKeysCountInSection(LLines, LSectionIndex) = 0) and 
               (not SameText(LSection, 'Contrato')) then
            begin
              RemoveEmptySection(LLines, LSectionIndex);
            end;
          end;
        end;
      end
      else
      begin
        // Comportamento antigo para compatibilidade: Remove de todas as seções
        LSections := GetAllSections;
        try
          for I := 0 to LSections.Count - 1 do
          begin
            LSection := LSections[I];
            LSectionIndex := FindSectionInLines(LLines, LSection);
            
            if LSectionIndex >= 0 then
            begin
              // Busca pela chave na seção (busca pela chave sem o #)
              LKeyIndex := FindKeyInSection(LLines, LSectionIndex, AName);
              
              if LKeyIndex >= 0 then
              begin
                // Remove a linha
                LLines.Delete(LKeyIndex);
                LFound := True;
                
                // Verifica se a seção ficou vazia (sem chaves válidas) e remove se necessário
                // Ignora seções especiais como [Contrato]
                if (GetKeysCountInSection(LLines, LSectionIndex) = 0) and 
                   (not SameText(LSection, 'Contrato')) then
                begin
                  RemoveEmptySection(LLines, LSectionIndex);
                end;
                
                Break; // Remove apenas a primeira ocorrência
              end;
            end;
          end;
        finally
          LSections.Free;
        end;
      end;
      
      // Salva arquivo preservando comentários
      if LFound then
        WriteIniFileLines(LLines);
      
      ASuccess := LFound;
    finally
      LLines.Free;
    end;
  finally
    FLock.Leave;
  end;
end;

function TParametersInifiles.Exists(const AName: string): Boolean;
var
  LExists: Boolean;
begin
  Exists(AName, LExists);
  Result := LExists;
end;

function TParametersInifiles.Exists(const AName: string; out AExists: Boolean): IParametersInifiles;
var
  LSections: TStringList;
  LKeys: TStringList;
  I, J: Integer;
  LSection: string;
  LKey: string;
  LHasSpecificSection: Boolean; // Indica se foi especificada uma seção específica
begin
  Result := Self;
  AExists := False;
  LHasSpecificSection := False;
  
  if not EnsureFile then
  begin
    AExists := False;
    Exit;
  end;
  
  FLock.Enter;
  try
    // IMPORTANTE: Usa título (seção) para identificar onde buscar
    // Se há filtro de título, usa ele; senão usa FSection se configurado
    if Trim(FTituloFilter) <> '' then
    begin
      // Busca apenas na seção correspondente ao título
      LSection := GetSectionName(FTituloFilter);
      LHasSpecificSection := True; // Marca que foi especificada uma seção específica
      FTituloFilter := ''; // Limpa após usar (é temporário)
      
      // Verifica se a seção existe antes de buscar
      LSections := GetAllSections;
      try
        // Se a seção especificada não existe, retorna False (não busca em todas)
        if LSections.IndexOf(LSection) < 0 then
        begin
          AExists := False;
          Exit; // Seção não existe, retorna False
        end;
      finally
        LSections.Free;
      end;
      
      LKeys := TStringList.Create;
      try
        if Assigned(FIniFile) then
          FIniFile.ReadSection(LSection, LKeys);
        
        for J := 0 to LKeys.Count - 1 do
        begin
          LKey := ParseKey(LKeys[J]);
          if SameText(LKey, AName) then
          begin
            AExists := True;
            Break;
          end;
        end;
      finally
        LKeys.Free;
      end;
    end
    else if FSection <> '' then
    begin
      // Busca apenas na seção especificada
      LSection := FSection;
      LHasSpecificSection := True; // Marca que foi especificada uma seção específica
      
      // Verifica se a seção existe antes de buscar
      LSections := GetAllSections;
      try
        // Se a seção especificada não existe, retorna False (não busca em todas)
        if LSections.IndexOf(LSection) < 0 then
        begin
          AExists := False;
          Exit; // Seção não existe, retorna False
        end;
      finally
        LSections.Free;
      end;
      
      LKeys := TStringList.Create;
      try
        if Assigned(FIniFile) then
          FIniFile.ReadSection(LSection, LKeys);
        
        for J := 0 to LKeys.Count - 1 do
        begin
          LKey := ParseKey(LKeys[J]);
          if SameText(LKey, AName) then
          begin
            AExists := True;
            Break;
          end;
        end;
      finally
        LKeys.Free;
      end;
    end
    else
    begin
      // Comportamento antigo para compatibilidade: Busca em todas as seções
      LSections := GetAllSections;
      try
        for I := 0 to LSections.Count - 1 do
        begin
          LSection := LSections[I];
          LKeys := TStringList.Create;
          try
            if Assigned(FIniFile) then
              FIniFile.ReadSection(LSection, LKeys);
            
            for J := 0 to LKeys.Count - 1 do
            begin
              LKey := ParseKey(LKeys[J]);
              if SameText(LKey, AName) then
              begin
                AExists := True;
                Break;
              end;
            end;
          finally
            LKeys.Free;
          end;
          
          if AExists then
            Break;
        end;
      finally
        LSections.Free;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

// ========== UTILITÁRIOS ==========

function TParametersInifiles.Count: Integer;
var
  LCount: Integer;
begin
  Count(LCount);
  Result := LCount;
end;

function TParametersInifiles.Count(out ACount: Integer): IParametersInifiles;
var
  LList: TParameterList;
begin
  Result := Self;
  ACount := 0;
  
  try
    List(LList);
    try
      ACount := LList.Count;
    finally
      LList.Free;
    end;
  except
    ACount := 0;
  end;
end;

function TParametersInifiles.FileExists: Boolean;
var
  LExists: Boolean;
begin
  FileExists(LExists);
  Result := LExists;
end;

function TParametersInifiles.FileExists(out AExists: Boolean): IParametersInifiles;
begin
  Result := Self;
  FLock.Enter;
  try
    AExists := (Trim(FFilePath) <> '') and {$IFDEF FPC}SysUtils{$ELSE}System.SysUtils{$ENDIF}.FileExists(FFilePath);
  finally
    FLock.Leave;
  end;
end;

function TParametersInifiles.Refresh: IParametersInifiles;
begin
  Result := Self;
  FLock.Enter;
  try
    if Assigned(FIniFile) then
      FreeAndNil(FIniFile);
    EnsureFile;
  finally
    FLock.Leave;
  end;
end;

// ========== IMPORTAÇÃO/EXPORTAÇÃO ==========

function TParametersInifiles.ImportFromDatabase(ADatabase: IParametersDatabase): IParametersInifiles;
var
  LSuccess: Boolean;
begin
  ImportFromDatabase(ADatabase, LSuccess);
  Result := Self;
end;

function TParametersInifiles.ImportFromDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles;
var
  LList: TParameterList;
  I: Integer;
  LParameter: TParameter;
  LContratoID: Integer;
  LProdutoID: Integer;
begin
  Result := Self;
  ASuccess := False;
  
  if not Assigned(ADatabase) then
    Exit;
  
  if not EnsureFile then
    raise CreateInifilesException(Format(MSG_INI_FILE_CANNOT_WRITE, [FFilePath]), ERR_INI_FILE_CANNOT_WRITE, 'ImportFromDatabase');
  
  try
    // Configura filtros no Database antes de listar
    // Isso faz com que a query SQL já venha filtrada do banco
    LContratoID := FContratoID;
    LProdutoID := FProdutoID;
    
    if (LContratoID > 0) or (LProdutoID > 0) then
    begin
      // Configura filtros no Database para que a query SQL já venha filtrada
      ADatabase.ContratoID(LContratoID).ProdutoID(LProdutoID);
    end;
    
    // Obtém parâmetros do Database (já filtrados pela query SQL se filtros foram configurados)
    ADatabase.List(LList);
    try
      FLock.Enter;
      try
        // Limpa arquivo INI atual (opcional - pode ser comentado para adicionar ao invés de substituir)
        // FIniFile.EraseSection('Default'); // Se necessário
        
        // Importa todos os parâmetros retornados (já filtrados pela query SQL)
        for I := 0 to LList.Count - 1 do
        begin
          LParameter := LList[I];
          WriteParameterToIni(LParameter);
          
          // Se não havia filtro, atualiza com os valores do primeiro parâmetro importado
          // Isso garante que a seção [Contrato] tenha os valores corretos
          if (LContratoID = 0) and (LProdutoID = 0) then
          begin
            LContratoID := LParameter.ContratoID;
            LProdutoID := LParameter.ProdutoID;
          end;
        end;
        
        // Escreve seção [Contrato] com os valores do grupo importado
        // Se havia filtro, usa os valores do filtro; caso contrário, usa os valores do primeiro parâmetro
        if (LContratoID > 0) or (LProdutoID > 0) then
          WriteContratoSection(LContratoID, LProdutoID);
        
        ASuccess := True;
      finally
        FLock.Leave;
      end;
    finally
      LList.Free;
    end;
  except
    ASuccess := False;
    raise;
  end;
end;

function TParametersInifiles.ExportToDatabase(ADatabase: IParametersDatabase): IParametersInifiles;
var
  LSuccess: Boolean;
begin
  ExportToDatabase(ADatabase, LSuccess);
  Result := Self;
end;

function TParametersInifiles.ExportToDatabase(ADatabase: IParametersDatabase; out ASuccess: Boolean): IParametersInifiles;
var
  LList: TParameterList;
  I: Integer;
  LParameter: TParameter;
begin
  Result := Self;
  ASuccess := False;
  
  if not Assigned(ADatabase) then
    Exit;
  
  if not EnsureFile then
    raise CreateInifilesException(Format(MSG_INI_FILE_CANNOT_READ, [FFilePath]), ERR_INI_FILE_CANNOT_READ, 'ExportToDatabase');
  
  try
    // Obtém todos os parâmetros do INI
    List(LList);
    try
      // Exporta cada parâmetro para o Database
      for I := 0 to LList.Count - 1 do
      begin
        LParameter := LList[I];
        
        // Verifica se já existe no Database
        if ADatabase.Exists(LParameter.Name) then
          ADatabase.Setter(LParameter)
        else
          ADatabase.Insert(LParameter);
      end;
      
      ASuccess := True;
    finally
      LList.Free;
    end;
  except
    ASuccess := False;
    raise;
  end;
end;

// ========== NAVEGAÇÃO ==========

function TParametersInifiles.EndInifiles: IInterface;
begin
  Result := Self;
end;

// ========== MÉTODOS AUXILIARES PARA SEÇÃO [Contrato] ==========

procedure TParametersInifiles.WriteContratoSection(AContratoID, AProdutoID: Integer);
var
  LLines: TStringList;
  LSectionIndex: Integer;
  LKeyIndex: Integer;
  I: Integer;
begin
  if Trim(FFilePath) = '' then
    Exit;
  
  LLines := ReadIniFileLines;
  try
    // Encontra seção [Contrato]
    LSectionIndex := FindSectionInLines(LLines, 'Contrato');
    
    if LSectionIndex < 0 then
    begin
      // Seção [Contrato] não existe, cria no início do arquivo
      LLines.Insert(0, '[Contrato]');
      LLines.Insert(1, Format('Contrato_ID=%d', [AContratoID]));
      LLines.Insert(2, Format('Produto_ID=%d', [AProdutoID]));
      if LLines.Count > 3 then
        LLines.Insert(3, '');
    end
    else
    begin
      // Seção [Contrato] existe: atualiza ou cria Contrato_ID e Produto_ID
      LKeyIndex := FindKeyInSection(LLines, LSectionIndex, 'Contrato_ID');
      if LKeyIndex >= 0 then
        LLines[LKeyIndex] := Format('Contrato_ID=%d', [AContratoID])
      else
      begin
        // Insere Contrato_ID após a seção
        I := LSectionIndex + 1;
        while (I < LLines.Count) do
        begin
          if (Trim(LLines[I]) <> '') and (Trim(LLines[I])[1] = '[') then
            Break;
          Inc(I);
        end;
        LLines.Insert(I, Format('Contrato_ID=%d', [AContratoID]));
      end;
      
      LKeyIndex := FindKeyInSection(LLines, LSectionIndex, 'Produto_ID');
      if LKeyIndex >= 0 then
        LLines[LKeyIndex] := Format('Produto_ID=%d', [AProdutoID])
      else
      begin
        // Insere Produto_ID após Contrato_ID ou após a seção
        I := LSectionIndex + 1;
        while (I < LLines.Count) do
        begin
          if (Trim(LLines[I]) <> '') and (Trim(LLines[I])[1] = '[') then
            Break;
          if SameText(ParseKey(LLines[I]), 'Contrato_ID') then
          begin
            Inc(I);
            Break;
          end;
          Inc(I);
        end;
        LLines.Insert(I, Format('Produto_ID=%d', [AProdutoID]));
      end;
    end;
    
    WriteIniFileLines(LLines);
  finally
    LLines.Free;
  end;
end;

procedure TParametersInifiles.ReadContratoSection(out AContratoID, AProdutoID: Integer);
var
  LLines: TStringList;
  LSectionIndex: Integer;
  LKeyIndex: Integer;
  LLine: string;
begin
  AContratoID := 0;
  AProdutoID := 0;
  
  if Trim(FFilePath) = '' then
    Exit;
  
  LLines := ReadIniFileLines;
  try
    // Encontra seção [Contrato]
    LSectionIndex := FindSectionInLines(LLines, 'Contrato');
    
    if LSectionIndex >= 0 then
    begin
      // Lê Contrato_ID
      LKeyIndex := FindKeyInSection(LLines, LSectionIndex, 'Contrato_ID');
      if LKeyIndex >= 0 then
      begin
        LLine := LLines[LKeyIndex];
        AContratoID := StrToIntDef(ParseValue(LLine), 0);
      end;
      
      // Lê Produto_ID
      LKeyIndex := FindKeyInSection(LLines, LSectionIndex, 'Produto_ID');
      if LKeyIndex >= 0 then
      begin
        LLine := LLines[LKeyIndex];
        AProdutoID := StrToIntDef(ParseValue(LLine), 0);
      end;
    end;
  finally
    LLines.Free;
  end;
end;

end.
