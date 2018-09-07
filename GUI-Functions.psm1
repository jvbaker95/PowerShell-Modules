Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Function Create-FormBox {
    Param([String]$Title,[String]$Message)
    [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    return [Microsoft.VisualBasic.Interaction]::InputBox($Message, $Title)
}

Function Create-MessageBox {
    param(
        [Parameter(Mandatory=$true)][Object]$Message,
        [Parameter(Mandatory=$true)][Object]$Title,
        [Parameter(Mandatory=$false)][Object]$ButtonOptions="OK",
        [Parameter(Mandatory=$false)][Object]$Icon="None"
    )
    <#
    ButtonOptions
        OK,OKCancel,AbortRetryIgnore,YesNoCancel,RetryCancel
    #>
    <#
    Icon
        None,Hand,Error,Stop,Question,Exclamation,Warning,Asterisk,Information
    #>
    
    Return [System.Windows.Forms.MessageBox]::Show($Message,$Title,$ButtonOptions,$Icon)
}

Function Create-SelectionBox {
    param(
        [Parameter(Mandatory=$true)][String]$Message,
        [Parameter(Mandatory=$true)][String]$Title,
        [Parameter(Mandatory=$true)][Object[]]$Content,
        [Parameter(Mandatory=$false)][Int32]$boxHeight=80
    )

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = 'CenterScreen'

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(75,120)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = 'OK'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(150,120)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = 'Cancel'
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = $Message
    $form.Controls.Add($label)

    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(10,40)
    $listBox.Size = New-Object System.Drawing.Size(260,20)
    $listBox.Height = $boxHeight

    #Add the list of items passed in via the arguments.
    foreach ($item in $content) {
        [Void] $listBox.Items.Add($item)
    }

    $form.Controls.Add($listBox)

    $form.Topmost = $true

    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $ListBox.SelectedItem
    }
    else {
        return "CANCELED"
    }
}
Function Create-Grid {
    param(
        [Parameter(Mandatory=$true)][Object]$Content,
        [Parameter(Mandatory=$false)][String]$Title="No Title Entered!"
    )
    return Out-GridView -InputObject $Content -Title $Title
}
