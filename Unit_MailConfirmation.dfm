object FormMailConfirmation: TFormMailConfirmation
  Left = 0
  Top = 0
  Caption = 'FormMailConfirmation'
  ClientHeight = 213
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object PnlVerify: TPanel
    Left = 8
    Top = 105
    Width = 331
    Height = 88
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object LblCodeVerify: TLabel
      Left = 24
      Top = 7
      Width = 260
      Height = 15
      Caption = 'Enter the code your received in your email bellow'
    end
    object EdtCodeVerify: TEdit
      Left = 24
      Top = 28
      Width = 289
      Height = 23
      Alignment = taCenter
      MaxLength = 6
      NumbersOnly = True
      TabOrder = 0
    end
    object BtnVerify: TButton
      Left = 96
      Top = 57
      Width = 121
      Height = 25
      Caption = 'Verify'
      TabOrder = 1
      OnClick = BtnVerifyClick
    end
  end
  object PnlEmail: TPanel
    Left = 8
    Top = 8
    Width = 331
    Height = 91
    BevelOuter = bvNone
    TabOrder = 1
    object LblEnterYourEmail: TLabel
      Left = 16
      Top = 9
      Width = 91
      Height = 15
      Caption = 'Enter your e-mail'
    end
    object EdtEnterYourEmail: TEdit
      Left = 16
      Top = 30
      Width = 289
      Height = 23
      TabOrder = 0
    end
    object BtnClose: TButton
      Left = 16
      Top = 60
      Width = 121
      Height = 25
      Caption = 'Close'
      TabOrder = 1
      OnClick = BtnCloseClick
    end
    object BtnSendCode: TButton
      Left = 143
      Top = 60
      Width = 162
      Height = 25
      Caption = 'Send Code'
      TabOrder = 2
      OnClick = BtnSendCodeClick
    end
  end
end
