#! You can run this on all windows machines [os=windows]
#! /usr/bin/ps1

[Environment]::OSVersion

$process = Start-Process -FilePath C:\Python27\Scripts\cloudrunner-node.exe -ArgumentList details -NoNewWindow -PassThru -Wait
$process.ExitCode
