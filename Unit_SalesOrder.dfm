object FormSalesOrder: TFormSalesOrder
  Left = 0
  Top = 0
  Caption = 'FormSalesOrder'
  ClientHeight = 623
  ClientWidth = 778
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnShow = FormShow
  TextHeight = 15
  object LblTagName: TLabel
    Left = 16
    Top = 16
    Width = 22
    Height = 15
    Caption = 'Tag:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object DBTxtTagName: TDBText
    Left = 56
    Top = 16
    Width = 97
    Height = 17
    DataField = 'tag_name'
    DataSource = DM.DscSalesOrder
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LblDate: TLabel
    Left = 16
    Top = 39
    Width = 27
    Height = 15
    Caption = 'Date:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object DBTxtDate: TDBText
    Left = 56
    Top = 39
    Width = 65
    Height = 17
    DataField = 'date'
    DataSource = DM.DscSalesOrder
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object LblStatus: TLabel
    Left = 510
    Top = 16
    Width = 35
    Height = 15
    Caption = 'Status:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object DBTxtStatus: TDBText
    Left = 551
    Top = 16
    Width = 97
    Height = 17
    Color = clBtnFace
    DataField = 'status'
    DataSource = DM.DscSalesOrder
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
  end
  object LblItems: TLabel
    Left = 16
    Top = 83
    Width = 29
    Height = 15
    Caption = 'Items'
  end
  object LblSummary: TLabel
    Left = 16
    Top = 304
    Width = 51
    Height = 15
    Caption = 'Summary'
  end
  object DBTxtQtyItems: TDBText
    Left = 82
    Top = 335
    Width = 65
    Height = 17
    DataField = 'total_qty'
    DataSource = DM.DscSalesOrder
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object LblQtyItems: TLabel
    Left = 16
    Top = 335
    Width = 54
    Height = 15
    Caption = 'Qty Items:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object DBTxtPriceTotal: TDBText
    Left = 82
    Top = 358
    Width = 65
    Height = 17
    DataField = 'total_price'
    DataSource = DM.DscSalesOrder
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object LblPriceTotal: TLabel
    Left = 16
    Top = 358
    Width = 58
    Height = 15
    Caption = 'Price Total:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object BtnOptions: TButton
    Left = 678
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Options'
    TabOrder = 0
  end
  object DbgItems: TDBGrid
    Left = 16
    Top = 104
    Width = 737
    Height = 185
    DataSource = DM.DscSalesOrderItem
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'product_name'
        Title.Caption = 'Product'
        Width = 300
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'qty'
        Title.Alignment = taCenter
        Title.Caption = 'Qty'
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'product_price'
        Title.Caption = 'Unit Price'
        Width = 70
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'total_price'
        Title.Alignment = taRightJustify
        Title.Caption = 'Total'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'description'
        Title.Caption = 'Description'
        Width = 200
        Visible = True
      end>
  end
  object DBMemDescription: TDBMemo
    Left = 16
    Top = 381
    Width = 737
    Height = 185
    DataField = 'description'
    DataSource = DM.DscSalesOrder
    TabOrder = 2
  end
  object BtnSave: TButton
    Left = 16
    Top = 584
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 3
    OnClick = BtnSaveClick
  end
  object BtnDelete: TButton
    Left = 104
    Top = 584
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 4
    OnClick = BtnDeleteClick
  end
  object BtnClose: TButton
    Left = 193
    Top = 584
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 5
    OnClick = BtnCloseClick
  end
  object BtnAddItem: TButton
    Left = 678
    Top = 73
    Width = 75
    Height = 25
    Caption = 'Add Item'
    TabOrder = 6
    OnClick = BtnAddItemClick
  end
  object PnlSelectTag: TPanel
    Left = 510
    Top = 307
    Width = 243
    Height = 63
    BevelOuter = bvNone
    TabOrder = 7
    object LblTag: TLabel
      Left = 7
      Top = 8
      Width = 19
      Height = 15
      Caption = 'Tag'
    end
    object BtnSelectTag: TButton
      Left = 163
      Top = 26
      Width = 75
      Height = 24
      Caption = 'Select'
      TabOrder = 1
      OnClick = BtnSelectTagClick
    end
    object DBCbxTag: TDBLookupComboBox
      Left = 7
      Top = 27
      Width = 152
      Height = 23
      DataField = 'id_tag'
      DataSource = DM.DscSalesOrder
      DropDownWidth = 152
      KeyField = 'id'
      ListField = 'name'
      ListSource = DM.DscTag
      TabOrder = 0
    end
  end
  object PmuOptions: TPopupMenu
    Left = 608
    Top = 64
    object MnuMarkAsReady: TMenuItem
      Caption = 'Mark as Ready'
      OnClick = MnuMarkAsReadyClick
    end
    object MnuMarkAsCompleted: TMenuItem
      Caption = 'Mark as Completed'
      OnClick = MnuMarkAsCompletedClick
    end
  end
end
