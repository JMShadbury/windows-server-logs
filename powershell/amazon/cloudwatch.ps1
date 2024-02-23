function get_cloudwatch_client(
    [string]$region
) {
    $region = $region
    $credentials = Get-Credential
    $client = New-Object -TypeName Amazon.CloudWatchLogs.AmazonCloudWatchLogsClient -ArgumentList @($credentials.GetNetworkCredential().UserName, $credentials.GetNetworkCredential().Password, $region)
    return $client
}
function clean_data (
    [string]$data
){
    $data = $data | Out-String
    $data = $data -replace "`r`n", "`n"
    $data = $data -replace "` ", "" # Remove leading spaces
    $data = $data -replace "`t", "" # Remove tabs
    $data = $data -replace "`n", "`r`n" # Replace newlines with carriage return and newline
    $data = $data -replace " +", " " # Replace multiple spaces with a single space
    return $data
}
function push_logs(
    [string]$region,
    [string]$log_group_name
) {
    $logs = retrieve_file -file_name "$PSScriptRoot\event_logs.txt"
    $logs = clean_data -data $logs
    $client = get_cloudwatch_client -region $region
    $log_stream_name = $env:USERNAME+":"+(Get-Date).ToString("yyyy-MM-dd-HH-mm-ss")+":"+$env:COMPUTERNAME+":"+$env:AppStream_Resource_Name

    $client.CreateLogStream(
        @{
            logGroupName = $log_group_name
            logStreamName = $log_stream_name
        }
    )
    $client.PutLogEvents(
        @{
            logGroupName = $log_group_name
            logStreamName = $log_stream_name
            logEvents = @(
                @{
                    message = $logs
                    timestamp = [DateTime]::UtcNow
                }
            )
        }
    )
    info("Logs pushed to CloudWatch")
}


