object HanilnPortFowarding_Service: THanilnPortFowarding_Service
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  DisplayName = 'HanilnPortFowarding_Service'
  OnContinue = ServiceContinue
  OnPause = ServicePause
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
  object CryptographicLibrary1: TCryptographicLibrary
    Left = 22
    Top = 22
  end
  object Codec1: TCodec
    AsymetricKeySizeInBits = 1024
    AdvancedOptions2 = []
    CryptoLibrary = CryptographicLibrary1
    Left = 77
    Top = 22
    StreamCipherId = 'native.StreamToBlock'
    BlockCipherId = 'native.AES-256'
    ChainId = 'native.CBC'
  end
end
