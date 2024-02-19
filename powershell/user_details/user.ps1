
$currentUser = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
[System.Environment]::SetEnvironmentVariable("CW_LOG_USERNAME", $currentUser, [System.EnvironmentVariableTarget]::Machine)