Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Hides PowerShell Console on Creation if called.
Function Hide-PSWindow {
    Add-Type -Name Window -Namespace Console -MemberDefinition '
    [DllImport("Kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
    '
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0)
}

#This will create form boxes where a target user can enter input in a UI-Box.
Function Create-FormBox {
    Param([String]$Title,[String]$Message)
    [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    return [Microsoft.VisualBasic.Interaction]::InputBox($Message, $Title)
}

#This will create a message box that relays information to the user in a friendly manner.
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

#This will take an array and allow its items to be selected; the size of the boxes are customizable.
Function Create-SelectionBox {
    param(
        [Parameter(Mandatory=$true)][String]$Message,
        [Parameter(Mandatory=$true)][String]$Title,
        [Parameter(Mandatory=$true)][Object[]]$Content,
        [Parameter(Mandatory=$false)][Int32]$FormWidth=300,
        [Parameter(Mandatory=$false)][Int32]$FormLength=200,
        [Parameter(Mandatory=$false)][Int32]$BoxWidth=260,
        [Parameter(Mandatory=$false)][Int32]$BoxLength=40,
        [Parameter(Mandatory=$false)][Int32]$LabelX=10,
        [Parameter(Mandatory=$false)][Int32]$LabelY=20
    )

    $BoxMidpoint = $BoxWidth / 2
    $LowerMid =  (0 + $BoxMidpoint)/2 
    $UpperMid = ($BoxWidth + $BoxMidpoint)/2

    $LowerLowerMid = (0 + $LowerMid) / 2
    $LowerUpperMid = ($LowerMid + $BoxMidpoint) / 2
    
    $UpperLowerMid = ($BoxMidpoint + $UpperMid) / 2

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size($FormWidth,$FormLength)
    $form.StartPosition = 'CenterScreen'

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point($LowerMid,120)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = 'OK'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point($UpperMid,120)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = 'Cancel'
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point($LabelX,$LabelY)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = $Message
    $form.Controls.Add($label)

    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(10,40)
    $listBox.Size = New-Object System.Drawing.Size($BoxWidth,$BoxLength)
    $listBox.Height = 80

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
    <#Output mode can be None, Single, or Multiple.#>
    param(
        [Parameter(Mandatory=$true)][Object[]]$Content,
        [Parameter(Mandatory=$false)][String]$Title="No Title Entered!",
        [Parameter(Mandatory=$false)][String]$OutputMode="Single"
    )
    return ($Content | Out-GridView -Title $Title -OutputMode $OutputMode)
}
