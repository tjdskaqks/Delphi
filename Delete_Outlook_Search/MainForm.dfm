object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biHelp]
  BorderStyle = bsSingle
  Caption = #50500#50883#47337' '#44160#49353' '#44592#47197' '#49325#51228
  ClientHeight = 95
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object lbl1: TLabel
    Left = 46
    Top = 16
    Width = 72
    Height = 16
    Caption = #48376#51064' '#44228#51221':'
  end
  object lbl2: TLabel
    Left = 16
    Top = 48
    Width = 164
    Height = 32
    Caption = #49325#51228#47484' '#49457#44277#54616#47732' '#13#10#50500#50883#47337#51012' '#51116#49884#51089#54616#49464#50836
  end
  object edt1: TEdit
    Left = 163
    Top = 13
    Width = 121
    Height = 24
    Alignment = taCenter
    TabOrder = 0
    TextHint = 'ex) Jeon'
  end
  object btn1: TButton
    Left = 198
    Top = 52
    Width = 86
    Height = 25
    Caption = #49325#51228#54616#44592
    TabOrder = 1
    OnClick = btn1Click
  end
end
