; ====================
; SavingsArray.inc
; Savings Goal Square Display — 3 slots
;
; Each square:
;   Shape  = grey outline (full height = baseline / savings goal)
;   Shape2 = green fill from bottom up (current savings)
;
; Square height is proportional to Baseline at 10x the d-bucket px-per-dollar
; scale. Lua sets H, Y, Shape, Shape2, label Y, and tooltip dynamically.
; Squares are bottom-justified: all share the same bottom edge.
; ====================

; ====================
; SAVE 1
; ====================
[MeterSave_1]
Meter=Shape
X=#Pad#
Y=#SaveTopY#
W=100
H=80
Shape=Rectangle 0,0,100,80 | Fill Color 40,40,50,200 | StrokeWidth 1 | Stroke Color 17,228,17,255
DynamicVariables=1
ToolTipText=""
Group=SaveSlots

; ====================
; SAVE 2
; ====================
[MeterSave_2]
Meter=Shape
X=(#Pad# + (#ContentWidth# / 3))
Y=#SaveTopY#
W=100
H=80
Shape=Rectangle 0,0,100,80 | Fill Color 40,40,50,200 | StrokeWidth 1 | Stroke Color 190,190,190,255
DynamicVariables=1
ToolTipText=""
Group=SaveSlots

; ====================
; SAVE 3
; ====================
[MeterSave_3]
Meter=Shape
X=(#Pad# + (#ContentWidth# * 2 / 3))
Y=#SaveTopY#
W=100
H=80
Shape=Rectangle 0,0,100,80 | Fill Color 40,40,50,200 | StrokeWidth 1 | Stroke Color 190,190,190,255
DynamicVariables=1
ToolTipText=""
Group=SaveSlots

; ====================
; SAVINGS LABELS
; ====================
[MeterSaveLabel_1]
Meter=String
X=(#Pad# + 50)
Y=#SaveLabelY#
FontFace=#FontMono#
FontSize=12
FontColor=#ColorText#
AntiAlias=1
StringAlign=Center
Text=""
DynamicVariables=1
Group=SaveSlots

[MeterSaveLabel_2]
Meter=String
X=(#Pad# + (#ContentWidth# / 3) + 50)
Y=#SaveLabelY#
FontFace=#FontMono#
FontSize=12
FontColor=#ColorText#
AntiAlias=1
StringAlign=Center
Text=""
DynamicVariables=1
Group=SaveSlots

[MeterSaveLabel_3]
Meter=String
X=(#Pad# + (#ContentWidth# * 2 / 3) + 50)
Y=#SaveLabelY#
FontFace=#FontMono#
FontSize=12
FontColor=#ColorText#
AntiAlias=1
StringAlign=Center
Text=""
DynamicVariables=1
Group=SaveSlots
