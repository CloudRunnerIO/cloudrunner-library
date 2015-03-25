#! switch [os=windows]
#! /usr/bin/ps1

[Environment]::OSVersion

$process = Start-Process -FilePath C:\Python27\Scripts\cloudrunner-node.exe -ArgumentList details -NoNewWindow -PassThru -Wait
$process.ExitCode
