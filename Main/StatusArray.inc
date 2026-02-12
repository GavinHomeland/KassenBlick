; ====================
; StatusArray.inc
; KassenBlick Bill Status Grid - 5 Rows x 5 Columns (25 slots)
;
; Layout per row:  [Dot][ID] [Dot][ID] [Dot][ID] [Dot][ID] [Dot][ID]
;
; The Lua script dynamically sets Shape fill/stroke colors and ID text.
; Initial state: all dots black, all IDs "---"
; ====================

; ====================
; ROW 1
; ====================
[MeterDot_R1_C1]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col1X#
Y=(#GridTopY# + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R1_C1]
Meter=String
X=(#Col1X# + #DotToTextGap#)
Y=#GridTopY#
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R1_C2]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col2X#
Y=(#GridTopY# + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R1_C2]
Meter=String
X=(#Col2X# + #DotToTextGap#)
Y=#GridTopY#
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R1_C3]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col3X#
Y=(#GridTopY# + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R1_C3]
Meter=String
X=(#Col3X# + #DotToTextGap#)
Y=#GridTopY#
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R1_C4]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col4X#
Y=(#GridTopY# + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R1_C4]
Meter=String
X=(#Col4X# + #DotToTextGap#)
Y=#GridTopY#
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R1_C5]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col5X#
Y=(#GridTopY# + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R1_C5]
Meter=String
X=(#Col5X# + #DotToTextGap#)
Y=#GridTopY#
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

; ====================
; ROW 2
; ====================
[MeterDot_R2_C1]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col1X#
Y=(#GridTopY# + #RowHeight# + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R2_C1]
Meter=String
X=(#Col1X# + #DotToTextGap#)
Y=(#GridTopY# + #RowHeight#)
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R2_C2]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col2X#
Y=(#GridTopY# + #RowHeight# + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R2_C2]
Meter=String
X=(#Col2X# + #DotToTextGap#)
Y=(#GridTopY# + #RowHeight#)
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R2_C3]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col3X#
Y=(#GridTopY# + #RowHeight# + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R2_C3]
Meter=String
X=(#Col3X# + #DotToTextGap#)
Y=(#GridTopY# + #RowHeight#)
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R2_C4]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col4X#
Y=(#GridTopY# + #RowHeight# + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R2_C4]
Meter=String
X=(#Col4X# + #DotToTextGap#)
Y=(#GridTopY# + #RowHeight#)
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R2_C5]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col5X#
Y=(#GridTopY# + #RowHeight# + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R2_C5]
Meter=String
X=(#Col5X# + #DotToTextGap#)
Y=(#GridTopY# + #RowHeight#)
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

; ====================
; ROW 3
; ====================
[MeterDot_R3_C1]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col1X#
Y=(#GridTopY# + (#RowHeight# * 2) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R3_C1]
Meter=String
X=(#Col1X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 2))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R3_C2]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col2X#
Y=(#GridTopY# + (#RowHeight# * 2) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R3_C2]
Meter=String
X=(#Col2X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 2))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R3_C3]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col3X#
Y=(#GridTopY# + (#RowHeight# * 2) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R3_C3]
Meter=String
X=(#Col3X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 2))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R3_C4]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col4X#
Y=(#GridTopY# + (#RowHeight# * 2) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R3_C4]
Meter=String
X=(#Col4X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 2))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R3_C5]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col5X#
Y=(#GridTopY# + (#RowHeight# * 2) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R3_C5]
Meter=String
X=(#Col5X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 2))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

; ====================
; ROW 4
; ====================
[MeterDot_R4_C1]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col1X#
Y=(#GridTopY# + (#RowHeight# * 3) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R4_C1]
Meter=String
X=(#Col1X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 3))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R4_C2]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col2X#
Y=(#GridTopY# + (#RowHeight# * 3) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R4_C2]
Meter=String
X=(#Col2X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 3))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R4_C3]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col3X#
Y=(#GridTopY# + (#RowHeight# * 3) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R4_C3]
Meter=String
X=(#Col3X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 3))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R4_C4]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col4X#
Y=(#GridTopY# + (#RowHeight# * 3) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R4_C4]
Meter=String
X=(#Col4X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 3))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R4_C5]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col5X#
Y=(#GridTopY# + (#RowHeight# * 3) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R4_C5]
Meter=String
X=(#Col5X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 3))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

; ====================
; ROW 5
; ====================
[MeterDot_R5_C1]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col1X#
Y=(#GridTopY# + (#RowHeight# * 4) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R5_C1]
Meter=String
X=(#Col1X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 4))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R5_C2]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col2X#
Y=(#GridTopY# + (#RowHeight# * 4) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R5_C2]
Meter=String
X=(#Col2X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 4))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R5_C3]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col3X#
Y=(#GridTopY# + (#RowHeight# * 4) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R5_C3]
Meter=String
X=(#Col3X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 4))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R5_C4]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col4X#
Y=(#GridTopY# + (#RowHeight# * 4) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R5_C4]
Meter=String
X=(#Col4X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 4))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R5_C5]
Meter=Shape
Shape=Ellipse 6,6,6,6 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col5X#
Y=(#GridTopY# + (#RowHeight# * 4) + #DotOffsetY#)
ToolTipText=""
Group=BillSlots

[MeterID_R5_C5]
Meter=String
X=(#Col5X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 4))
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots
