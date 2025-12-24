inherited FormProduct: TFormProduct
  Caption = 'FormProduct'
  TextHeight = 14
  inherited Crud_PageControl: TPageControl
    inherited Crud_TabSheetSearch: TTabSheet
      inherited Crud_DBGrid_Search: TDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'name'
            Title.Caption = 'Product'
            Width = 350
            Visible = True
          end
          item
            Alignment = taRightJustify
            Expanded = False
            FieldName = 'price'
            Title.Alignment = taRightJustify
            Title.Caption = 'Price'
            Width = 70
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'status'
            Title.Alignment = taCenter
            Title.Caption = 'Status'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'category'
            Title.Caption = 'Category'
            Width = 150
            Visible = True
          end>
      end
    end
    inherited Crud_TabSheetData: TTabSheet
      object ImgProduct: TImage [0]
        Left = 16
        Top = 49
        Width = 136
        Height = 159
      end
      object LblId: TLabel [1]
        Left = 208
        Top = 49
        Width = 11
        Height = 14
        Caption = 'Id'
      end
      object DBTxtId: TDBText [2]
        Left = 304
        Top = 49
        Width = 65
        Height = 17
        DataField = 'id'
        DataSource = DM.DscProduct
      end
      object LblProduct: TLabel [3]
        Left = 208
        Top = 81
        Width = 43
        Height = 14
        Caption = 'Product'
      end
      object LblCategory: TLabel [4]
        Left = 208
        Top = 120
        Width = 49
        Height = 14
        Caption = 'Category'
      end
      object LblPrice: TLabel [5]
        Left = 208
        Top = 158
        Width = 26
        Height = 14
        Caption = 'Price'
      end
      object LblDescription: TLabel [6]
        Left = 208
        Top = 199
        Width = 60
        Height = 14
        Caption = 'Description'
      end
      object LblStatus: TLabel [7]
        Left = 208
        Top = 332
        Width = 35
        Height = 14
        Caption = 'Status'
      end
      object DBEdtProduct: TDBEdit
        Left = 304
        Top = 78
        Width = 273
        Height = 22
        DataField = 'name'
        DataSource = DM.DscProduct
        TabOrder = 3
      end
      object DBEdtPrice: TDBEdit
        Left = 304
        Top = 155
        Width = 129
        Height = 22
        DataField = 'price'
        DataSource = DM.DscProduct
        TabOrder = 4
      end
      object DBMemDescription: TDBMemo
        Left = 304
        Top = 196
        Width = 273
        Height = 117
        DataField = 'description'
        DataSource = DM.DscProduct
        TabOrder = 5
      end
      object DBCbxStatus: TDBComboBox
        Left = 304
        Top = 329
        Width = 145
        Height = 22
        Style = csDropDownList
        DataField = 'status'
        DataSource = DM.DscProduct
        Items.Strings = (
          'Active'
          'Inactive')
        TabOrder = 6
      end
      object DBCbxCategory: TDBLookupComboBox
        Left = 304
        Top = 116
        Width = 273
        Height = 22
        DataField = 'id_product_category'
        DataSource = DM.DscProduct
        KeyField = 'id'
        ListField = 'name'
        ListSource = DM.DscProductCategory
        TabOrder = 7
      end
    end
  end
  inherited Crud_Query: TFDQuery
    SQL.Strings = (
      'SELECT p.id, '
      '       p."name",'
      '       p.price,'
      '       p.description,'
      '       p.status,'
      '       pc."name" AS category '
      'FROM product p'
      'LEFT JOIN product_category pc ON pc.id = p.id_product_category'
      'WHERE p.id_account = :id_account AND '
      '      p."name"  LIKE :name'
      'ORDER BY p."name" ')
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
