; ==============================================================================
; StatusArray.inc
; KassenBlick Bill Status Grid — 5 Rows x 3 Columns (15 slots)
;
; Layout per row:  [Dot][ID]  ···spacing···  [Dot][ID]  ···spacing···  [Dot][ID]
;
; Grid Geometry (pad-to-pad):
;   SkinWidth = 250, Pad = 10 → Usable width = 230
;   3 columns, each column = ~77px
;   Dot = 10px wide, gap after dot = 2px, ID text ≈ 25px, intercolumn gap ≈ 40px
;
; The Lua script dynamically sets Shape fill/stroke colors and ID text.
; Initial state: all dots black, all IDs "---"
; ==============================================================================

; --- Grid positioning uses variables defined in KassenBlick.ini [Variables] ---

; ==============================================================================
; ROW 1
; ==============================================================================
[MeterDot_R1_C1]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col1X#
Y=#GridTopY#
ToolTipText=""
Group=BillSlots

[MeterID_R1_C1]
Meter=String
X=(#Col1X# + #DotToTextGap#)
Y=#GridTopY#
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R1_C2]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col2X#
Y=#GridTopY#
ToolTipText=""
Group=BillSlots

[MeterID_R1_C2]
Meter=String
X=(#Col2X# + #DotToTextGap#)
Y=#GridTopY#
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R1_C3]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col3X#
Y=#GridTopY#
ToolTipText=""
Group=BillSlots

[MeterID_R1_C3]
Meter=String
X=(#Col3X# + #DotToTextGap#)
Y=#GridTopY#
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

; ==============================================================================
; ROW 2
; ==============================================================================
[MeterDot_R2_C1]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col1X#
Y=(#GridTopY# + #RowHeight#)
ToolTipText=""
Group=BillSlots

[MeterID_R2_C1]
Meter=String
X=(#Col1X# + #DotToTextGap#)
Y=(#GridTopY# + #RowHeight#)
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R2_C2]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col2X#
Y=(#GridTopY# + #RowHeight#)
ToolTipText=""
Group=BillSlots

[MeterID_R2_C2]
Meter=String
X=(#Col2X# + #DotToTextGap#)
Y=(#GridTopY# + #RowHeight#)
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R2_C3]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col3X#
Y=(#GridTopY# + #RowHeight#)
ToolTipText=""
Group=BillSlots

[MeterID_R2_C3]
Meter=String
X=(#Col3X# + #DotToTextGap#)
Y=(#GridTopY# + #RowHeight#)
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

; ==============================================================================
; ROW 3
; ==============================================================================
[MeterDot_R3_C1]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col1X#
Y=(#GridTopY# + (#RowHeight# * 2))
ToolTipText=""
Group=BillSlots

[MeterID_R3_C1]
Meter=String
X=(#Col1X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 2))
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R3_C2]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col2X#
Y=(#GridTopY# + (#RowHeight# * 2))
ToolTipText=""
Group=BillSlots

[MeterID_R3_C2]
Meter=String
X=(#Col2X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 2))
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R3_C3]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col3X#
Y=(#GridTopY# + (#RowHeight# * 2))
ToolTipText=""
Group=BillSlots

[MeterID_R3_C3]
Meter=String
X=(#Col3X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 2))
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

; ==============================================================================
; ROW 4
; ==============================================================================
[MeterDot_R4_C1]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col1X#
Y=(#GridTopY# + (#RowHeight# * 3))
ToolTipText=""
Group=BillSlots

[MeterID_R4_C1]
Meter=String
X=(#Col1X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 3))
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R4_C2]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col2X#
Y=(#GridTopY# + (#RowHeight# * 3))
ToolTipText=""
Group=BillSlots

[MeterID_R4_C2]
Meter=String
X=(#Col2X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 3))
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R4_C3]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col3X#
Y=(#GridTopY# + (#RowHeight# * 3))
ToolTipText=""
Group=BillSlots

[MeterID_R4_C3]
Meter=String
X=(#Col3X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 3))
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

; ==============================================================================
; ROW 5
; ==============================================================================
[MeterDot_R5_C1]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col1X#
Y=(#GridTopY# + (#RowHeight# * 4))
ToolTipText=""
Group=BillSlots

[MeterID_R5_C1]
Meter=String
X=(#Col1X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 4))
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R5_C2]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col2X#
Y=(#GridTopY# + (#RowHeight# * 4))
ToolTipText=""
Group=BillSlots

[MeterID_R5_C2]
Meter=String
X=(#Col2X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 4))
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots

[MeterDot_R5_C3]
Meter=Shape
Shape=Ellipse 5,5,5,5 | Fill Color 0,0,0,255 | StrokeWidth 1 | Stroke Color 255,255,255,255
X=#Col3X#
Y=(#GridTopY# + (#RowHeight# * 4))
ToolTipText=""
Group=BillSlots

[MeterID_R5_C3]
Meter=String
X=(#Col3X# + #DotToTextGap#)
Y=(#GridTopY# + (#RowHeight# * 4))
FontFace=JetBrains Mono
FontSize=9
FontColor=200,200,200,255
AntiAlias=1
Text="---"
ToolTipText=""
Group=BillSlots
