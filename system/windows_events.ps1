. "$PSScriptRoot/system/windows_info.ps1"

function Get-WindowsEventLogs {
    $logTypes = @("Application", "System", "Security", "Setup", "ForwardedEvents")
    $eventData = @()
    foreach ($logType in $logTypes) {
        $logs = Get-WinEvent -LogName $logType -ErrorAction SilentlyContinue | ForEach-Object {
            [PSCustomObject]@{
                TimeCreated = $_.TimeCreated
                Message     = $_.Message
                Category    = $_.LogName
                LogType     = $logType
            }
        }
        $eventData += $logs
    }

    $systemCrashLogs = Get-WinEvent -FilterHashtable @{
        LogName      = 'System'
        ProviderName = 'Microsoft-Windows-WER-SystemErrorReporting'
    } -ErrorAction SilentlyContinue | ForEach-Object {
        [PSCustomObject]@{
            TimeCreated = $_.TimeCreated
            Message     = $_.Message
            Category    = $_.LogName
            LogType     = 'SystemCrash'
        }
    }

    return $eventData, $systemCrashLogs
}