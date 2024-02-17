. "$PSScriptRoot/system/windows_info.ps1"


$hostname = getHost
$logTypes = @("Application", "System", "Security", "Setup", "ForwardedEvents")
foreach ($logType in $logTypes) {
    $logPath = "C:\Logs\$logType.evtx"
    Get-EventLog -LogName $logType | Export-Clixml -Path $logPath

    # Upload to S3
    Upload-ToS3 -filePath $logPath -bucketName $bucketName

    # Send Application and System logs to CloudWatch
    if ($logType -eq "Application" -or $logType -eq "System") {
        $logData = Get-Content $logPath
        $logGroupName = $hostname+"EventViewerLogs"
        $logStreamName = "$logType-$(Get-Date -Format o)"
        Send-ToCloudWatch -logData $logData -logGroupName $logGroupName -logStreamName $logStreamName
    }
}

$systemCrashLogs = Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    ProviderName = 'Microsoft-Windows-WER-SystemErrorReporting'
} -ErrorAction SilentlyContinue | ForEach-Object {
    [PSCustomObject]@{
        TimeCreated = $_.TimeCreated
        Message = $_.Message
        Category = $_.LogName
        LogType = 'SystemCrash'
    }
}

Send-ToCloudWatch -logData ($systemCrashLogs | ConvertTo-Json -Depth 5) -logGroupName "SystemCrashLogs" -logStreamName "SystemCrash-$(Get-Date -Format o)"