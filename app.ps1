
. "$PSScriptRoot/system/windows_events.ps1"
. "$PSScriptRoot/util/cloudwatch.ps1"
. "$PSScriptRoot/dns/dns_logs.ps1"



$hostname = hostname
function Start-LogCollection {
    while ($true) {
        $eventData, $systemCrashLogs = Get-WindowsEventLogs
        $dnsLogs = Get-DNSLogs

        if ($eventData) {
            $logData = $eventData | Format-Table | Out-String
            Send-ToCloudWatch -logData $logData -logGroupName "AppStream/"+$hostname+"- Event Logs" -logStreamName "Event-$(Get-Date -Format o)"
        }

        if ($systemCrashLogs) {
            $logData = $systemCrashLogs | Format-Table | Out-String
            Send-ToCloudWatch -logData $logData -logGroupName "AppStream/"+$hostname+$hostname+"- System Crash Logs" -logStreamName "SystemCrash-$(Get-Date -Format o)"
        }
        
        if ($dnsLogs) {
            $logData = $dnsLogs | Format-Table | Out-String
            Send-ToCloudWatch -logData $logData -logGroupName "AppStream/"+$hostname+$hostname+"- DNS Logs" -logStreamName "DNS-$(Get-Date -Format o)"
}

        Start-Sleep -Seconds 300
    }
}

Start-LogCollection
```