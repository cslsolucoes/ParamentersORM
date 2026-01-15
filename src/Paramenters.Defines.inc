(*===============================================================================
  ParamentersORM.Defines.inc - Directivas de Compila��o para Engines

  Este arquivo define quais engines ser�o inclu�dos na compila��o.
  
  MODO DE OPERA��O:
  ================
  1. DETEC��O AUTOM�TICA (RECOMENDADO):
     - Descomente a se��o "DETEC��O AUTOM�TICA" abaixo
     - O sistema detectar� automaticamente quais engines est�o dispon�veis
     - Se m�ltiplos estiverem dispon�veis, ser� usado o primeiro encontrado na ordem:
       UNIDAC > FireDAC > Zeos
     - Avisos ser�o emitidos se m�ltiplos estiverem dispon�veis
  
  2. MODO MANUAL:
     - Comente ou descomente as diretivas {$DEFINE USE_*} abaixo
     - Voc� tem controle total sobre qual engine usar
     - Certifique-se de que pelo menos UM engine esteja ativo

  IMPORTANTE:
    - Sempre mantenha pelo menos UM engine ativo
    - LDAP � sempre inclu�do (n�o requer componentes externos)
    - Se voc� definir manualmente uma diretiva, ela ter� prioridade sobre a detec��o autom�tica

  Vers�o: 1.0.0
  Autor: Claiton de Souza Linhares
  Data: 02/01/2026
===============================================================================*)

(*===============================================================================
  DETEC��O AUTOM�TICA DE ENGINES (RECOMENDADO)
  =============================================
  Descomente a linha abaixo para ativar a detec��o autom�tica:
  {$DEFINE AUTO_DETECT_ENGINES}

  Com a detec��o autom�tica ativada, o sistema ir�:
  - Detectar automaticamente quais engines est�o dispon�veis
  - Selecionar o primeiro dispon�vel na ordem: UNIDAC > FireDAC > Zeos
  - Emitir avisos se m�ltiplos estiverem dispon�veis
  - Permitir override manual se voc� definir uma diretiva antes desta se��o
===============================================================================*)

// Descomente a linha abaixo para ativar detec��o autom�tica:
//{$DEFINE AUTO_DETECT_ENGINES}

{===============================================================================
  CONFIGURA��O MANUAL DE ENGINES
  ================================
  Use esta se��o se preferir definir manualmente qual engine usar.
  Se AUTO_DETECT_ENGINES estiver ativo, estas defini��es ter�o prioridade.
===============================================================================}

// Modo Manual - Descomente APENAS o engine que deseja usar:

// UNIDAC - Universal Data Access Components
// Requer: Uni, UniProvider, PostgreSQLUniProvider, SQLServerUniProvider, etc.
//{$DEFINE USE_UNIDAC}

// FireDAC - Framework de acesso a dados da Embarcadero
// Requer: FireDAC.* (j� inclu�do no Delphi desde XE7)
//{$DEFINE USE_FIREDAC}

// Zeos - Biblioteca de acesso a dados open-source
// Requer: ZAbstractConnection, ZConnection
{$DEFINE USE_ZEOS}

// ========== VALIDA��O: MODO MANUAL ==========
// Verifica se mais de um engine est� selecionado e emite erro fatal
// Compat�vel com Delphi e FPC (Free Pascal Compiler)

{$IF DEFINED(AUTO_DETECT_ENGINES)}
  // Valida��o apenas no modo AUTO_DETECT_ENGINES
  {$IF DEFINED(USE_UNIDAC)}
    {$IF DEFINED(USE_FIREDAC)}
      {$IF DEFINED(FPC)}
        {$ERROR 'ProvidersORM: ERRO - M�ltiplos engines selecionados no modo manual!'}
        {$ERROR 'Voc� definiu USE_UNIDAC e USE_FIREDAC simultaneamente.'}
        {$ERROR 'No modo manual, descomente APENAS UM engine. Comente os outros.'}
        {$ERROR 'Comente uma das diretivas {$DEFINE USE_*} acima.'}
      {$ELSE}
        {$MESSAGE FATAL 'ProvidersORM: ERRO - M�ltiplos engines selecionados no modo manual!'}
        {$MESSAGE FATAL 'Voc� definiu USE_UNIDAC e USE_FIREDAC simultaneamente.'}
        {$MESSAGE FATAL 'No modo manual, descomente APENAS UM engine. Comente os outros.'}
        {$MESSAGE FATAL 'Comente uma das diretivas {$DEFINE USE_*} acima.'}
      {$ENDIF}
    {$ENDIF}
    {$IF DEFINED(USE_ZEOS)}
      {$IF DEFINED(FPC)}
        {$ERROR 'ProvidersORM: ERRO - M�ltiplos engines selecionados no modo manual!'}
        {$ERROR 'Voc� definiu USE_UNIDAC e USE_ZEOS simultaneamente.'}
        {$ERROR 'No modo manual, descomente APENAS UM engine. Comente os outros.'}
        {$ERROR 'Comente uma das diretivas {$DEFINE USE_*} acima.'}
      {$ELSE}
        {$MESSAGE FATAL 'ProvidersORM: ERRO - M�ltiplos engines selecionados no modo manual!'}
        {$MESSAGE FATAL 'Voc� definiu USE_UNIDAC e USE_ZEOS simultaneamente.'}
        {$MESSAGE FATAL 'No modo manual, descomente APENAS UM engine. Comente os outros.'}
        {$MESSAGE FATAL 'Comente uma das diretivas {$DEFINE USE_*} acima.'}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IF DEFINED(USE_FIREDAC)}
    {$IF DEFINED(USE_ZEOS)}
      {$IF DEFINED(FPC)}
        {$ERROR 'ProvidersORM: ERRO - M�ltiplos engines selecionados no modo manual!'}
        {$ERROR 'Voc� definiu USE_FIREDAC e USE_ZEOS simultaneamente.'}
        {$ERROR 'No modo manual, descomente APENAS UM engine. Comente os outros.'}
        {$ERROR 'Comente uma das diretivas {$DEFINE USE_*} acima.'}
      {$ELSE}
        {$MESSAGE FATAL 'ProvidersORM: ERRO - M�ltiplos engines selecionados no modo manual!'}
        {$MESSAGE FATAL 'Voc� definiu USE_FIREDAC e USE_ZEOS simultaneamente.'}
        {$MESSAGE FATAL 'No modo manual, descomente APENAS UM engine. Comente os outros.'}
        {$MESSAGE FATAL 'Comente uma das diretivas {$DEFINE USE_*} acima.'}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  // Verifica se nenhum engine est� selecionado
  {$IF NOT DEFINED(USE_UNIDAC)}
    {$IF NOT DEFINED(USE_FIREDAC)}
      {$IF NOT DEFINED(USE_ZEOS)}
        {$IF DEFINED(FPC)}
          {$ERROR 'ProvidersORM: ERRO - Nenhum engine selecionado no modo manual!'}
          {$ERROR 'No modo manual, voc� deve descomentar EXATAMENTE UM engine.'}
          {$ERROR 'Descomente uma das diretivas {$DEFINE USE_*} acima (USE_UNIDAC, USE_FIREDAC ou USE_ZEOS).'}
        {$ELSE}
          {$MESSAGE FATAL 'ProvidersORM: ERRO - Nenhum engine selecionado no modo manual!'}
          {$MESSAGE FATAL 'No modo manual, voc� deve descomentar EXATAMENTE UM engine.'}
          {$MESSAGE FATAL 'Descomente uma das diretivas {$DEFINE USE_*} acima (USE_UNIDAC, USE_FIREDAC ou USE_ZEOS).'}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{===============================================================================
  DETEC��O AUTOM�TICA DE ENGINES (IMPLEMENTA��O)
  ===============================================
  Esta se��o detecta automaticamente quais engines est�o dispon�veis
  e define as diretivas correspondentes.

  ESTRAT�GIA DE DETEC��O:
  - Se nenhum engine foi definido manualmente, tenta detectar baseado na vers�o do Delphi
  - FireDAC est� dispon�vel nativamente desde Delphi XE7 (VER280+)
  - UNIDAC e Zeos requerem instala��o manual, ent�o assumimos que se n�o estiverem
    definidos manualmente, provavelmente n�o est�o dispon�veis
  - Prioridade: UNIDAC > FireDAC > Zeos
===============================================================================}

{$IF NOT DEFINED(AUTO_DETECT_ENGINES)}
  // Se nenhum engine foi definido manualmente, tentar detec��o autom�tica
  {$IF NOT DEFINED(USE_UNIDAC)}
    {$IF NOT DEFINED(USE_FIREDAC)}
      {$IF NOT DEFINED(USE_ZEOS)}
        // Nenhum engine definido - iniciar detec��o autom�tica baseada em vers�o do Delphi

        {$IF DEFINED(FPC)}
          // FPC (Free Pascal Compiler) - FireDAC n�o est� dispon�vel
          // Usa Zeos como padr�o (open-source, compat�vel com FPC)
          {$DEFINE USE_ZEOS}
          {$MESSAGE 'Detec��o autom�tica (FPC): Zeos selecionado (FireDAC n�o est� dispon�vel no FPC)'}
        {$ELSE}
          // Delphi - FireDAC est� dispon�vel nativamente desde Delphi XE7
          {$IF DEFINED(VER280)}  // Delphi XE7 ou superior
            {$DEFINE USE_FIREDAC}
            {$MESSAGE 'Detec��o autom�tica: FireDAC detectado (dispon�vel desde Delphi XE7)'}
          {$ELSE}
            // Vers�es anteriores ao XE7 - assumir UNIDAC (mais comum em vers�es antigas)
            // NOTA: Se voc� n�o tem UNIDAC, descomente USE_FIREDAC ou USE_ZEOS manualmente
            {$DEFINE USE_UNIDAC}
            {$MESSAGE 'Detec��o autom�tica: Assumindo UNIDAC (vers�o anterior ao XE7). Se n�o tiver UNIDAC, defina manualmente USE_FIREDAC ou USE_ZEOS.'}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{===============================================================================
  COMPATIBILIDADE FPC (Free Pascal Compiler)
  ===========================================
  FireDAC n�o est� dispon�vel no FPC, ent�o desativa automaticamente se estiver definido
===============================================================================}

{$IF DEFINED(FPC)}
  {$IF DEFINED(USE_FIREDAC)}
    {$UNDEF USE_FIREDAC}
    {$MESSAGE WARN 'ProvidersORM: FireDAC n�o est� dispon�vel no FPC (Free Pascal Compiler).'}
    {$MESSAGE WARN 'FireDAC foi desativado automaticamente. Use USE_ZEOS ou USE_UNIDAC no FPC.'}
  {$ENDIF}
{$ENDIF}

{===============================================================================
  VALIDA��O E CORRE��O DE M�LTIPLOS ENGINES
  ==========================================
  Esta se��o valida se m�ltiplos engines est�o definidos e corrige automaticamente,
  seguindo a ordem de prioridade: UNIDAC > FireDAC > Zeos

  Esta valida��o funciona tanto no modo manual quanto no modo autom�tico.
  Se m�ltiplos engines estiverem definidos, o sistema:
  - Emite avisos informativos
  - Desativa automaticamente os engines de menor prioridade
  - Mant�m apenas o engine com maior prioridade
===============================================================================}

// Contar quantos engines est�o definidos
// NOTA: FireDAC n�o � contado no FPC (n�o est� dispon�vel)
{$DEFINE ENGINE_COUNT_0}
{$IF DEFINED(USE_UNIDAC)}
  {$UNDEF ENGINE_COUNT_0}
  {$DEFINE ENGINE_COUNT_1}
{$ENDIF}
{$IF DEFINED(USE_FIREDAC)}
  {$IF NOT DEFINED(FPC)}
    // FireDAC s� � contado no Delphi (n�o dispon�vel no FPC)
    {$UNDEF ENGINE_COUNT_0}
    {$IF DEFINED(ENGINE_COUNT_1)}
      {$UNDEF ENGINE_COUNT_1}
      {$DEFINE ENGINE_COUNT_2}
    {$ELSE}
      {$DEFINE ENGINE_COUNT_1}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
{$IF DEFINED(USE_ZEOS)}
  {$UNDEF ENGINE_COUNT_0}
  {$IF DEFINED(ENGINE_COUNT_2)}
    {$UNDEF ENGINE_COUNT_2}
    {$DEFINE ENGINE_COUNT_3}
  {$ELSE}
    {$IF DEFINED(ENGINE_COUNT_1)}
      {$UNDEF ENGINE_COUNT_1}
      {$DEFINE ENGINE_COUNT_2}
    {$ELSE}
      {$DEFINE ENGINE_COUNT_1}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

// VALIDA��O: Verificar se pelo menos um engine est� definido
{$IF DEFINED(ENGINE_COUNT_0)}
  {$MESSAGE WARN 'ProvidersORM: Nenhum engine de banco de dados definido!'}
  {$MESSAGE WARN 'Defina manualmente USE_UNIDAC, USE_FIREDAC ou USE_ZEOS na se��o CONFIGURA��O MANUAL acima.'}
  {$MESSAGE FATAL 'Compila��o interrompida: � necess�rio definir pelo menos um engine de banco de dados.'}
{$ENDIF}

// AVISO E CORRE��O: M�ltiplos engines definidos
{$IF DEFINED(ENGINE_COUNT_2)}
  // Dois engines definidos - usar prioridade e desativar o outro
  {$IF DEFINED(USE_UNIDAC)}
    {$IF DEFINED(USE_FIREDAC)}
      {$MESSAGE WARN 'ProvidersORM: M�ltiplos engines detectados (UNIDAC e FireDAC).'}
      {$MESSAGE WARN 'Usando UNIDAC (prioridade). FireDAC ser� desativado automaticamente.'}
      {$UNDEF USE_FIREDAC}
    {$ELSE}
      {$IF DEFINED(USE_ZEOS)}
        {$MESSAGE WARN 'ProvidersORM: M�ltiplos engines detectados (UNIDAC e Zeos).'}
        {$MESSAGE WARN 'Usando UNIDAC (prioridade). Zeos ser� desativado automaticamente.'}
        {$UNDEF USE_ZEOS}
      {$ENDIF}
    {$ENDIF}
  {$ELSE}
    {$IF DEFINED(USE_FIREDAC)}
      {$IF DEFINED(USE_ZEOS)}
        {$MESSAGE WARN 'ProvidersORM: M�ltiplos engines detectados (FireDAC e Zeos).'}
        {$MESSAGE WARN 'Usando FireDAC (prioridade). Zeos ser� desativado automaticamente.'}
        {$UNDEF USE_ZEOS}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IF DEFINED(ENGINE_COUNT_3)}
  // Tr�s engines definidos - usar UNIDAC (prioridade) e desativar os outros
  {$MESSAGE WARN 'ProvidersORM: Todos os engines est�o definidos (UNIDAC, FireDAC e Zeos).'}
  {$MESSAGE WARN 'Usando UNIDAC (prioridade). FireDAC e Zeos ser�o desativados automaticamente.'}
  {$UNDEF USE_FIREDAC}
  {$UNDEF USE_ZEOS}
{$ENDIF}

// Limpar defines tempor�rios
{$UNDEF ENGINE_COUNT_0}
{$UNDEF ENGINE_COUNT_1}
{$UNDEF ENGINE_COUNT_2}
{$UNDEF ENGINE_COUNT_3}

{===============================================================================
  RESUMO FINAL - ENGINES ATIVOS
  ==============================
  Esta se��o mostra qual engine est� ativo ap�s toda a l�gica de detec��o
===============================================================================}

{$IF DEFINED(USE_UNIDAC)}
  {$MESSAGE HINT 'ProvidersORM: Usando UNIDAC como engine de banco de dados'}
{$ELSE}
  {$IF DEFINED(USE_FIREDAC)}
    {$MESSAGE HINT 'ProvidersORM: Usando FireDAC como engine de banco de dados'}
  {$ELSE}
    {$IF DEFINED(USE_ZEOS)}
      {$MESSAGE HINT 'ProvidersORM: Usando Zeos como engine de banco de dados'}
    {$ELSE}
      {$MESSAGE FATAL 'ProvidersORM: Nenhum engine de banco de dados definido! Defina USE_UNIDAC, USE_FIREDAC ou USE_ZEOS.'}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{===============================================================================
  ENGINES DE SERVI�OS EXTERNOS
===============================================================================}

// LDAP - Lightweight Directory Access Protocol
// Sempre inclu�do (usa Common.LDAPSend - Synapse)
// N�o requer diretiva, mas pode ser desativado se necess�rio
//{$DEFINE USE_LDAP}

{===============================================================================
  ENGINES DE WEBSOCKET SERVER
===============================================================================}

// Indy - Internet Direct Components (padr�o)
// Requer: IdTCPServer, IdContext, IdHashMessageDigest, IdCoderMIME
// Sempre inclu�do por padr�o (nativo Delphi)
//{$DEFINE USE_WEBSOCKET_INDY}

// Synapse WebSocket - Biblioteca espec�fica WebSocket
// Requer: Biblioteca Synapse WebSocket
// {$DEFINE USE_WEBSOCKET_SYNAPSE_WS}

// Synapse D123 - Biblioteca Synapse b�sica (implementa��o manual)
// Requer: Synapse D123 (blcksock.pas)
// {$DEFINE USE_WEBSOCKET_SYNAPSE}

// Bird Socket Server - WebSocket nativo baseado em Indy
// Requer: Bird.Socket.Server
// {$DEFINE USE_WEBSOCKET_BIRD_SOCKET}

// ICS - Internet Component Suite (gratuito)
// Requer: TSslWebSocketCli, THttpWSSrvConn
// {$DEFINE USE_WEBSOCKET_ICS}

// IPWorks 2024 - Biblioteca comercial nSoftware
// Requer: WSServer, WSClient (licen�a comercial)
//{$DEFINE USE_WEBSOCKET_IPWORKS}

// TMS FNC WebSocket - Biblioteca comercial TMS Software
// Requer: TTMSFNCWebSocketServer, TTMSFNCWebSocketClient (licen�a comercial)
// {$DEFINE USE_WEBSOCKET_TMS_FNC}

// Horse SocketIO - Socket.IO protocol (requer Horse Framework)
// Requer: Horse Framework, Horse SocketIO
// {$DEFINE USE_WEBSOCKET_HORSE}

{===============================================================================
  FRAMEWORKS DE CONTROLES
===============================================================================}

// DevExpress - Componentes DevExpress (cxTextEdit, cxCurrencyEdit, etc.)
// Requer: cxTextEdit, cxCurrencyEdit, cxDateEdit, cxCheckBox, cxMemo, etc.
//{$DEFINE USE_DEVEXPRESS}

// Konopka - Componentes Konopka Signature VCL Controls (TRzEdit, TRzComboBox, etc.)
// Requer: RzEdit, RzDTP, RzRadChk, RzCmboBx, RzSpnEdt, RzLstBox, RzBtnEdt, etc.
//{$DEFINE USE_KONOPKA}

// FMX - FireMonkey (controles FMX padr�o)
// Requer: FMX.Forms, FMX.StdCtrls, FMX.Edit, FMX.Memo, FMX.ListBox, etc.
// NOTA: Esta diretiva � definida automaticamente pelo Delphi quando compilando para FMX
// N�o � necess�rio definir manualmente, mas pode ser usado para for�ar inclus�o
//{$DEFINE FMX}  // Descomente apenas se necess�rio

// VCL - Visual Component Library (controles VCL padr�o)
// Requer: Vcl.Forms, Vcl.StdCtrls, Vcl.Controls, Vcl.Mask, Vcl.ComCtrls, Vcl.ExtCtrls
// NOTA: Se voc� estiver usando apenas FMX, comente esta diretiva para reduzir o tamanho do c�digo
{$DEFINE VCL}

// InfoEmbed - Gerenciamento de JSON embutido em arquivos
// Requer: Providers.InfoEmbed, Providers.InfoEmbed.Interfaces
// NOTA: Se voc� n�o usar recursos embutidos em arquivos, comente esta diretiva para reduzir o tamanho do c�digo
//{$DEFINE USE_VERSIONINFO}

{===============================================================================
  NOTAS
===============================================================================}
// - Se voc� n�o tiver licen�a do UNIDAC, comente {$DEFINE USE_UNIDAC}
// - Se voc� n�o quiser usar FireDAC, comente {$DEFINE USE_FIREDAC}
// - Se voc� n�o quiser usar Zeos, comente {$DEFINE USE_ZEOS}
// - LDAP � sempre inclu�do por padr�o (usa biblioteca Synapse)
// - Se voc� n�o usar DevExpress, comente {$DEFINE USE_DEVEXPRESS}
// - Se voc� n�o usar Konopka, comente {$DEFINE USE_KONOPKA}
// - Se voc� estiver usando apenas FMX, comente {$DEFINE USE_VCL} para reduzir o tamanho do c�digo
// - Se voc� n�o usar recursos embutidos em arquivos, comente {$DEFINE USE_INFOEMBED}
// - FMX � detectado automaticamente pelo Delphi, n�o precisa definir manualmente
