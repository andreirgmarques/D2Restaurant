object DM: TDM
  OnCreate = DataModuleCreate
  Height = 392
  Width = 606
  object DBConnection: TFDConnection
    Params.Strings = (
      'Database=DBD2RESTAURANT'
      'User_Name=fontdata'
      'Password=FDTI1252'
      'Server=localhost'
      'DriverID=PG')
    LoginPrompt = False
    Left = 48
    Top = 24
  end
  object PGDriver: TFDPhysPgDriverLink
    Left = 144
    Top = 24
  end
  object QryAccount: TFDQuery
    Connection = DBConnection
    UpdateOptions.AutoIncFields = 'id'
    SQL.Strings = (
      'SELECT *'
      'FROM account'
      '!filter')
    Left = 48
    Top = 96
    MacroData = <
      item
        Value = Null
        Name = 'FILTER'
      end>
  end
  object DscAccount: TDataSource
    DataSet = QryAccount
    Left = 144
    Top = 96
  end
  object QryProduct: TFDQuery
    Connection = DBConnection
    UpdateOptions.AutoIncFields = 'id'
    SQL.Strings = (
      'SELECT *'
      'FROM product'
      '!filter')
    Left = 48
    Top = 160
    MacroData = <
      item
        Value = Null
        Name = 'FILTER'
      end>
  end
  object DscProduct: TDataSource
    DataSet = QryProduct
    Left = 144
    Top = 160
  end
  object QryProductCategory: TFDQuery
    Connection = DBConnection
    UpdateOptions.AutoIncFields = 'id'
    SQL.Strings = (
      'SELECT *'
      'FROM product_category'
      '!filter')
    Left = 48
    Top = 224
    MacroData = <
      item
        Value = Null
        Name = 'FILTER'
      end>
  end
  object DscProductCategory: TDataSource
    DataSet = QryProductCategory
    Left = 144
    Top = 224
  end
  object QrySalesOrder: TFDQuery
    Connection = DBConnection
    UpdateOptions.AutoIncFields = 'id'
    SQL.Strings = (
      'SELECT *'
      'FROM sales_order'
      '!filter')
    Left = 304
    Top = 24
    MacroData = <
      item
        Value = Null
        Name = 'FILTER'
      end>
  end
  object DscSalesOrder: TDataSource
    DataSet = QrySalesOrder
    Left = 400
    Top = 24
  end
  object QrySalesOrderItem: TFDQuery
    Connection = DBConnection
    UpdateOptions.AutoIncFields = 'id'
    SQL.Strings = (
      'SELECT *'
      'FROM sales_order_item'
      '!filter')
    Left = 304
    Top = 88
    MacroData = <
      item
        Value = Null
        Name = 'FILTER'
      end>
  end
  object DscSalesOrderItem: TDataSource
    DataSet = QrySalesOrderItem
    Left = 400
    Top = 88
  end
  object QryTag: TFDQuery
    Connection = DBConnection
    UpdateOptions.AutoIncFields = 'id'
    SQL.Strings = (
      'SELECT *'
      'FROM tag'
      '!filter')
    Left = 304
    Top = 152
    MacroData = <
      item
        Value = Null
        Name = 'FILTER'
      end>
  end
  object DscTag: TDataSource
    DataSet = QryTag
    Left = 400
    Top = 152
  end
  object QryUser: TFDQuery
    Connection = DBConnection
    UpdateOptions.AutoIncFields = 'id'
    SQL.Strings = (
      'SELECT *'
      'FROM "user"'
      '!filter')
    Left = 304
    Top = 224
    MacroData = <
      item
        Value = Null
        Name = 'FILTER'
      end>
  end
  object DscUser: TDataSource
    DataSet = QryUser
    Left = 400
    Top = 224
  end
  object ACBrMail: TACBrMail
    Host = '127.0.0.1'
    Port = '25'
    SetSSL = False
    SetTLS = False
    Attempts = 3
    DefaultCharset = UTF_8
    IDECharset = CP1252
    Left = 48
    Top = 296
  end
end
