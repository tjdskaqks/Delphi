object TMSForm2: TTMSForm2
  Left = 250
  Top = 200
  AlphaBlend = True
  Caption = 'Windows Tail'
  ClientHeight = 341
  ClientWidth = 849
  Color = clWindow
  Constraints.MinHeight = 26
  Constraints.MinWidth = 100
  Ctl3D = False
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnCreate = AdvMetroFormCreate
  OnDestroy = AdvMetroFormDestroy
  Appearance.SystemIconColorDisabled = 5921370
  Appearance.ShowAppIcon = False
  Appearance.SizeGripColor = 3355443
  Appearance.CaptionFont.Charset = DEFAULT_CHARSET
  Appearance.CaptionFont.Color = clWhite
  Appearance.CaptionFont.Height = -20
  Appearance.CaptionFont.Name = 'AppleSDGothicNeoSB00'
  Appearance.CaptionFont.Style = [fsBold]
  Appearance.CaptionColor = 11691520
  Appearance.CaptionStyle = csPlain
  Appearance.CaptionActiveColor = 3355443
  Appearance.Font.Charset = DEFAULT_CHARSET
  Appearance.Font.Color = clWhite
  Appearance.Font.Height = -11
  Appearance.Font.Name = 'Segoe UI'
  Appearance.Font.Style = []
  Appearance.TextAlign = taCenter
  Appearance.TextColor = clBlack
  SizeGrip = True
  PixelsPerInch = 96
  TextHeight = 20
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 849
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    Color = 3394815
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      849
      64)
    object edt_1: TAdvFileNameEdit
      Left = 117
      Top = 20
      Width = 478
      Height = 26
      BorderColor = 3355443
      EmptyText = #54028#51068' '#44221#47196#47484' '#51077#47141#54616#49464#50836'.'
      EmptyTextStyle = []
      FocusBorder = True
      FocusLabel = True
      LabelCaption = #52628#52377#54624' '#54028#51068' '#44221#47196
      LabelPosition = lpLeftCenter
      LabelMargin = 6
      LabelAlwaysEnabled = True
      LabelFont.Charset = HANGEUL_CHARSET
      LabelFont.Color = 3355443
      LabelFont.Height = -13
      LabelFont.Name = #47569#51008' '#44256#46357
      LabelFont.Style = []
      Lookup.Enabled = True
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Arial'
      Lookup.Font.Style = []
      Lookup.NumChars = 1
      Lookup.Separator = ';'
      Anchors = [akLeft, akTop, akRight]
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      ShortCut = 0
      TabOrder = 0
      Visible = True
      Version = '1.5.2.0'
      ButtonStyle = bsButton
      ButtonWidth = 18
      Flat = False
      Etched = False
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A6000020400000206000002080000020A0000020C0000020E000004000000040
        20000040400000406000004080000040A0000040C0000040E000006000000060
        20000060400000606000006080000060A0000060C0000060E000008000000080
        20000080400000806000008080000080A0000080C0000080E00000A0000000A0
        200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
        200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
        200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
        20004000400040006000400080004000A0004000C0004000E000402000004020
        20004020400040206000402080004020A0004020C0004020E000404000004040
        20004040400040406000404080004040A0004040C0004040E000406000004060
        20004060400040606000406080004060A0004060C0004060E000408000004080
        20004080400040806000408080004080A0004080C0004080E00040A0000040A0
        200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
        200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
        200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
        20008000400080006000800080008000A0008000C0008000E000802000008020
        20008020400080206000802080008020A0008020C0008020E000804000008040
        20008040400080406000804080008040A0008040C0008040E000806000008060
        20008060400080606000806080008060A0008060C0008060E000808000008080
        20008080400080806000808080008080A0008080C0008080E00080A0000080A0
        200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
        200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
        200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
        2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
        2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
        2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
        2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
        2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
        2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
        2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FDFDFDFDFDFD
        FDFDFDFDFDFDFDFDFDFDB7B76F67676767676767676767B7FDFD6FFDBFBFBFBF
        BFBFBFBFBFB7FD6FFDFD6FFDBFBFBFBFBF7F7F7F7777FD6FFDFD6FFDBFBFBFBF
        BFBFBFBF7F7FFD6FFDFD6FFDFDFDBFBFBFBFBFBFBF7FFD6FFDFD6FFDFDFDFD08
        070707B6B6B6096FE3EC6FFDB76F6FAFFDFDFDFDFDFDFD6FFDE36FFDBFBFBFED
        B76F6F6F6F6F6F6FFDE377FDBFBFBF09FD09FD09FDFDFDFDFDE377FDFDFDFD09
        FD09090909090909FDE377B7B7B7B709FD09FD09FDFDFDFDFDE3FDFDFDFDFD09
        FD09090909090909FDEBFDFDFDFDFD09FDFDFDFDFDFDFDFDFDEBFDFDFDFDFD09
        FDBDBDB5B4B4B4B4FDEBFDFDFDFDFDFD0909090909ECECECEC09}
      ReadOnly = False
      AutoFileLookup = True
      Filter = 'Text files (*.txt)|*.TXT|Log files (*.log)|*.log'
      FilterIndex = 0
      DialogOptions = [ofFileMustExist]
      DialogKind = fdOpen
    end
    object btn1: TAdvMetroButton
      Left = 684
      Top = 20
      Width = 73
      Height = 30
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Appearance.PictureColorHover = 16119285
      Caption = #49884#51089
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -15
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Version = '1.2.0.0'
      OnClick = btn1Click
    end
    object btn2: TAdvMetroButton
      Left = 763
      Top = 20
      Width = 73
      Height = 30
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Appearance.PictureColorHover = 16119285
      Caption = #51473#51648
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -15
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Version = '1.2.0.0'
      OnClick = btn2Click
    end
    object btn3: TAdvMetroButton
      Tag = 1
      Left = 605
      Top = 20
      Width = 73
      Height = 30
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Appearance.PictureColorHover = 16119285
      Caption = #50948#47196' '#48372#44592
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -15
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Version = '1.2.0.0'
      OnClick = btn3Click
    end
  end
  object mmo1: TMemo
    Left = 0
    Top = 64
    Width = 849
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsNone
    ScrollBars = ssBoth
    TabOrder = 1
    OnKeyUp = mmo1KeyUp
    OnMouseUp = mmo1MouseUp
  end
  object stsbr1: TsStatusBar
    Left = 0
    Top = 304
    Width = 849
    Height = 23
    Panels = <
      item
        Width = 50
      end>
    SimplePanel = True
    SimpleText = 'Ln : 1. Col : 1'
    SkinData.SkinSection = 'STATUSBAR'
  end
end
