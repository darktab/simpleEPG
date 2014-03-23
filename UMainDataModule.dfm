object MainDataModule: TMainDataModule
  OldCreateOrder = False
  Height = 290
  Width = 529
  object DreamRESTClient: TRESTClient
    Authenticator = DreamHTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    AcceptEncoding = 'identity'
    BaseURL = 'http://vuduo2.fritz.box/api'
    Params = <>
    HandleRedirects = True
    Left = 128
    Top = 24
  end
  object DreamRESTRequestChannelList: TRESTRequest
    Client = DreamRESTClient
    Params = <>
    Resource = 
      'getservices?sRef=1:7:1:0:0:0:0:0:0:0:FROM%20BOUQUET%20%22userbou' +
      'quet.favourites.tv%22%20ORDER%20BY%20bouquet'
    Response = DreamRESTResponseChannelList
    Left = 128
    Top = 96
  end
  object DreamRESTResponseChannelList: TRESTResponse
    Left = 128
    Top = 160
  end
  object DreamRESTResponseDataSetAdapterChannelList: TRESTResponseDataSetAdapter
    Active = True
    Dataset = DreamFDMemTableChannelList
    FieldDefs = <>
    Response = DreamRESTResponseChannelList
    OnBeforeOpenDataSet = DreamRESTResponseDataSetAdapterChannelListBeforeOpenDataSet
    RootElement = 'services'
    Left = 128
    Top = 224
  end
  object DreamHTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'root'
    Password = 'tsukubakek'
    Left = 320
    Top = 24
  end
  object DreamFDMemTableChannelList: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'servicereference'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'servicename'
        DataType = ftString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 336
    Top = 224
  end
end
