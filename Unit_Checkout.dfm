object FormCheckout: TFormCheckout
  Left = 0
  Top = 0
  Caption = 'FormCheckout'
  ClientHeight = 414
  ClientWidth = 591
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object LblTagName: TLabel
    Left = 16
    Top = 16
    Width = 22
    Height = 15
    Caption = 'Tag:'
  end
  object DBTxtTagName: TDBText
    Left = 48
    Top = 16
    Width = 97
    Height = 16
    DataField = 'tag_name'
    DataSource = DscCheckout
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ImgProduct: TImage
    Left = 16
    Top = 72
    Width = 90
    Height = 90
  end
  object LblOrderId: TLabel
    Left = 128
    Top = 72
    Width = 46
    Height = 15
    Caption = 'Order Id:'
  end
  object LblItem: TLabel
    Left = 128
    Top = 101
    Width = 27
    Height = 15
    Caption = 'Item:'
  end
  object LblQty: TLabel
    Left = 128
    Top = 128
    Width = 22
    Height = 15
    Caption = 'Qty:'
  end
  object DBTxtOrderId: TDBText
    Left = 180
    Top = 72
    Width = 85
    Height = 17
    DataField = 'id_sales_order'
    DataSource = DscCheckout
  end
  object DBTxtItem: TDBText
    Left = 164
    Top = 102
    Width = 81
    Height = 17
    DataField = 'product_name'
    DataSource = DscCheckout
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DBTxtQty: TDBText
    Left = 164
    Top = 128
    Width = 81
    Height = 17
    DataField = 'qty'
    DataSource = DscCheckout
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object DBTxtUnitPrice: TDBText
    Left = 316
    Top = 128
    Width = 81
    Height = 17
    DataField = 'product_price'
    DataSource = DscCheckout
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object LblUnitPrice: TLabel
    Left = 280
    Top = 128
    Width = 29
    Height = 15
    Caption = 'Price:'
  end
  object DBTxtTotalPrice: TDBText
    Left = 476
    Top = 128
    Width = 100
    Height = 17
    DataField = 'total_price'
    DataSource = DscCheckout
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LblTotalPrice: TLabel
    Left = 440
    Top = 128
    Width = 29
    Height = 15
    Caption = 'Total:'
  end
  object LblSummary: TLabel
    Left = 16
    Top = 248
    Width = 53
    Height = 15
    Caption = 'Summary'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object LblSummaryQty: TLabel
    Left = 16
    Top = 280
    Width = 55
    Height = 15
    Caption = 'Qtd Items:'
  end
  object LblSummaryQtyValue: TLabel
    Left = 88
    Top = 278
    Width = 11
    Height = 17
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object LblSummaryTotalValue: TLabel
    Left = 88
    Top = 299
    Width = 11
    Height = 21
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LblSummaryTotal: TLabel
    Left = 16
    Top = 304
    Width = 58
    Height = 15
    Caption = 'Price Total:'
  end
  object BtnReceive: TButton
    Left = 16
    Top = 352
    Width = 264
    Height = 41
    Caption = 'Receive'
    TabOrder = 0
    OnClick = BtnReceiveClick
  end
  object BtnCancel: TButton
    Left = 302
    Top = 352
    Width = 264
    Height = 41
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = BtnCancelClick
  end
  object QryCheckout: TFDQuery
    Connection = DM.DBConnection
    SQL.Strings = (
      'SELECT so.id AS id_sales_order,'
      '       so.date,'
      '       t.name AS tag_name,'
      '       soi.product_name,'
      '       soi.qty,'
      '       soi.product_price,'
      '       soi.total_price,'
      '       p.image_file '
      'FROM sales_order so'
      'INNER JOIN tag t ON t.id = so.id_tag '
      'INNER JOIN sales_order_item soi ON soi.id_sales_order = so.id'
      'INNER JOIN product p ON p.id = soi.id_product '
      'WHERE so.id_tag = :id_tag AND '
      '      so.status NOT IN ('#39'New'#39', '#39'Canceled'#39', '#39'Completed'#39')    '
      'ORDER BY so.date,'
      '         soi.product_name ')
    Left = 368
    Top = 32
    ParamData = <
      item
        Name = 'ID_TAG'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object DscCheckout: TDataSource
    DataSet = QryCheckout
    Left = 448
    Top = 32
  end
end
