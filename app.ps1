# Import other scripts
. "$PSScriptRoot/system/windows_events.ps1"
. "$PSScriptRoot/util/cloudwatch.ps1"
. "$PSScriptRoot/util/s3.ps1"
. "$PSScriptRoot/system/windows_info.ps1"
. "$PSScriptRoot/system/dns_logs.ps1"

$hostname = getHost
function Start-LogCollection {
    while ($true) {
        $collectedLogs = Get-WindowsEventLogs
        $dnsLogs = Get-DNSLogs

        foreach ($log in $collectedLogs) {
            if ($log.Category -eq "Application" -or $log.Category -eq "System") {
                Send-ToCloudWatch -Log $log
            } else {
                Upload-ToS3 -Log $log
            }
        }
        
        
        if ($dnsLogs) {
            $logData = $dnsLogs | Format-Table | Out-String
            Send-ToCloudWatch -logData $logData -logGroupName $hostname+"- DNS Logs" -logStreamName "DNS-$(Get-Date -Format o)"
}

        Start-Sleep -Seconds 300
    }
}

Start-LogCollection