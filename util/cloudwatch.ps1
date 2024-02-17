function install_aws_module {
    Install-Module -Name AWSPowerShell.NetCore -Scope CurrentUser
}

function Send-ToCloudWatch {
    param (
        [string]$logData,
        [string]$logGroupName,
        [string]$logStreamName
    )
    # Creating Log Group and Stream
    New-CWLLogGroup -LogGroupName $logGroupName -ErrorAction Ignore
    New-CWLLogStream -LogGroupName $logGroupName -LogStreamName $logStreamName -ErrorAction Ignore
    # Writing to CloudWatch Logs
    Write-CWLLogEvent -LogGroupName $logGroupName -LogStreamName $logStreamName -LogEvent @{Timestamp=[DateTime]::UtcNow;Message=$logData}
}