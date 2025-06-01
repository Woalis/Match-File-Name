Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Match File Name PS"
$form.Size = New-Object System.Drawing.Size(500, 360)
$form.StartPosition = "CenterScreen"

# Labels
$labelSource = New-Object System.Windows.Forms.Label
$labelSource.Text = "Source File:"
$labelSource.Location = New-Object System.Drawing.Point(10, 20)
$labelSource.Size = New-Object System.Drawing.Size(80, 20)

$labelTarget = New-Object System.Windows.Forms.Label
$labelTarget.Text = "Target File:"
$labelTarget.Location = New-Object System.Drawing.Point(10, 60)
$labelTarget.Size = New-Object System.Drawing.Size(80, 20)

$labelPrefix = New-Object System.Windows.Forms.Label
$labelPrefix.Text = "Prefix:"
$labelPrefix.Location = New-Object System.Drawing.Point(10, 100)
$labelPrefix.Size = New-Object System.Drawing.Size(80, 20)

$labelSuffix = New-Object System.Windows.Forms.Label
$labelSuffix.Text = "Suffix:"
$labelSuffix.Location = New-Object System.Drawing.Point(10, 140)
$labelSuffix.Size = New-Object System.Drawing.Size(80, 20)

# Textboxes
$textBoxSource = New-Object System.Windows.Forms.TextBox
$textBoxSource.Location = New-Object System.Drawing.Point(100, 20)
$textBoxSource.Size = New-Object System.Drawing.Size(360, 20)
$textBoxSource.AllowDrop = $true

$textBoxTarget = New-Object System.Windows.Forms.TextBox
$textBoxTarget.Location = New-Object System.Drawing.Point(100, 60)
$textBoxTarget.Size = New-Object System.Drawing.Size(360, 20)
$textBoxTarget.AllowDrop = $true

$textBoxPrefix = New-Object System.Windows.Forms.TextBox
$textBoxPrefix.Location = New-Object System.Drawing.Point(100, 100)
$textBoxPrefix.Size = New-Object System.Drawing.Size(360, 20)

$textBoxSuffix = New-Object System.Windows.Forms.TextBox
$textBoxSuffix.Location = New-Object System.Drawing.Point(100, 140)
$textBoxSuffix.Size = New-Object System.Drawing.Size(360, 20)

# Handle file drops
$textBoxSource.Add_DragEnter({ $_.Effect = 'Copy' })
$textBoxSource.Add_DragDrop({
    $file = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    $textBoxSource.Text = $file[0]
})

$textBoxTarget.Add_DragEnter({ $_.Effect = 'Copy' })
$textBoxTarget.Add_DragDrop({
    $file = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    $textBoxTarget.Text = $file[0]
})

# Run Button
$buttonRun = New-Object System.Windows.Forms.Button
$buttonRun.Text = "Run"
$buttonRun.Location = New-Object System.Drawing.Point(100, 190)
$buttonRun.Size = New-Object System.Drawing.Size(80, 30)
$buttonRun.Add_Click({
    $source = $textBoxSource.Text
    $target = $textBoxTarget.Text
    $prefix = $textBoxPrefix.Text
    $suffix = $textBoxSuffix.Text

    if (-not (Test-Path $source) -or -not (Test-Path $target)) {
        [System.Windows.Forms.MessageBox]::Show("Please make sure both files are selected.")
        return
    }

    $sourceDir = [System.IO.Path]::GetDirectoryName($source)
    $sourceBase = [System.IO.Path]::GetFileNameWithoutExtension($source)
    $sourceExt = [System.IO.Path]::GetExtension($source)
    $targetDir = [System.IO.Path]::GetDirectoryName($target)
    $targetExt = [System.IO.Path]::GetExtension($target)

    $newBaseName = "$prefix$sourceBase$suffix"

    # Rename Source File
    $newSourceName = "$sourceDir\$newBaseName$sourceExt"
    if ($newSourceName -ne $source) {
        Rename-Item -Path $source -NewName "$newBaseName$sourceExt" -Force
        $source = $newSourceName
    }

    # Rename Target File
    $newTargetName = "$targetDir\$newBaseName$targetExt"
    Rename-Item -Path $target -NewName "$newBaseName$targetExt" -Force

    # Copy modified date
    $modDate = (Get-Item $source).LastWriteTime
    (Get-Item $newTargetName).LastWriteTime = $modDate

    [System.Windows.Forms.MessageBox]::Show("Files renamed and target modified date updated.")
})

# Clear Button
$buttonClear = New-Object System.Windows.Forms.Button
$buttonClear.Text = "Clear"
$buttonClear.Location = New-Object System.Drawing.Point(200, 190)
$buttonClear.Size = New-Object System.Drawing.Size(80, 30)
$buttonClear.Add_Click({
    $textBoxSource.Text = ""
    $textBoxTarget.Text = ""
    $textBoxPrefix.Text = ""
    $textBoxSuffix.Text = ""
})

# Add controls to form
$form.Controls.AddRange(@(
    $labelSource, $labelTarget, $labelPrefix, $labelSuffix,
    $textBoxSource, $textBoxTarget, $textBoxPrefix, $textBoxSuffix,
    $buttonRun, $buttonClear
))

# Show form
[void]$form.ShowDialog()
