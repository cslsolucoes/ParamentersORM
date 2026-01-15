object frmConfigCRUD: TfrmConfigCRUD
  Left = 0
  Top = 0
  Caption = 'CRUD - Tabela Config (Exemplo Parameters)'
  ClientHeight = 677
  ClientWidth = 1305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1305
    Height = 147
    Align = alTop
    BevelOuter = bvNone
    Color = 16744448
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 20
      Top = 8
      Width = 345
      Height = 23
      Caption = 'CRUD - Tabela Config (dbcsl.config)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblEngine: TLabel
      Left = 812
      Top = 0
      Width = 36
      Height = 13
      Caption = 'Engine:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblDatabaseType: TLabel
      Left = 938
      Top = 0
      Width = 77
      Height = 13
      Caption = 'Database Type:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblHost: TLabel
      Left = 1084
      Top = 0
      Width = 26
      Height = 13
      Caption = 'Host:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblPort: TLabel
      Left = 1247
      Top = 0
      Width = 24
      Height = 13
      Caption = 'Port:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblUsername: TLabel
      Left = 812
      Top = 36
      Width = 52
      Height = 13
      Caption = 'Username:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblPassword: TLabel
      Left = 1056
      Top = 36
      Width = 50
      Height = 13
      Caption = 'Password:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblDatabase: TLabel
      Left = 812
      Top = 73
      Width = 50
      Height = 13
      Caption = 'Database:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblSchema: TLabel
      Left = 976
      Top = 73
      Width = 41
      Height = 13
      Caption = 'Schema:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblTableName: TLabel
      Left = 1137
      Top = 73
      Width = 60
      Height = 13
      Caption = 'Table Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblODBCDatabaseType: TLabel
      Left = 1084
      Top = 0
      Width = 108
      Height = 13
      Caption = 'ODBC Database Type:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblConexaoInfo: TLabel
      Left = 20
      Top = 37
      Width = 1260
      Height = 13
      AutoSize = False
      Caption = 'Carregando informa'#231#245'es de conex'#227'o...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblConexaoTipo: TLabel
      Left = 20
      Top = 55
      Width = 1260
      Height = 13
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDLLPath: TLabel
      Left = 20
      Top = 73
      Width = 1260
      Height = 13
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtEngine: TEdit
      Left = 812
      Top = 15
      Width = 120
      Height = 21
      TabOrder = 0
      Text = 'FireDac'
    end
    object cmbDatabaseType: TComboBox
      Left = 938
      Top = 15
      Width = 140
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = cmbDatabaseTypeChange
    end
    object edtHost: TEdit
      Left = 1084
      Top = 15
      Width = 158
      Height = 21
      TabOrder = 2
      Text = '201.87.244.234'
    end
    object edtPort: TEdit
      Left = 1247
      Top = 15
      Width = 49
      Height = 21
      NumbersOnly = True
      TabOrder = 3
      Text = '5432'
    end
    object edtUsername: TEdit
      Left = 812
      Top = 51
      Width = 240
      Height = 21
      TabOrder = 4
      Text = 'postgres'
    end
    object edtPassword: TEdit
      Left = 1056
      Top = 51
      Width = 240
      Height = 21
      TabOrder = 5
      Text = 'postmy'
    end
    object edtDatabase: TEdit
      Left = 812
      Top = 88
      Width = 130
      Height = 21
      TabOrder = 6
      Text = 'dbsgp'
    end
    object cmbODBCDSN: TComboBox
      Left = 812
      Top = 88
      Width = 130
      Height = 21
      TabOrder = 13
      Visible = False
    end
    object btnSelectDatabase: TButton
      Left = 948
      Top = 88
      Width = 23
      Height = 21
      Caption = '...'
      TabOrder = 12
      OnClick = btnSelectDatabaseClick
    end
    object cmbODBCDatabaseType: TComboBox
      Left = 1084
      Top = 15
      Width = 140
      Height = 21
      Style = csDropDownList
      TabOrder = 11
      Visible = False
      OnChange = cmbODBCDatabaseTypeChange
    end
    object edtSchema: TEdit
      Left = 976
      Top = 88
      Width = 156
      Height = 21
      TabOrder = 7
      Text = 'dbcsl'
    end
    object edtTableName: TEdit
      Left = 1137
      Top = 88
      Width = 159
      Height = 21
      TabOrder = 8
      Text = 'config'
    end
    object btnConectar: TButton
      Left = 1110
      Top = 120
      Width = 90
      Height = 25
      Caption = 'Connect'
      TabOrder = 9
      OnClick = btnConectarClick
    end
    object btnDesconectar: TButton
      Left = 1206
      Top = 120
      Width = 90
      Height = 25
      Caption = 'Disconnect'
      TabOrder = 10
      OnClick = btnDesconectarClick
    end
    object cbApagar: TCheckBox
      Left = 812
      Top = 121
      Width = 120
      Height = 17
      Caption = 'Apagar caso exista'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 655
    Width = 1305
    Height = 22
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblStatus: TLabel
      Left = 10
      Top = 5
      Width = 1180
      Height = 16
      AutoSize = False
      Caption = 'Pronto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 147
    Width = 1305
    Height = 508
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pgcMain: TPageControl
      Left = 0
      Top = 0
      Width = 1305
      Height = 508
      ActivePage = tsInifiles
      Align = alClient
      TabOrder = 0
      object tsDatabase: TTabSheet
        Caption = 'Database'
        object pnlDados: TPanel
          Left = 0
          Top = 0
          Width = 430
          Height = 480
          Align = alLeft
          BevelOuter = bvLowered
          TabOrder = 0
          object lblContratoID: TLabel
            Left = 10
            Top = 11
            Width = 61
            Height = 13
            Caption = 'Contrato ID:'
          end
          object lblProdutoID: TLabel
            Left = 10
            Top = 41
            Width = 56
            Height = 13
            Caption = 'Produto ID:'
          end
          object lblOrdem: TLabel
            Left = 10
            Top = 71
            Width = 36
            Height = 13
            Caption = 'Ordem:'
          end
          object lblTituloCampo: TLabel
            Left = 10
            Top = 101
            Width = 30
            Height = 13
            Caption = 'T'#237'tulo:'
          end
          object lblChave: TLabel
            Left = 10
            Top = 131
            Width = 35
            Height = 13
            Caption = 'Chave:'
          end
          object lblValor: TLabel
            Left = 10
            Top = 161
            Width = 28
            Height = 13
            Caption = 'Valor:'
          end
          object lblDescricao: TLabel
            Left = 10
            Top = 281
            Width = 50
            Height = 13
            Caption = 'Descri'#231#227'o:'
          end
          object edtContratoID: TEdit
            Left = 75
            Top = 8
            Width = 100
            Height = 21
            TabOrder = 0
            Text = '1'
          end
          object edtProdutoID: TEdit
            Left = 75
            Top = 38
            Width = 100
            Height = 21
            TabOrder = 1
            Text = '1'
          end
          object edtOrdem: TEdit
            Left = 75
            Top = 68
            Width = 100
            Height = 21
            TabOrder = 2
            Text = '1'
          end
          object edtTitulo: TEdit
            Left = 75
            Top = 98
            Width = 334
            Height = 21
            TabOrder = 3
          end
          object edtChave: TEdit
            Left = 75
            Top = 128
            Width = 334
            Height = 21
            TabOrder = 4
          end
          object memoValor: TMemo
            Left = 75
            Top = 158
            Width = 334
            Height = 110
            ScrollBars = ssVertical
            TabOrder = 5
          end
          object memoDescricao: TMemo
            Left = 75
            Top = 278
            Width = 334
            Height = 110
            ScrollBars = ssVertical
            TabOrder = 6
          end
          object chkAtivo: TCheckBox
            Left = 10
            Top = 369
            Width = 59
            Height = 17
            Caption = 'Ativo'
            Checked = True
            State = cbChecked
            TabOrder = 7
          end
          object btnClear: TButton
            Left = 5
            Top = 407
            Width = 80
            Height = 25
            Caption = 'Clear'
            TabOrder = 8
            OnClick = btnClearClick
          end
          object btnGet: TButton
            Left = 90
            Top = 407
            Width = 80
            Height = 25
            Caption = 'Get'
            TabOrder = 9
            OnClick = btnGetClick
          end
          object btnInsert: TButton
            Left = 175
            Top = 407
            Width = 80
            Height = 25
            Caption = 'Insert'
            TabOrder = 10
            OnClick = btnInsertClick
          end
          object btnUpdate: TButton
            Left = 260
            Top = 407
            Width = 80
            Height = 25
            Caption = 'Update'
            TabOrder = 11
            OnClick = btnUpdateClick
          end
          object btnDelete: TButton
            Left = 345
            Top = 407
            Width = 80
            Height = 25
            Caption = 'Delete'
            TabOrder = 12
            OnClick = btnDeleteClick
          end
        end
        object pnlLista: TPanel
          Left = 430
          Top = 0
          Width = 875
          Height = 480
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 1
          object lblLista: TLabel
            Left = 10
            Top = 10
            Width = 104
            Height = 13
            Caption = 'Lista de Registros:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblFiltro: TLabel
            Left = 10
            Top = 35
            Width = 28
            Height = 13
            Caption = 'Filtro:'
          end
          object lblFiltroContrato: TLabel
            Left = 10
            Top = 62
            Width = 47
            Height = 13
            Caption = 'Contrato:'
          end
          object lblFiltroProduto: TLabel
            Left = 155
            Top = 62
            Width = 42
            Height = 13
            Caption = 'Produto:'
          end
          object edtFiltro: TEdit
            Left = 50
            Top = 32
            Width = 719
            Height = 21
            TabOrder = 0
            TextHint = 'Digite para filtrar por chave, t'#237'tulo, valor ou descri'#231#227'o...'
          end
          object edtFiltroContrato: TEdit
            Left = 65
            Top = 59
            Width = 80
            Height = 21
            NumbersOnly = True
            TabOrder = 1
            TextHint = 'ID'
          end
          object edtFiltroProduto: TEdit
            Left = 205
            Top = 59
            Width = 80
            Height = 21
            NumbersOnly = True
            TabOrder = 2
            TextHint = 'ID'
          end
          object btnFiltrar: TButton
            Left = 775
            Top = 30
            Width = 90
            Height = 50
            Caption = 'Filter'
            TabOrder = 3
            OnClick = btnFiltrarClick
          end
          object lvConfig: TListView
            Left = 10
            Top = 93
            Width = 855
            Height = 295
            Columns = <
              item
                Caption = 'ID'
                Width = 40
              end
              item
                Caption = 'Contrato'
                Width = 70
              end
              item
                Caption = 'Produto'
                Width = 70
              end
              item
                Caption = 'Ordem'
              end
              item
                Caption = 'T'#237'tulo'
                Width = 150
              end
              item
                Caption = 'Chave'
                Width = 150
              end
              item
                Caption = 'Valor'
                Width = 180
              end
              item
                Caption = 'Descri'#231#227'o'
                Width = 200
              end
              item
                Caption = 'Ativo'
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 4
            ViewStyle = vsReport
            OnColumnClick = lvConfigColumnClick
            OnSelectItem = lvConfigSelectItem
          end
          object btnList: TButton
            Left = 92
            Top = 406
            Width = 90
            Height = 25
            Caption = 'List All'
            TabOrder = 5
            OnClick = btnListClick
          end
          object btnRefresh: TButton
            Left = 192
            Top = 406
            Width = 90
            Height = 25
            Caption = 'Refresh'
            TabOrder = 6
            OnClick = btnRefreshClick
          end
          object btnLimparFiltro: TButton
            Left = 292
            Top = 406
            Width = 90
            Height = 25
            Caption = 'Clear Filters'
            TabOrder = 7
            OnClick = btnLimparFiltroClick
          end
          object btnDatabaseImportIni: TButton
            Left = 392
            Top = 406
            Width = 90
            Height = 25
            Caption = 'Import from INI'
            TabOrder = 8
            OnClick = btnDatabaseImportIniClick
          end
          object btnDatabaseImportJson: TButton
            Left = 492
            Top = 406
            Width = 90
            Height = 25
            Caption = 'Import from JSON'
            TabOrder = 9
            OnClick = btnDatabaseImportJsonClick
          end
          object btnDatabaseExportIni: TButton
            Left = 592
            Top = 406
            Width = 90
            Height = 25
            Caption = 'Export to INI'
            TabOrder = 10
            OnClick = btnDatabaseExportIniClick
          end
          object btnDatabaseExportJson: TButton
            Left = 692
            Top = 406
            Width = 90
            Height = 25
            Caption = 'Export to JSON'
            TabOrder = 11
            OnClick = btnDatabaseExportJsonClick
          end
        end
      end
      object tsInifiles: TTabSheet
        Caption = 'Inifiles'
        ImageIndex = 1
        object pnlInifilesTop: TPanel
          Left = 0
          Top = 0
          Width = 1297
          Height = 89
          Align = alTop
          BevelOuter = bvLowered
          TabOrder = 0
          object lblInifilesFilePath: TLabel
            Left = 10
            Top = 10
            Width = 45
            Height = 13
            Caption = 'File Path:'
          end
          object lblInifilesSection: TLabel
            Left = 10
            Top = 40
            Width = 39
            Height = 13
            Caption = 'Section:'
          end
          object lblInifilesAutoCreate: TLabel
            Left = 10
            Top = 70
            Width = 63
            Height = 13
            Caption = 'Auto Create:'
          end
          object lblInifilesFiltroContrato: TLabel
            Left = 660
            Top = 10
            Width = 88
            Height = 13
            Caption = 'Filtro Contrato ID:'
          end
          object lblInifilesFiltroProduto: TLabel
            Left = 660
            Top = 40
            Width = 83
            Height = 13
            Caption = 'Filtro Produto ID:'
          end
          object lblInifilesFiltroInfo: TLabel
            Left = 842
            Top = 10
            Width = 151
            Height = 13
            Caption = '(0 = importa todos, >0 = filtra)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object edtInifilesFilePath: TEdit
            Left = 70
            Top = 7
            Width = 500
            Height = 21
            TabOrder = 0
            Text = 'D:\Dados\config.ini'
          end
          object btnInifilesSelectFile: TButton
            Left = 576
            Top = 6
            Width = 90
            Height = 25
            Caption = 'Select...'
            TabOrder = 1
            OnClick = btnInifilesSelectFileClick
          end
          object edtInifilesSection: TEdit
            Left = 70
            Top = 37
            Width = 200
            Height = 21
            TabOrder = 2
            Text = 'Default'
          end
          object chkInifilesAutoCreate: TCheckBox
            Left = 85
            Top = 68
            Width = 97
            Height = 17
            Caption = 'Criar automaticamente'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
          object btnInifilesRefresh: TButton
            Left = 280
            Top = 35
            Width = 90
            Height = 25
            Caption = 'Refresh'
            TabOrder = 4
            OnClick = btnInifilesRefreshClick
          end
          object edtInifilesFiltroContrato: TEdit
            Left = 756
            Top = 7
            Width = 80
            Height = 21
            NumbersOnly = True
            TabOrder = 5
            Text = '0'
          end
          object edtInifilesFiltroProduto: TEdit
            Left = 756
            Top = 37
            Width = 80
            Height = 21
            NumbersOnly = True
            TabOrder = 6
            Text = '0'
          end
        end
        object pnlInifilesLeft: TPanel
          Left = 0
          Top = 89
          Width = 430
          Height = 391
          Align = alLeft
          BevelOuter = bvLowered
          TabOrder = 1
          object lblInifilesContratoID: TLabel
            Left = 10
            Top = 13
            Width = 61
            Height = 13
            Caption = 'Contrato ID:'
          end
          object lblInifilesProdutoID: TLabel
            Left = 10
            Top = 43
            Width = 56
            Height = 13
            Caption = 'Produto ID:'
          end
          object lblInifilesOrdem: TLabel
            Left = 10
            Top = 73
            Width = 36
            Height = 13
            Caption = 'Ordem:'
          end
          object lblInifilesTitulo: TLabel
            Left = 10
            Top = 103
            Width = 30
            Height = 13
            Caption = 'T'#237'tulo:'
          end
          object lblInifilesChave: TLabel
            Left = 10
            Top = 133
            Width = 35
            Height = 13
            Caption = 'Chave:'
          end
          object lblInifilesValor: TLabel
            Left = 10
            Top = 163
            Width = 28
            Height = 13
            Caption = 'Valor:'
          end
          object lblInifilesDescricao: TLabel
            Left = 10
            Top = 283
            Width = 50
            Height = 13
            Caption = 'Descri'#231#227'o:'
          end
          object edtInifilesContratoID: TEdit
            Left = 75
            Top = 10
            Width = 100
            Height = 21
            NumbersOnly = True
            TabOrder = 0
            Text = '1'
          end
          object edtInifilesProdutoID: TEdit
            Left = 75
            Top = 40
            Width = 100
            Height = 21
            NumbersOnly = True
            TabOrder = 1
            Text = '1'
          end
          object edtInifilesOrdem: TEdit
            Left = 75
            Top = 70
            Width = 100
            Height = 21
            NumbersOnly = True
            TabOrder = 2
            Text = '1'
          end
          object edtInifilesTitulo: TEdit
            Left = 75
            Top = 100
            Width = 334
            Height = 21
            TabOrder = 3
          end
          object edtInifilesChave: TEdit
            Left = 75
            Top = 130
            Width = 334
            Height = 21
            TabOrder = 4
          end
          object memoInifilesValor: TMemo
            Left = 75
            Top = 160
            Width = 334
            Height = 110
            ScrollBars = ssVertical
            TabOrder = 5
          end
          object memoInifilesDescricao: TMemo
            Left = 75
            Top = 280
            Width = 334
            Height = 50
            ScrollBars = ssVertical
            TabOrder = 6
          end
          object chkInifilesAtivo: TCheckBox
            Left = 10
            Top = 343
            Width = 59
            Height = 17
            Caption = 'Ativo'
            Checked = True
            State = cbChecked
            TabOrder = 7
          end
          object btnInifilesClear: TButton
            Left = 5
            Top = 338
            Width = 80
            Height = 25
            Caption = 'Clear'
            TabOrder = 8
            OnClick = btnInifilesClearClick
          end
          object btnInifilesGet: TButton
            Left = 90
            Top = 338
            Width = 80
            Height = 25
            Caption = 'Get'
            TabOrder = 9
            OnClick = btnInifilesGetClick
          end
          object btnInifilesInsert: TButton
            Left = 175
            Top = 338
            Width = 80
            Height = 25
            Caption = 'Insert'
            TabOrder = 10
            OnClick = btnInifilesInsertClick
          end
          object btnInifilesUpdate: TButton
            Left = 260
            Top = 338
            Width = 80
            Height = 25
            Caption = 'Update'
            TabOrder = 11
            OnClick = btnInifilesUpdateClick
          end
          object btnInifilesDelete: TButton
            Left = 345
            Top = 338
            Width = 80
            Height = 25
            Caption = 'Delete'
            TabOrder = 12
            OnClick = btnInifilesDeleteClick
          end
        end
        object pnlInifilesRight: TPanel
          Left = 430
          Top = 89
          Width = 867
          Height = 391
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 2
          object lblInifilesLista: TLabel
            Left = 10
            Top = 10
            Width = 117
            Height = 13
            Caption = 'Lista de Par'#226'metros:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lvInifiles: TListView
            Left = 10
            Top = 36
            Width = 851
            Height = 294
            Columns = <
              item
                Caption = 'ID'
                Width = 40
              end
              item
                Caption = 'Contrato'
                Width = 70
              end
              item
                Caption = 'Produto'
                Width = 70
              end
              item
                Caption = 'Ordem'
              end
              item
                Caption = 'T'#237'tulo'
                Width = 150
              end
              item
                Caption = 'Chave'
                Width = 150
              end
              item
                Caption = 'Valor'
                Width = 180
              end
              item
                Caption = 'Descri'#231#227'o'
                Width = 200
              end
              item
                Caption = 'Ativo'
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = lvInifilesSelectItem
          end
          object btnInifilesList: TButton
            Left = 92
            Top = 338
            Width = 90
            Height = 25
            Caption = 'List'
            TabOrder = 1
            OnClick = btnInifilesListClick
          end
          object btnInifilesCount: TButton
            Left = 192
            Top = 338
            Width = 90
            Height = 25
            Caption = 'Count'
            TabOrder = 2
            OnClick = btnInifilesCountClick
          end
          object btnInifilesExists: TButton
            Left = 292
            Top = 338
            Width = 90
            Height = 25
            Caption = 'Exists'
            TabOrder = 3
            OnClick = btnInifilesExistsClick
          end
          object btnInifilesImport: TButton
            Left = 392
            Top = 338
            Width = 90
            Height = 25
            Caption = 'Import from DB'
            TabOrder = 4
            OnClick = btnInifilesImportClick
          end
          object btnInifilesExport: TButton
            Left = 492
            Top = 338
            Width = 90
            Height = 25
            Caption = 'Export to DB'
            TabOrder = 5
            OnClick = btnInifilesExportClick
          end
          object btnInifilesImportJson: TButton
            Left = 592
            Top = 338
            Width = 90
            Height = 25
            Caption = 'Import from JSON'
            TabOrder = 6
            OnClick = btnInifilesImportJsonClick
          end
          object btnInifilesExportJson: TButton
            Left = 692
            Top = 338
            Width = 90
            Height = 25
            Caption = 'Export to JSON'
            TabOrder = 7
            OnClick = btnInifilesExportJsonClick
          end
        end
      end
      object tsJsonObject: TTabSheet
        Caption = 'JsonObject'
        ImageIndex = 2
        object pnlJsonObjectTop: TPanel
          Left = 0
          Top = 0
          Width = 1297
          Height = 89
          Align = alTop
          BevelOuter = bvLowered
          TabOrder = 0
          object lblJsonObjectFilePath: TLabel
            Left = 10
            Top = 10
            Width = 45
            Height = 13
            Caption = 'File Path:'
          end
          object lblJsonObjectObjectName: TLabel
            Left = 10
            Top = 40
            Width = 66
            Height = 13
            Caption = 'Object Name:'
          end
          object lblJsonObjectAutoCreate: TLabel
            Left = 10
            Top = 70
            Width = 63
            Height = 13
            Caption = 'Auto Create:'
          end
          object lblJsonObjectFiltroContrato: TLabel
            Left = 660
            Top = 10
            Width = 88
            Height = 13
            Caption = 'Filtro Contrato ID:'
          end
          object lblJsonObjectFiltroProduto: TLabel
            Left = 660
            Top = 40
            Width = 83
            Height = 13
            Caption = 'Filtro Produto ID:'
          end
          object lblJsonObjectFiltroInfo: TLabel
            Left = 842
            Top = 10
            Width = 141
            Height = 13
            Caption = 'Filtros para importa'#231#227'o do DB'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object edtJsonObjectFilePath: TEdit
            Left = 80
            Top = 7
            Width = 400
            Height = 21
            TabOrder = 0
            Text = 'D:\Dados\config.json'
          end
          object btnJsonObjectSelectFile: TButton
            Left = 490
            Top = 5
            Width = 90
            Height = 25
            Caption = 'Select...'
            TabOrder = 1
            OnClick = btnJsonObjectSelectFileClick
          end
          object edtJsonObjectObjectName: TEdit
            Left = 80
            Top = 37
            Width = 200
            Height = 21
            TabOrder = 2
          end
          object chkJsonObjectAutoCreate: TCheckBox
            Left = 80
            Top = 68
            Width = 97
            Height = 17
            Caption = 'Auto Create'
            TabOrder = 3
          end
          object btnJsonObjectRefresh: TButton
            Left = 300
            Top = 35
            Width = 90
            Height = 25
            Caption = 'Refresh'
            TabOrder = 4
            OnClick = btnJsonObjectRefreshClick
          end
          object edtJsonObjectFiltroContrato: TEdit
            Left = 760
            Top = 7
            Width = 60
            Height = 21
            NumbersOnly = True
            TabOrder = 5
            Text = '0'
          end
          object edtJsonObjectFiltroProduto: TEdit
            Left = 760
            Top = 37
            Width = 60
            Height = 21
            NumbersOnly = True
            TabOrder = 6
            Text = '0'
          end
        end
        object pnlJsonObjectLeft: TPanel
          Left = 0
          Top = 89
          Width = 430
          Height = 391
          Align = alLeft
          BevelOuter = bvLowered
          TabOrder = 1
          object lblJsonObjectContratoID: TLabel
            Left = 10
            Top = 11
            Width = 61
            Height = 13
            Caption = 'Contrato ID:'
          end
          object lblJsonObjectProdutoID: TLabel
            Left = 10
            Top = 41
            Width = 56
            Height = 13
            Caption = 'Produto ID:'
          end
          object lblJsonObjectOrdem: TLabel
            Left = 10
            Top = 71
            Width = 36
            Height = 13
            Caption = 'Ordem:'
          end
          object lblJsonObjectTitulo: TLabel
            Left = 10
            Top = 101
            Width = 30
            Height = 13
            Caption = 'T'#237'tulo:'
          end
          object lblJsonObjectChave: TLabel
            Left = 10
            Top = 131
            Width = 35
            Height = 13
            Caption = 'Chave:'
          end
          object lblJsonObjectValor: TLabel
            Left = 10
            Top = 161
            Width = 28
            Height = 13
            Caption = 'Valor:'
          end
          object lblJsonObjectDescricao: TLabel
            Left = 10
            Top = 281
            Width = 50
            Height = 13
            Caption = 'Descri'#231#227'o:'
          end
          object edtJsonObjectContratoID: TEdit
            Left = 75
            Top = 8
            Width = 100
            Height = 21
            NumbersOnly = True
            TabOrder = 0
            Text = '1'
          end
          object edtJsonObjectProdutoID: TEdit
            Left = 75
            Top = 38
            Width = 100
            Height = 21
            NumbersOnly = True
            TabOrder = 1
            Text = '1'
          end
          object edtJsonObjectOrdem: TEdit
            Left = 75
            Top = 68
            Width = 100
            Height = 21
            NumbersOnly = True
            TabOrder = 2
            Text = '1'
          end
          object edtJsonObjectTitulo: TEdit
            Left = 75
            Top = 98
            Width = 330
            Height = 21
            TabOrder = 3
          end
          object edtJsonObjectChave: TEdit
            Left = 75
            Top = 128
            Width = 330
            Height = 21
            TabOrder = 4
          end
          object memoJsonObjectValor: TMemo
            Left = 75
            Top = 158
            Width = 330
            Height = 100
            ScrollBars = ssVertical
            TabOrder = 5
          end
          object memoJsonObjectDescricao: TMemo
            Left = 75
            Top = 278
            Width = 330
            Height = 59
            ScrollBars = ssVertical
            TabOrder = 6
          end
          object chkJsonObjectAtivo: TCheckBox
            Left = 10
            Top = 331
            Width = 59
            Height = 17
            Caption = 'Ativo'
            Checked = True
            State = cbChecked
            TabOrder = 7
          end
          object btnJsonObjectClear: TButton
            Left = 5
            Top = 358
            Width = 80
            Height = 25
            Caption = 'Clear'
            TabOrder = 8
            OnClick = btnJsonObjectClearClick
          end
          object btnJsonObjectGet: TButton
            Left = 90
            Top = 358
            Width = 80
            Height = 25
            Caption = 'Get'
            TabOrder = 9
            OnClick = btnJsonObjectGetClick
          end
          object btnJsonObjectInsert: TButton
            Left = 175
            Top = 358
            Width = 80
            Height = 25
            Caption = 'Insert'
            TabOrder = 10
            OnClick = btnJsonObjectInsertClick
          end
          object btnJsonObjectUpdate: TButton
            Left = 260
            Top = 358
            Width = 80
            Height = 25
            Caption = 'Update'
            TabOrder = 11
            OnClick = btnJsonObjectUpdateClick
          end
          object btnJsonObjectDelete: TButton
            Left = 345
            Top = 358
            Width = 80
            Height = 25
            Caption = 'Delete'
            TabOrder = 12
            OnClick = btnJsonObjectDeleteClick
          end
        end
        object pnlJsonObjectRight: TPanel
          Left = 430
          Top = 89
          Width = 875
          Height = 391
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 2
          object lblJsonObjectLista: TLabel
            Left = 10
            Top = 10
            Width = 26
            Height = 13
            Caption = 'Lista:'
          end
          object lvJsonObject: TListView
            Left = 10
            Top = 29
            Width = 851
            Height = 308
            Columns = <
              item
                Caption = 'ID'
                Width = 40
              end
              item
                Caption = 'Contrato'
                Width = 70
              end
              item
                Caption = 'Produto'
                Width = 70
              end
              item
                Caption = 'Ordem'
                Width = 60
              end
              item
                Caption = 'T'#237'tulo'
                Width = 150
              end
              item
                Caption = 'Chave'
                Width = 150
              end
              item
                Caption = 'Valor'
                Width = 200
              end
              item
                Caption = 'Descri'#231#227'o'
                Width = 200
              end
              item
                Caption = 'Ativo'
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = lvJsonObjectSelectItem
          end
          object btnJsonObjectList: TButton
            Left = 92
            Top = 358
            Width = 90
            Height = 25
            Caption = 'List'
            TabOrder = 1
            OnClick = btnJsonObjectListClick
          end
          object btnJsonObjectCount: TButton
            Left = 192
            Top = 358
            Width = 90
            Height = 25
            Caption = 'Count'
            TabOrder = 2
            OnClick = btnJsonObjectCountClick
          end
          object btnJsonObjectExists: TButton
            Left = 292
            Top = 358
            Width = 90
            Height = 25
            Caption = 'Exists'
            TabOrder = 3
            OnClick = btnJsonObjectExistsClick
          end
          object btnJsonObjectImport: TButton
            Left = 392
            Top = 358
            Width = 90
            Height = 25
            Caption = 'Import from DB'
            TabOrder = 4
            OnClick = btnJsonObjectImportClick
          end
          object btnJsonObjectImportIni: TButton
            Left = 492
            Top = 358
            Width = 90
            Height = 25
            Caption = 'Import from INI'
            TabOrder = 5
            OnClick = btnJsonObjectImportIniClick
          end
          object btnJsonObjectExport: TButton
            Left = 592
            Top = 358
            Width = 90
            Height = 25
            Caption = 'Export to DB'
            TabOrder = 6
            OnClick = btnJsonObjectExportClick
          end
          object btnJsonObjectExportIni: TButton
            Left = 692
            Top = 358
            Width = 90
            Height = 25
            Caption = 'Export to INI'
            TabOrder = 7
            OnClick = btnJsonObjectExportIniClick
          end
          object btnJsonObjectSave: TButton
            Left = 792
            Top = 358
            Width = 90
            Height = 25
            Caption = 'Save to File'
            TabOrder = 8
            OnClick = btnJsonObjectSaveClick
          end
          object btnJsonObjectLoad: TButton
            Left = 892
            Top = 358
            Width = 90
            Height = 25
            Caption = 'Load from File'
            TabOrder = 9
            OnClick = btnJsonObjectLoadClick
          end
        end
      end
    end
  end
  object dlgOpenDatabase: TOpenDialog
    Filter = 
      'FireBird Database (*.fdb)|*.fdb|SQLite Database (*.db;*.sqlite)|' +
      '*.db;*.sqlite|Access Database (*.mdb;*.accdb)|*.mdb;*.accdb|All ' +
      'Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 1200
    Top = 400
  end
  object dlgJsonObjectSave: TSaveDialog
    Filter = 'JSON Files (*.json)|*.json|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofEnableSizing]
    Left = 1200
    Top = 450
  end
  object dlgJsonObjectOpen: TOpenDialog
    Filter = 'JSON Files (*.json)|*.json|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 1200
    Top = 500
  end
  object dlgInifilesOpen: TOpenDialog
    Filter = 'INI Files (*.ini)|*.ini|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 1200
    Top = 550
  end
  object dlgInifilesSave: TSaveDialog
    DefaultExt = 'ini'
    Filter = 'INI Files (*.ini)|*.ini|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 1200
    Top = 450
  end
end
