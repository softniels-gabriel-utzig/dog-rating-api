object DataStream: TDataStream
  Height = 321
  Width = 425
  object con: TUniConnection
    ProviderName = 'mySQL'
    Port = 3306
    Database = 'dog_rating'
    Username = 'root'
    Server = 'localhost'
    Connected = True
    Left = 64
    Top = 128
    EncryptedPassword = '9EFF9BFF92FF96FF91FF'
  end
  object query: TUniQuery
    Connection = con
    Left = 120
    Top = 136
  end
  object sql: TUniSQL
    Connection = con
    Left = 184
    Top = 56
  end
  object dataSource: TUniDataSource
    DataSet = query
    Left = 64
    Top = 72
  end
  object mysqlnprvdr: TMySQLUniProvider
    Left = 200
    Top = 144
  end
end
