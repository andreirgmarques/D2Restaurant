object FormSalesOrderCategory: TFormSalesOrderCategory
  Left = 0
  Top = 0
  Caption = 'FormSalesOrderCategory'
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
  object DbgCategory: TDBGrid
    Left = 40
    Top = 88
    Width = 553
    Height = 313
    DataSource = DM.DscProductCategory
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'name'
        Title.Caption = 'Product Category'
        Width = 300
        Visible = True
      end>
  end
  object BtnSelect: TButton
    Left = 40
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Select'
    TabOrder = 1
    OnClick = BtnSelectClick
  end
end
