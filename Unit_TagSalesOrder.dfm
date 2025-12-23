object FormTagSalesOrder: TFormTagSalesOrder
  Left = 0
  Top = 0
  Caption = 'FormTagSalesOrder'
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
  object EdtSearch: TEdit
    Left = 96
    Top = 40
    Width = 241
    Height = 23
    TabOrder = 0
  end
  object BtnSearch: TButton
    Left = 344
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 1
    OnClick = BtnSearchClick
  end
  object PnlTag: TPanel
    Left = 16
    Top = 104
    Width = 171
    Height = 112
    BevelOuter = bvNone
    TabOrder = 2
    object DBTxtTagName: TDBText
      Left = 16
      Top = 16
      Width = 113
      Height = 17
      DataField = 'tag_name'
      DataSource = DscTagSalesOrder
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblTotalPrice: TLabel
      Left = 40
      Top = 48
      Width = 6
      Height = 15
      Caption = '$'
    end
    object DBTxtTotalPrice: TDBText
      Left = 57
      Top = 48
      Width = 112
      Height = 17
      DataField = 'total_price'
      DataSource = DscTagSalesOrder
    end
    object DBTxtStatus: TDBText
      Left = 48
      Top = 80
      Width = 112
      Height = 17
      DataField = 'status'
      DataSource = DscTagSalesOrder
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
    end
    object BtnConfig: TButton
      Left = 135
      Top = 16
      Width = 34
      Height = 25
      TabOrder = 0
      OnClick = BtnConfigClick
    end
  end
  object DscTagSalesOrder: TDataSource
    DataSet = QryTagSalesOrder
    Left = 360
    Top = 128
  end
  object QryTagSalesOrder: TFDQuery
    Connection = DM.DBConnection
    SQL.Strings = (
      'Select t.id AS id_tag,'
      '       t.tag_type,'
      '       t."name" AS tag_name,'
      '       coalesce(sum(soi.total_price),0.00) AS total_price,'
      '       CASE'
      '           WHEN coalesce(so.id, 0) <= 0 THEN '#39'Available'#39
      '           ELSE '#39'Open'#39
      '       END AS status'
      'FROM tag t'
      'LEFT JOIN sales_order so ON (so.id_tag = t.id         AND '
      '                             so.status <> '#39'New'#39'       AND '
      '                             so.status <> '#39'Completed'#39' AND '
      '                             so.status <> '#39'Canceled'#39')'
      'LEFT JOIN sales_order_item soi ON (soi.id_sales_order = so.id)'
      'WHERE t.id_account = :id_account AND '
      '      t.status = '#39'Active'#39' AND '
      '      (t.name LIKE :name OR t.number LIKE :number)'
      'GROUP BY t.id,'
      '         t.tag_type,'
      '         t.name,'
      '         so.id'
      'ORDER BY t.name')
    Left = 296
    Top = 128
    ParamData = <
      item
        Name = 'ID_ACCOUNT'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NAME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NUMBER'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
