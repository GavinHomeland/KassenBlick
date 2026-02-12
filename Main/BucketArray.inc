; ====================
; BucketArray.inc
; Debt Bucket Pie Display
; 1x3 Pie Chart Array
; ====================

; ====================
; PIE 1
; ====================
[MeterPie_1]
Hidden=0
Meter=Shape
X=#Pad#
Y=#BucketTopY#
W=100
H=100
Shape=Ellipse 50,50,1,1 | Fill Color 0,0,0,0 | StrokeWidth 0
DynamicVariables=1
ToolTipText=""
Group=BucketSlots

; ====================
; PIE 2
; ====================
[MeterPie_2]
Hidden=0
Meter=Shape
X=(#Pad# + ((#ContentWidth#) / 3))
Y=#BucketTopY#
W=100
H=100
Shape=Ellipse 50,50,1,1 | Fill Color 0,0,0,0 | StrokeWidth 0
DynamicVariables=1
ToolTipText=""
Group=BucketSlots

; ====================
; PIE 3
; ====================
[MeterPie_3]
Meter=Shape
X=(#Pad# + ((#ContentWidth#) * 2 / 3))
Y=#BucketTopY#
W=100
H=100
Shape=Ellipse 50,50,1,1 | Fill Color 0,0,0,0 | StrokeWidth 0
DynamicVariables=1
ToolTipText=""
Group=BucketSlots

; ====================
; BUCKET LABELS
; ====================
[MeterBucketLabel_1]
Meter=String
X=(#Pad# + 50)
Y=#BucketLabelY#
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
StringAlign=Center
Text=""
Group=BucketSlots

[MeterBucketLabel_2]
Meter=String
X=(#Pad# + ((#ContentWidth#) / 3) + 50)
Y=#BucketLabelY#
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
StringAlign=Center
Text=""
Group=BucketSlots

[MeterBucketLabel_3]
Meter=String
X=(#Pad# + ((#ContentWidth#) * 2 / 3) + 50)
Y=#BucketLabelY#
FontFace=JetBrains Mono
FontSize=12
FontColor=200,200,200,255
AntiAlias=1
StringAlign=Center
Text=""
Group=BucketSlots
