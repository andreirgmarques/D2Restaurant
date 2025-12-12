inherited FormProductCategory: TFormProductCategory
  Caption = 'FormProductCategory'
  TextHeight = 14
  inherited Crud_PageControl: TPageControl
    ActivePage = Crud_TabSheetData
    inherited Crud_TabSheetSearch: TTabSheet
      inherited Crud_DBGrid_Search: TDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'name'
            Title.Caption = 'Category'
            Width = 300
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'status'
            Title.Caption = 'Status'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'description'
            Title.Caption = 'Description'
            Width = 300
            Visible = True
          end>
      end
    end
    inherited Crud_TabSheetData: TTabSheet
      object LblName: TLabel [0]
        Left = 24
        Top = 47
        Width = 31
        Height = 14
        Caption = 'Name'
      end
      object LblDescription: TLabel [1]
        Left = 24
        Top = 87
        Width = 60
        Height = 14
        Caption = 'Description'
      end
      object LblStatus: TLabel [2]
        Left = 24
        Top = 224
        Width = 35
        Height = 14
        Caption = 'Status'
      end
      object DBEdtName: TDBEdit
        Left = 120
        Top = 44
        Width = 273
        Height = 22
        DataField = 'name'
        DataSource = DM.DscProductCategory
        TabOrder = 3
      end
      object DBMemDescription: TDBMemo
        Left = 120
        Top = 84
        Width = 273
        Height = 117
        DataField = 'description'
        DataSource = DM.DscProductCategory
        TabOrder = 4
      end
      object DBCbxStatus: TDBComboBox
        Left = 120
        Top = 221
        Width = 273
        Height = 22
        Style = csDropDownList
        DataField = 'status'
        DataSource = DM.DscProductCategory
        Items.Strings = (
          'Active'
          'Inactive')
        TabOrder = 5
      end
    end
  end
  inherited Crud_Query: TFDQuery
    SQL.Strings = (
      '')
  end
end
