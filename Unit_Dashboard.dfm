object FormDashboard: TFormDashboard
  Left = 0
  Top = 0
  Caption = 'FormDashboard'
  ClientHeight = 484
  ClientWidth = 706
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  TextHeight = 15
  object BtnNewOrder: TButton
    Left = 24
    Top = 160
    Width = 75
    Height = 25
    Caption = 'New Order'
    TabOrder = 0
    OnClick = BtnNewOrderClick
  end
  object PnlQtyTags: TPanel
    Left = 24
    Top = 24
    Width = 153
    Height = 73
    Color = 16621389
    ParentBackground = False
    TabOrder = 1
    object LblQtyTags: TLabel
      Left = 10
      Top = 8
      Width = 46
      Height = 15
      Caption = 'Qty Tags'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object DBTxtQtyTags: TDBText
      Left = 10
      Top = 35
      Width = 127
      Height = 28
      DataField = 'qty_tags'
      DataSource = DscDataCards
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object PnlClosedTags: TPanel
    Left = 192
    Top = 24
    Width = 153
    Height = 73
    Color = 12245840
    ParentBackground = False
    TabOrder = 2
    object LblClosedTags: TLabel
      Left = 10
      Top = 8
      Width = 63
      Height = 15
      Caption = 'Closed Tags'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object DBTxtClosedTags: TDBText
      Left = 10
      Top = 35
      Width = 127
      Height = 28
      DataField = 'qty_closed_tags'
      DataSource = DscDataCards
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object PnlOpenedTags: TPanel
    Left = 360
    Top = 24
    Width = 153
    Height = 73
    Color = 7846911
    ParentBackground = False
    TabOrder = 3
    object LblOpenedTags: TLabel
      Left = 10
      Top = 8
      Width = 69
      Height = 15
      Caption = 'Opened Tags'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object DBTxtOpenedTags: TDBText
      Left = 10
      Top = 35
      Width = 127
      Height = 28
      DataField = 'qty_open_tags'
      DataSource = DscDataCards
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object PnlQtyPreparing: TPanel
    Left = 528
    Top = 24
    Width = 153
    Height = 73
    Color = 16729763
    ParentBackground = False
    TabOrder = 4
    object LblQtyPreparing: TLabel
      Left = 10
      Top = 8
      Width = 73
      Height = 15
      Caption = 'Qty Preparing'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object DBTxtQtyPreparing: TDBText
      Left = 10
      Top = 35
      Width = 127
      Height = 28
      DataField = 'qty_preparing_tags'
      DataSource = DscDataCards
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object BtnRefresh: TButton
    Left = 105
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Refresh'
    TabOrder = 5
    OnClick = BtnRefreshClick
  end
  object BtnCompleted: TButton
    Left = 606
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Completed'
    TabOrder = 6
    OnClick = BtnCompletedClick
  end
  object BtnReady: TButton
    Left = 525
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Ready'
    TabOrder = 7
    OnClick = BtnReadyClick
  end
  object BtnView: TButton
    Left = 444
    Top = 160
    Width = 75
    Height = 25
    Caption = 'View'
    TabOrder = 8
    OnClick = BtnViewClick
  end
  object DbgOrder: TDBGrid
    Left = 25
    Top = 191
    Width = 656
    Height = 258
    DataSource = DscSalesOrder
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 9
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'date'
        Title.Caption = 'Date'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'tag_name'
        Title.Caption = 'Tag'
        Width = 150
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'total_qty'
        Title.Alignment = taCenter
        Title.Caption = 'Qty'
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'total_price'
        Title.Caption = 'Total Price'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'status'
        Title.Caption = 'Status'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'description'
        Title.Caption = 'Description'
        Width = 150
        Visible = True
      end>
  end
  object Tmr: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TmrTimer
    Left = 416
    Top = 152
  end
  object QryDataCards: TFDQuery
    Connection = DM.DBConnection
    SQL.Strings = (
      'SELECT t.*,'
      '       qty_tags - qty_open_tags AS qty_closed_tags'
      'FROM ('
      '    SELECT '
      '     (SELECT count(*)'
      '      FROM tag'
      '      WHERE id_account = :id_account AND '
      '            status = '#39'Active'#39') AS qty_tags,'
      '    (SELECT count(DISTINCT tag.id)'
      '      FROM tag '
      
        '      INNER JOIN sales_order ON (sales_order.id_tag = tag.id AND' +
        ' '
      
        '                                 sales_order.status <> '#39'New'#39' AND' +
        ' '
      
        '                                 sales_order.status <> '#39'Complete' +
        'd'#39' AND '
      
        '                                 sales_order.status <> '#39'Canceled' +
        #39')'
      '      WHERE tag.id_account = :id_account AND '
      '            tag.status = '#39'Active'#39') AS qty_open_tags,'
      '     (SELECT count(*)'
      '      FROM tag '
      
        '      INNER JOIN sales_order ON (sales_order.id_tag = tag.id AND' +
        ' '
      
        '                                 sales_order.Status = '#39'Preparing' +
        #39')'
      '      WHERE tag.id_account = :id_account AND '
      '            tag.status = '#39'Active'#39') AS qty_preparing_tags'
      ') AS t;'
      '')
    Left = 208
    Top = 120
    ParamData = <
      item
        Name = 'ID_ACCOUNT'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object QrySalesOrder: TFDQuery
    Connection = DM.DBConnection
    SQL.Strings = (
      'SELECT *'
      'FROM sales_order '
      'WHERE id_account = :id_account AND '
      '      status     = '#39'Preparing'#39
      
        'ORDER BY date                                                   ' +
        '                                      ')
    Left = 208
    Top = 248
    ParamData = <
      item
        Name = 'ID_ACCOUNT'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object DscDataCards: TDataSource
    DataSet = QryDataCards
    Left = 272
    Top = 120
  end
  object DscSalesOrder: TDataSource
    DataSet = QrySalesOrder
    Left = 272
    Top = 248
  end
end
