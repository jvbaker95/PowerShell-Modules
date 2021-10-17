<#
This function is derived from Prof. PowerShell, found at 
"https://mcpmag.com/articles/2014/02/18/progress-bar-to-a-graphical-status-box.aspx".
#>
#requires -version 3.0
#The important methods are .Show(), .Focus(), and .Refres().
Function Create-ProgressBar {
    param(
        [Parameter(Mandatory=$False)][String]$Title="No Title Entered.",
        [Parameter(Mandatory=$False)][String]$Label="No Label Entered.",
        [Parameter(Mandatory=$False)][Int32]$WinFormWidth=400,
        [Parameter(Mandatory=$False)][Int32]$WinFormHeight=100
    )
    #demo winform status box with a progress bar control

    Add-Type -Assembly System.Windows.Forms

    #title for the winform

    #winform dimensions
    $height=100
    $width=400
    #winform background color
    $color = "White"

    #create the form
    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = $Title
    $Form.Height = $WinFormHeight
    $Form.Width = $WinFormWidth
    $Form.BackColor = $color

    $Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    #display center screen
    $Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    # create label
    $label1 = New-Object system.Windows.Forms.Label
    $label1.Name = "label1"
    $label1.Text = "Not Started"
    $label1.Left=5
    $label1.Top= 10
    $label1.Width= $width - 20
    #adjusted height to accommodate progress bar
    $label1.Height=15
    $label1.Font= "Verdana"
    #optional to show border
    #$label1.BorderStyle=1

    #add the label to the form
    $Form.controls.add($label1)

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Name = 'progressBar'
    $progressBar.Value = 0
    $progressBar.Style="Continuous"

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = $width - 40
    $System_Drawing_Size.Height = 20
    $progressBar.Size = $System_Drawing_Size

    $progressBar.Left = 5
    $progressBar.Top = 40
    
    #Add the Progress Bar to the form.
    $Form.Controls.Add($progressBar)

    #Return the Progress Bar without doing anything.
    Return $Form
}

#This is vestigial code to show how the progress bar works.
<#
Function Start-ProgressBar {
    Param(
        [Parameter(Mandatory=$True)][System.Windows.Forms.Form]$ProgressBar,
        [Parameter(Mandatory=$True)][Int]$Incrementor,
        [Parameter(Mandatory=$False)][String]$LabelText='[String]""'
    ) 
    $ProgressBar.Show() | Out-Null
    $ProgressBar.Focus() | Out-Null 
    for ($i = 0; $i -lt 100; $i++) {
        $ProgressBar.Controls['progressBar'].Value += $Incrementor
        $ProgressBar.Controls['label1'].Text = Invoke-Expression $LabelText
        $ProgressBar.Refresh()
    }
}
#>

