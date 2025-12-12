object FormCreateAccount: TFormCreateAccount
  Left = 0
  Top = 0
  Caption = 'FormCreateAccount'
  ClientHeight = 372
  ClientWidth = 867
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object LblFullName: TLabel
    Left = 24
    Top = 24
    Width = 54
    Height = 15
    Caption = 'Full Name'
  end
  object LblEmail: TLabel
    Left = 24
    Top = 64
    Width = 29
    Height = 15
    Caption = 'Email'
  end
  object LblComplement: TLabel
    Left = 24
    Top = 184
    Width = 70
    Height = 15
    Caption = 'Complement'
  end
  object LblCity: TLabel
    Left = 24
    Top = 224
    Width = 21
    Height = 15
    Caption = 'City'
  end
  object LblCountry: TLabel
    Left = 24
    Top = 104
    Width = 43
    Height = 15
    Caption = 'Country'
  end
  object LblPostalCode: TLabel
    Left = 24
    Top = 144
    Width = 63
    Height = 15
    Caption = 'Postal Code'
  end
  object LblAddress: TLabel
    Left = 368
    Top = 144
    Width = 42
    Height = 15
    Caption = 'Address'
  end
  object LblNumber: TLabel
    Left = 656
    Top = 144
    Width = 44
    Height = 15
    Caption = 'Number'
  end
  object LblDocument: TLabel
    Left = 582
    Top = 24
    Width = 56
    Height = 15
    Caption = 'Document'
  end
  object LblPhone: TLabel
    Left = 582
    Top = 64
    Width = 34
    Height = 15
    Caption = 'Phone'
  end
  object LblNeighborhood: TLabel
    Left = 512
    Top = 184
    Width = 78
    Height = 15
    Caption = 'Neighborhood'
  end
  object LblState: TLabel
    Left = 512
    Top = 224
    Width = 26
    Height = 15
    Caption = 'State'
  end
  object LblPassword: TLabel
    Left = 24
    Top = 264
    Width = 50
    Height = 15
    Caption = 'Password'
  end
  object LblConfirmation: TLabel
    Left = 464
    Top = 264
    Width = 71
    Height = 15
    Caption = 'Confirmation'
  end
  object BtnCreateAccount: TButton
    Left = 368
    Top = 312
    Width = 121
    Height = 25
    Caption = 'Create Account'
    TabOrder = 14
    OnClick = BtnCreateAccountClick
  end
  object EdtFullName: TDBEdit
    Left = 140
    Top = 21
    Width = 341
    Height = 23
    DataField = 'name'
    DataSource = DM.DscAccount
    TabOrder = 0
  end
  object EdtEmail: TDBEdit
    Left = 140
    Top = 61
    Width = 341
    Height = 23
    DataField = 'email'
    DataSource = DM.DscAccount
    ReadOnly = True
    TabOrder = 2
  end
  object EdtComplement: TDBEdit
    Left = 140
    Top = 181
    Width = 341
    Height = 23
    DataField = 'address_ref'
    DataSource = DM.DscAccount
    TabOrder = 8
  end
  object EdtCity: TDBEdit
    Left = 140
    Top = 221
    Width = 341
    Height = 23
    DataField = 'city'
    DataSource = DM.DscAccount
    TabOrder = 10
  end
  object EdtPostalCode: TDBEdit
    Left = 140
    Top = 141
    Width = 197
    Height = 23
    DataField = 'postal_code'
    DataSource = DM.DscAccount
    TabOrder = 5
  end
  object EdtAddress: TDBEdit
    Left = 441
    Top = 141
    Width = 197
    Height = 23
    DataField = 'address'
    DataSource = DM.DscAccount
    TabOrder = 6
  end
  object EdtNumber: TDBEdit
    Left = 724
    Top = 141
    Width = 117
    Height = 23
    DataField = 'address_number'
    DataSource = DM.DscAccount
    TabOrder = 7
  end
  object EdtDocument: TDBEdit
    Left = 644
    Top = 21
    Width = 197
    Height = 23
    DataField = 'document'
    DataSource = DM.DscAccount
    TabOrder = 1
  end
  object EdtPhone: TDBEdit
    Left = 644
    Top = 61
    Width = 197
    Height = 23
    DataField = 'phone'
    DataSource = DM.DscUser
    TabOrder = 3
  end
  object EdtNeighborhood: TDBEdit
    Left = 604
    Top = 181
    Width = 237
    Height = 23
    DataField = 'neighborhood'
    DataSource = DM.DscAccount
    TabOrder = 9
  end
  object EdtState: TDBEdit
    Left = 604
    Top = 221
    Width = 237
    Height = 23
    DataField = 'state'
    DataSource = DM.DscAccount
    TabOrder = 11
  end
  object EdtPassword: TDBEdit
    Left = 140
    Top = 261
    Width = 261
    Height = 23
    DataField = 'password'
    DataSource = DM.DscUser
    PasswordChar = '*'
    TabOrder = 12
  end
  object CbxCountry: TDBComboBox
    Left = 140
    Top = 101
    Width = 341
    Height = 23
    Style = csDropDownList
    DataField = 'country'
    DataSource = DM.DscAccount
    DropDownWidth = 341
    Items.Strings = (
      'Afghanistan'
      'Albania'
      'Algeria'
      'Andorra'
      'Angola'
      'Antigua and Barbuda'
      'Argentina'
      'Armenia'
      'Australia'
      'Austria'
      'Azerbaijan'
      'Bahamas'
      'Bahrain'
      'Bangladesh'
      'Barbados'
      'Belarus'
      'Belgium'
      'Belize'
      'Benin'
      'Bhutan'
      'Bolivia'
      'Bosnia and Herzegovina'
      'Botswana'
      'Brazil'
      'Brunei'
      'Bulgaria'
      'Burkina Faso'
      'Burundi'
      'Cabo Verde'
      'Cambodia'
      'Cameroon'
      'Canada'
      'Central African Republic'
      'Chad'
      'Chile'
      'China'
      'Colombia'
      'Comoros'
      'Congo (Congo-Brazzaville)'
      'Congo (Congo-Kinshasa)'
      'Costa Rica'
      'Croatia'
      'Cuba'
      'Cyprus'
      'Czech Republic'
      'Denmark'
      'Djibouti'
      'Dominica'
      'Dominican Republic'
      'East Timor (Timor-Leste)'
      'Ecuador'
      'Egypt'
      'El Salvador'
      'Equatorial Guinea'
      'Eritrea'
      'Estonia'
      'Eswatini'
      'Ethiopia'
      'Fiji'
      'Finland'
      'France'
      'Gabon'
      'Gambia'
      'Georgia'
      'Germany'
      'Ghana'
      'Greece'
      'Grenada'
      'Guatemala'
      'Guinea'
      'Guinea-Bissau'
      'Guyana'
      'Haiti'
      'Honduras'
      'Hungary'
      'Iceland'
      'India'
      'Indonesia'
      'Iran'
      'Iraq'
      'Ireland'
      'Israel'
      'Italy'
      'Ivory Coast'
      'Jamaica'
      'Japan'
      'Jordan'
      'Kazakhstan'
      'Kenya'
      'Kiribati'
      'Korea, North'
      'Korea, South'
      'Kosovo'
      'Kuwait'
      'Kyrgyzstan'
      'Laos'
      'Latvia'
      'Lebanon'
      'Lesotho'
      'Liberia'
      'Libya'
      'Liechtenstein'
      'Lithuania'
      'Luxembourg'
      'Madagascar'
      'Malawi'
      'Malaysia'
      'Maldives'
      'Mali'
      'Malta'
      'Marshall Islands'
      'Mauritania'
      'Mauritius'
      'Mexico'
      'Micronesia'
      'Moldova'
      'Monaco'
      'Mongolia'
      'Montenegro'
      'Morocco'
      'Mozambique'
      'Myanmar (Burma)'
      'Namibia'
      'Nauru'
      'Nepal'
      'Netherlands'
      'New Zealand'
      'Nicaragua'
      'Niger'
      'Nigeria'
      'North Macedonia'
      'Norway'
      'Oman'
      'Pakistan'
      'Palau'
      'Panama'
      'Papua New Guinea'
      'Paraguay'
      'Peru'
      'Philippines'
      'Poland'
      'Portugal'
      'Qatar'
      'Romania'
      'Russia'
      'Rwanda'
      'Saint Kitts and Nevis'
      'Saint Lucia'
      'Saint Vincent and the Grenadines'
      'Samoa'
      'San Marino'
      'Sao Tome and Principe'
      'Saudi Arabia'
      'Senegal'
      'Serbia'
      'Seychelles'
      'Sierra Leone'
      'Singapore'
      'Slovakia'
      'Slovenia'
      'Solomon Islands'
      'Somalia'
      'South Africa'
      'South Sudan'
      'Spain'
      'Sri Lanka'
      'Sudan'
      'Suriname'
      'Sweden'
      'Switzerland'
      'Syria'
      'Taiwan'
      'Tajikistan'
      'Tanzania'
      'Thailand'
      'Togo'
      'Tonga'
      'Trinidad and Tobago'
      'Tunisia'
      'Turkey'
      'Turkmenistan'
      'Tuvalu'
      'Uganda'
      'Ukraine'
      'United Arab Emirates'
      'United Kingdom'
      'United States'
      'Uruguay'
      'Uzbekistan'
      'Vanuatu'
      'Vatican City'
      'Venezuela'
      'Vietnam'
      'Yemen'
      'Zambia'
      'Zimbabwe')
    TabOrder = 4
  end
  object EdtConfirmation: TEdit
    Left = 580
    Top = 261
    Width = 261
    Height = 23
    PasswordChar = '*'
    TabOrder = 13
  end
end
