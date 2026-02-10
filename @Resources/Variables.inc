[Variables]
; --- Metadata ---
SkinVersion=1.0.0
Version=1

; --- Dimensions ---
W=460
H=500
Pad=16
Round=4

; --- Colors ---
ColorText=255,255,255,220
ColorAccent=255,215,0,255
ColorBg=0,0,0,255
ColorBorder=35,35,35,255
ColorMuted=120,120,120,180
ColorNeg=255,100,100,255
ColorPos=100,255,100,255

; --- File Locations ---
DataFile=#SKINSPATH#Kassenblick\Data\FinanceData.csv

; --- Global Styles ---
[StyleText]
FontFace=Segoe UI
FontSize=11
FontColor=#ColorText#
AntiAlias=1
; Added this to ensure all text meters can handle potential inline changes
DynamicVariables=1
UpdateDivider=-1

[StyleLabel]
FontFace=Segoe UI
FontSize=9
FontColor=#ColorMuted#
StringStyle=Bold
AntiAlias=1
UpdateDivider=-1

[StyleValue]
FontFace=Consolas
FontSize=12
FontColor=#ColorText#
AntiAlias=1
UpdateDivider=-1

; --- Financial Formatting ---
; These help keep your logic consistent across meters
FormatCurrency=[\x0024]