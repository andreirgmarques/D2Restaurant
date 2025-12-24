object FormLogin: TFormLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Form Login'
  ClientHeight = 419
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnShow = FormShow
  TextHeight = 15
  object Image_BackGround: TImage
    Left = 0
    Top = 0
    Width = 301
    Height = 419
    Align = alClient
    Stretch = True
    ExplicitLeft = 194
    ExplicitTop = 12
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Panel1: TPanel
    Left = 29
    Top = 23
    Width = 239
    Height = 354
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Image_Logo: TImage
      Left = 87
      Top = 13
      Width = 73
      Height = 73
      Proportional = True
      Stretch = True
    end
    object Label_Login: TLabel
      Left = 95
      Top = 115
      Width = 51
      Height = 30
      Alignment = taCenter
      Caption = 'Login'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LblDontHaveAccount: TLabel
      Left = 18
      Top = 312
      Width = 121
      Height = 15
      Caption = 'Dont have an account?'
    end
    object LblSignUp: TLabel
      Left = 174
      Top = 312
      Width = 41
      Height = 15
      Caption = 'Sign Up'
      OnClick = LblSignUpClick
    end
    object Edit_UserName: TEdit
      Left = 18
      Top = 167
      Width = 197
      Height = 23
      TabOrder = 0
      TextHint = 'Username'
    end
    object Edit_Password: TEdit
      Left = 14
      Top = 215
      Width = 160
      Height = 23
      PasswordChar = '*'
      TabOrder = 1
      TextHint = 'Password'
    end
    object Button_Login: TButton
      Left = 79
      Top = 265
      Width = 75
      Height = 25
      Caption = 'Login'
      TabOrder = 2
      OnClick = Button_LoginClick
    end
    object Button_ShowPass: TButton
      Left = 180
      Top = 214
      Width = 35
      Height = 25
      TabOrder = 3
      OnClick = Button_ShowPassClick
    end
  end
end
