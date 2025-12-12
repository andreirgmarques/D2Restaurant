object FormDashboard: TFormDashboard
  Left = 0
  Top = 0
  Caption = 'FormDashboard'
  ClientHeight = 569
  ClientWidth = 896
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object BtnNewOrder: TButton
    Left = 32
    Top = 136
    Width = 75
    Height = 25
    Caption = 'New Order'
    TabOrder = 0
    OnClick = BtnNewOrderClick
  end
end
