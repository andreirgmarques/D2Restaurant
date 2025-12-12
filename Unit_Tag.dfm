inherited FormTag: TFormTag
  Caption = 'FormTag'
  ClientHeight = 585
  ClientWidth = 831
  ExplicitWidth = 847
  ExplicitHeight = 624
  TextHeight = 14
  inherited Crud_PageControl: TPageControl
    Width = 831
    Height = 525
    ActivePage = Crud_TabSheetData
    ExplicitWidth = 831
    ExplicitHeight = 525
    inherited Crud_TabSheetSearch: TTabSheet
      ExplicitWidth = 823
      ExplicitHeight = 496
      DesignSize = (
        823
        496)
      inherited Crud_DBGrid_Search: TDBGrid
        Width = 817
        Height = 457
        Columns = <
          item
            Expanded = False
            FieldName = 'name'
            Title.Caption = 'Tag Name'
            Width = 250
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'tag_type'
            Title.Caption = 'Type'
            Width = 90
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'number'
            Title.Caption = 'Number/Code'
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'status'
            Title.Caption = 'Status'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'description'
            Title.Caption = 'Description'
            Width = 150
            Visible = True
          end>
      end
      object BtnBulkInsert: TButton
        Left = 479
        Top = 7
        Width = 75
        Height = 25
        Caption = 'Bulk Insert'
        TabOrder = 5
        OnClick = BtnBulkInsertClick
      end
    end
    inherited Crud_TabSheetData: TTabSheet
      ExplicitWidth = 823
      ExplicitHeight = 496
      DesignSize = (
        823
        496)
      object LblId: TLabel [0]
        Left = 16
        Top = 32
        Width = 11
        Height = 14
        Caption = 'Id'
      end
      object DBTxtId: TDBText [1]
        Left = 112
        Top = 32
        Width = 65
        Height = 17
        DataField = 'id'
        DataSource = DM.DscTag
      end
      object LblTagType: TLabel [2]
        Left = 16
        Top = 64
        Width = 53
        Height = 14
        Caption = 'Tag Type'
      end
      object LblName: TLabel [3]
        Left = 16
        Top = 103
        Width = 31
        Height = 14
        Caption = 'Name'
      end
      object LblNumber: TLabel [4]
        Left = 16
        Top = 143
        Width = 76
        Height = 14
        Caption = 'Number/Code'
      end
      object LblDescription: TLabel [5]
        Left = 16
        Top = 183
        Width = 60
        Height = 14
        Caption = 'Description'
      end
      object LblStatus: TLabel [6]
        Left = 16
        Top = 320
        Width = 35
        Height = 14
        Caption = 'Status'
      end
      object DBCbxTagType: TDBComboBox
        Left = 112
        Top = 61
        Width = 273
        Height = 22
        Style = csDropDownList
        DataField = 'tag_type'
        DataSource = DM.DscTag
        Items.Strings = (
          'Table'
          'Command'
          'Other')
        TabOrder = 3
      end
      object DBEdtName: TDBEdit
        Left = 112
        Top = 100
        Width = 273
        Height = 22
        DataField = 'name'
        DataSource = DM.DscTag
        TabOrder = 4
      end
      object DBEdtNumber: TDBEdit
        Left = 112
        Top = 140
        Width = 273
        Height = 22
        DataField = 'number'
        DataSource = DM.DscTag
        TabOrder = 5
      end
      object DBMemDescription: TDBMemo
        Left = 112
        Top = 180
        Width = 273
        Height = 117
        DataField = 'description'
        DataSource = DM.DscTag
        TabOrder = 6
      end
      object DBCbxStatus: TDBComboBox
        Left = 112
        Top = 317
        Width = 273
        Height = 22
        Style = csDropDownList
        DataField = 'status'
        DataSource = DM.DscTag
        Items.Strings = (
          'Active'
          'Inactive')
        TabOrder = 7
      end
      object PnlBulkInsert: TPanel
        Left = 464
        Top = 56
        Width = 321
        Height = 169
        BevelOuter = bvNone
        TabOrder = 8
        DesignSize = (
          321
          169)
        object LblBulkType: TLabel
          Left = 24
          Top = 8
          Width = 28
          Height = 14
          Caption = 'Type'
        end
        object LblBulkPrefix: TLabel
          Left = 24
          Top = 47
          Width = 30
          Height = 14
          Caption = 'Prefix'
        end
        object LblBulkQty: TLabel
          Left = 24
          Top = 87
          Width = 20
          Height = 14
          Caption = 'Qty'
        end
        object CbxBulkType: TComboBox
          Left = 80
          Top = 5
          Width = 209
          Height = 22
          Style = csDropDownList
          TabOrder = 0
          Items.Strings = (
            'Table'
            'Command'
            'Other')
        end
        object EdtBulkPrefix: TEdit
          Left = 80
          Top = 44
          Width = 209
          Height = 22
          TabOrder = 1
        end
        object EdtBulkQty: TEdit
          Left = 80
          Top = 84
          Width = 209
          Height = 22
          NumbersOnly = True
          TabOrder = 2
        end
        object BtnBulkCreate: TButton
          Left = 24
          Top = 123
          Width = 85
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Create'
          TabOrder = 3
          OnClick = BtnBulkCreateClick
        end
      end
    end
  end
  inherited Crud_PanelTitle: TPanel
    Width = 831
    ExplicitWidth = 831
  end
  inherited Crud_PanelSubTitle: TPanel
    Width = 831
    ExplicitWidth = 831
  end
  inherited Crud_Query: TFDQuery
    SQL.Strings = (
      'SELECT *'
      'FROM tag'
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
end
