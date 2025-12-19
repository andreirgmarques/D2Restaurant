object FormSalesOrderProduct: TFormSalesOrderProduct
  Left = 0
  Top = 0
  Caption = 'FormSalesOrderProduct'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object DBTxtProductCategory: TDBText
    Left = 24
    Top = 24
    Width = 177
    Height = 25
    DataField = 'name'
    DataSource = DM.DscProductCategory
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PnlProduct: TPanel
    Left = 24
    Top = 64
    Width = 241
    Height = 241
    BevelOuter = bvNone
    TabOrder = 0
    object DBTxtProduct: TDBText
      Left = 16
      Top = 176
      Width = 145
      Height = 17
      DataField = 'name'
      DataSource = DM.DscProduct
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblPrice: TLabel
      Left = 155
      Top = 216
      Width = 6
      Height = 15
      Caption = '$'
    end
    object DBTxtPrice: TDBText
      Left = 168
      Top = 216
      Width = 65
      Height = 17
      DataField = 'price'
      DataSource = DM.DscProduct
    end
  end
end
