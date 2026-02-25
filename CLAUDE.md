# KassenBlick
## BucketArray.inc

- **Be super careful not to mess up the operation of these pie graphs. They were hard to get working. **
- Currently, a negative net gain causes the pie to turn a dark red. Change this pie to be a black (keeping the interest rate circles intact at all time. They work fine) with a negative net progress (Current Balance > Baseline), with a bright red (same as a positive pie (CUA) color showing the delta.
- Change the following Calc script to also save the .ods file. 
	Sub ExportTwoSheetsToCsv()
    Dim sFolder As String
    ' Note: LibreOffice prefers URL paths, but ConvertToURL handles the conversion for you.
    sFolder = "E:\Documents\Rainmeter\Skins\Kassenblick\Data\"
    
    ' 1. Export Buckets first
    ExportSheetToCsv("Buckets", sFolder & "Buckets.csv")
    
    ' 2. Export Bills second (leaving it as the active sheet)
    ExportSheetToCsv("Bills", sFolder & "Bills.csv")
    
    ' Silent Mode: No MsgBox here.
End Sub

Sub ExportSheetToCsv(sheetName As String, filePath As String)
    Dim oDoc As Object
    Dim oSheet As Object
    Dim sURL As String
    Dim args(2) As New com.sun.star.beans.PropertyValue
    
    oDoc = ThisComponent
    
    ' Check if the sheet exists
    If oDoc.Sheets.hasByName(sheetName) Then
        oSheet = oDoc.Sheets.getByName(sheetName)
        
        ' Set the sheet to be active (Required for CSV export)
        oDoc.CurrentController.setActiveSheet(oSheet)
        
        ' Prepare the file path URL
        sURL = ConvertToURL(filePath)
        
        ' Setup Export Arguments
        args(0).Name = "FilterName"
        args(0).Value = "Text - txt - csv (StarCalc)"
        
        ' Overwrite existing file without prompting
        args(1).Name = "Overwrite"
        args(1).Value = True
        
        ' Filter Options: Comma (44), Double Quote (34), UTF-8 (76)
        ' This ensures your Rainmeter skin reads symbols correctly
        args(2).Name = "FilterOptions"
        args(2).Value = "44,34,76"
        
        ' Export the active sheet
        oDoc.storeToURL(sURL, args())
    End If
End Sub