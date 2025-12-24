inherited FormUser: TFormUser
  Caption = 'FormUser'
  TextHeight = 14
  inherited Crud_PageControl: TPageControl
    inherited Crud_TabSheetSearch: TTabSheet
      inherited Crud_DBGrid_Search: TDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'name'
            Title.Caption = 'Name'
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'email'
            Title.Caption = 'Email'
            Width = 250
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'phone'
            Title.Caption = 'Phone'
            Width = 80
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'admin'
            Title.Alignment = taCenter
            Title.Caption = 'Admin'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'status'
            Title.Caption = 'Status'
            Width = 70
            Visible = True
          end>
      end
    end
    inherited Crud_TabSheetData: TTabSheet
      object LblName: TLabel [0]
        Left = 32
        Top = 43
        Width = 31
        Height = 14
        Caption = 'Name'
      end
      object LblPhone: TLabel [1]
        Left = 32
        Top = 82
        Width = 35
        Height = 14
        Caption = 'Phone'
      end
      object LblEmail: TLabel [2]
        Left = 32
        Top = 122
        Width = 27
        Height = 14
        Caption = 'Email'
      end
      object LblAdmin: TLabel [3]
        Left = 32
        Top = 162
        Width = 34
        Height = 14
        Caption = 'Admin'
      end
      object LblStatus: TLabel [4]
        Left = 32
        Top = 202
        Width = 35
        Height = 14
        Caption = 'Status'
      end
      object DBEdtName: TDBEdit
        Left = 81
        Top = 40
        Width = 240
        Height = 22
        DataField = 'name'
        DataSource = DM.DscUser
        TabOrder = 3
      end
      object DBEdtPhone: TDBEdit
        Left = 81
        Top = 79
        Width = 240
        Height = 22
        DataField = 'phone'
        DataSource = DM.DscUser
        TabOrder = 4
      end
      object DBEdtEmail: TDBEdit
        Left = 81
        Top = 119
        Width = 240
        Height = 22
        DataField = 'email'
        DataSource = DM.DscUser
        TabOrder = 5
      end
      object DBChkAdmin: TDBCheckBox
        Left = 81
        Top = 159
        Width = 240
        Height = 22
        Caption = 'Is Admin'
        Color = clBtnFace
        DataField = 'admin'
        DataSource = DM.DscUser
        ParentColor = False
        TabOrder = 6
        ValueChecked = 'Yes'
        ValueUnchecked = 'No'
      end
      object DBCbxStatus: TDBComboBox
        Left = 81
        Top = 199
        Width = 240
        Height = 22
        Style = csDropDownList
        DataField = 'status'
        DataSource = DM.DscUser
        Items.Strings = (
          'Active'
          'Inactive')
        TabOrder = 7
      end
      object BtnChangePassword: TButton
        Left = 32
        Top = 242
        Width = 129
        Height = 25
        Caption = 'Change Password'
        TabOrder = 8
        OnClick = BtnChangePasswordClick
      end
      object GpxPassword: TGroupBox
        Left = 448
        Top = 43
        Width = 329
        Height = 198
        Caption = 'Password'
        TabOrder = 9
        object LblOldPassword: TLabel
          Left = 24
          Top = 34
          Width = 73
          Height = 14
          Caption = 'Old Password'
        end
        object LblNewPassword: TLabel
          Left = 24
          Top = 71
          Width = 80
          Height = 14
          Caption = 'New Password'
        end
        object LblConfirmPassword: TLabel
          Left = 24
          Top = 111
          Width = 96
          Height = 14
          Caption = 'Confirm Password'
        end
        object EdtOldPassword: TEdit
          Left = 128
          Top = 31
          Width = 185
          Height = 22
          PasswordChar = '*'
          TabOrder = 0
        end
        object EdtNewPassword: TEdit
          Left = 128
          Top = 68
          Width = 185
          Height = 22
          PasswordChar = '*'
          TabOrder = 1
        end
        object EdtConfirmPassword: TEdit
          Left = 128
          Top = 108
          Width = 185
          Height = 22
          PasswordChar = '*'
          TabOrder = 2
        end
        object BtnSaveNewPassword: TButton
          Left = 24
          Top = 151
          Width = 129
          Height = 25
          Caption = 'Save New Password'
          TabOrder = 3
          OnClick = BtnSaveNewPasswordClick
        end
      end
    end
  end
  inherited Crud_Query: TFDQuery
    SQL.Strings = (
      'SELECT *'
      'FROM "user"'
      'WHERE id_account = :id_account AND'
      '      name    LIKE :name'
      'ORDER BY name')
    ParamData = <
      item
        Name = 'ID_ACCOUNT'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'NAME'
        DataType = ftString
        ParamType = ptInput
      end>
  end
  object QryUserValidEmail: TFDQuery
    Connection = DM.DBConnection
    SQL.Strings = (
      'SELECT *'
      'FROM "user"'
      'WHERE id   <> :id AND'
      '      email = :email'
      '')
    Left = 480
    Top = 8
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'EMAIL'
        DataType = ftString
        ParamType = ptInput
      end>
  end
end
