object FormMenu: TFormMenu
  Left = 0
  Top = 0
  Caption = 'FormMenu'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  TextHeight = 14
  object MainMenu1: TMainMenu
    Left = 176
    Top = 152
    object Dashboard1: TMenuItem
      Caption = 'Dashboard'
    end
    object Checkout1: TMenuItem
      Caption = 'Checkout'
    end
    object Config1: TMenuItem
      Caption = 'Config'
      object Product1: TMenuItem
        Caption = 'Product'
        OnClick = Product1Click
      end
      object Category1: TMenuItem
        Caption = 'Category'
        OnClick = Category1Click
      end
      object Tag1: TMenuItem
        Caption = 'Tag'
        OnClick = Tag1Click
      end
      object User1: TMenuItem
        Caption = 'User'
      end
    end
    object Logout1: TMenuItem
      Caption = 'Logout'
      OnClick = Logout1Click
    end
  end
end
