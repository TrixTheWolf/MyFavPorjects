Sub CreateSentimentCharts()

    Dim ws As Worksheet
    Dim lastRow As Long
    Dim i As Long
    Dim cht As ChartObject
    Dim chartTitle As String
    Dim posVal As Double, neuVal As Double, negVal As Double
    Dim chartLeft As Double, chartTop As Double
    Dim chartWidth As Double, chartHeight As Double
    Dim colInRow As Long
    Dim currentGame As String
    Dim prevGame As String
    Dim rowGroup As Long

    Set ws = ThisWorkbook.Sheets("By Game & Team")

    ' Chart dimensions
    chartWidth = 250
    chartHeight = 200

    ' Gap between groups (~10 rows worth of space)
    Dim groupGap As Double
    groupGap = chartHeight + 150

    ' Starting position: Column K, Row 1
    Dim startLeft As Double
    Dim startTop As Double
    startLeft = ws.Columns("K").Left
    startTop = ws.Rows(1).Top

    ' Find last row with data
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row

    ' Delete existing charts first
    Dim co As ChartObject
    For Each co In ws.ChartObjects
        co.Delete
    Next co

    ' Tracking variables
    colInRow = 0
    rowGroup = 0
    prevGame = ""

    ' Loop through each data row (skip header row 1)
    For i = 2 To lastRow

        posVal = ws.Cells(i, 3).Value
        neuVal = ws.Cells(i, 4).Value
        negVal = ws.Cells(i, 5).Value

        chartTitle = ws.Cells(i, 1).Value & " - " & ws.Cells(i, 2).Value
        currentGame = ws.Cells(i, 1).Value

        ' If game name changed, start a new row
        If currentGame <> prevGame And prevGame <> "" Then
            rowGroup = rowGroup + 1
            colInRow = 0
        End If

        chartLeft = startLeft + colInRow * (chartWidth + 10)
        chartTop = startTop + rowGroup * groupGap

        Set cht = ws.ChartObjects.Add(chartLeft, chartTop, chartWidth, chartHeight)

        With cht.Chart
            .ChartType = xlPie

            .SeriesCollection.NewSeries
            With .SeriesCollection(1)
                .Values = Array(posVal, neuVal, negVal)
                .XValues = Array("Positive", "Neutral", "Negative")
                .Name = "Sentiment"

                .Points(1).Format.Fill.ForeColor.RGB = RGB(0, 176, 80)
                .Points(2).Format.Fill.ForeColor.RGB = RGB(255, 217, 0)
                .Points(3).Format.Fill.ForeColor.RGB = RGB(255, 0, 0)
            End With

            .HasTitle = True
            .ChartTitle.Text = chartTitle
            .ChartTitle.Font.Size = 9
            .ChartTitle.Font.Bold = True

            .SeriesCollection(1).ApplyDataLabels
            With .SeriesCollection(1).DataLabels
                .ShowPercentage = True
                .ShowValue = False
                .ShowCategoryName = False
                .Font.Size = 8
                .Font.Bold = True
                .Font.Color = RGB(255, 255, 255)
            End With

            .HasLegend = True
            .Legend.Position = xlLegendPositionRight
            .Legend.Font.Size = 8

            .PlotArea.Format.Fill.Visible = msoFalse
            .PlotArea.Format.Line.Visible = msoFalse
            .ChartArea.Format.Fill.Visible = msoFalse
            .ChartArea.Format.Line.Visible = msoFalse

        End With

        ' Move to next column, track current game
        colInRow = colInRow + 1
        prevGame = currentGame

    Next i

    MsgBox "Done! Created " & (lastRow - 1) & " charts.", vbInformation

End Sub
