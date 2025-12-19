object FormSalesOrderItem: TFormSalesOrderItem
  Left = 0
  Top = 0
  Caption = 'FormSalesOrderItem'
  ClientHeight = 475
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object LblTag: TLabel
    Left = 24
    Top = 24
    Width = 22
    Height = 15
    Caption = 'Tag:'
  end
  object LblProductCategory: TLabel
    Left = 24
    Top = 56
    Width = 51
    Height = 15
    Caption = 'Category:'
  end
  object LblProduct: TLabel
    Left = 24
    Top = 88
    Width = 42
    Height = 15
    Caption = 'Product'
  end
  object LblPrice: TLabel
    Left = 24
    Top = 152
    Width = 29
    Height = 15
    Caption = 'Price:'
  end
  object LblQty: TLabel
    Left = 24
    Top = 192
    Width = 19
    Height = 15
    Caption = 'Qty'
  end
  object LblTotal: TLabel
    Left = 24
    Top = 232
    Width = 26
    Height = 15
    Caption = 'Total'
  end
  object DBTxtTag: TDBText
    Left = 61
    Top = 24
    Width = 65
    Height = 15
    DataField = 'tag_name'
    DataSource = DM.DscSalesOrder
  end
  object DBTxtProductCategory: TDBText
    Left = 82
    Top = 56
    Width = 135
    Height = 15
    DataField = 'product_category_name'
    DataSource = DM.DscSalesOrderItem
  end
  object DBTxtProduct: TDBText
    Left = 24
    Top = 105
    Width = 135
    Height = 16
    DataField = 'product_name'
    DataSource = DM.DscSalesOrderItem
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DBTxtPrice: TDBText
    Left = 61
    Top = 152
    Width = 135
    Height = 15
    DataField = 'product_price'
    DataSource = DM.DscSalesOrderItem
  end
  object DBTxtTotal: TDBText
    Left = 61
    Top = 232
    Width = 135
    Height = 15
    DataField = 'total_price'
    DataSource = DM.DscSalesOrderItem
  end
  object BtnDecQty: TButton
    Left = 61
    Top = 188
    Width = 27
    Height = 25
    TabOrder = 0
    OnClick = BtnDecQtyClick
  end
  object DBEdtQty: TDBEdit
    Left = 94
    Top = 189
    Width = 75
    Height = 23
    DataField = 'qty'
    DataSource = DM.DscSalesOrderItem
    TabOrder = 1
  end
  object BtnIncQty: TButton
    Left = 175
    Top = 188
    Width = 27
    Height = 25
    TabOrder = 2
    OnClick = BtnIncQtyClick
  end
  object DBMemDescription: TDBMemo
    Left = 24
    Top = 264
    Width = 265
    Height = 129
    DataField = 'description'
    DataSource = DM.DscSalesOrderItem
    TabOrder = 3
  end
  object BtnSave: TButton
    Left = 24
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 4
    OnClick = BtnSaveClick
  end
  object BtnDelete: TButton
    Left = 121
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 5
    OnClick = BtnDeleteClick
  end
  object BtnClose: TButton
    Left = 214
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 6
    OnClick = BtnCloseClick
  end
end
