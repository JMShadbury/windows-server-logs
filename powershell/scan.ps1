. "$PSScriptRoot/logs/events.ps1"
. "$PSScriptRoot/system/store.ps1"
. "$PSScriptRoot/system/util/logger.ps1"
. "$PSScriptRoot/amazon/cloudwatch.ps1"

# First run
info("First run, Initialize logs.")
$event_logs = init_logs
store_file -file_name "event_logs.txt" -file_contents $event_logs

$runspacePool = [runspacefactory]::CreateRunspacePool(1, 2)
$runspacePool.Open()

function CreateRunspaceTask([scriptblock]$scriptBlock) {
    $powershell = [powershell]::Create().AddScript($scriptBlock)
    $powershell.RunspacePool = $runspacePool
    return $powershell.BeginInvoke(), $powershell
}

# Check logs task
$checkLogsTask = {
    while ($true) {
        info("Checking Logs")
        $logs = check_logs
        return $logs
        Start-Sleep -Seconds 60
    }
}

# Push logs task
$pushLogsTask = {
    while ($true) {
        info("Pushing Logs")
        push_logs
        Start-Sleep -Seconds 600
    }
}

# Start tasks
$checkLogsPs, $checkLogsHandle = CreateRunspaceTask $checkLogsTask $syncHash
$pushLogsPs, $pushLogsHandle = CreateRunspaceTask $pushLogsTask $syncHash

# Monitoring and management loop
do {
    Start-Sleep -Seconds 5 

    # Collect output from check logs task
    if ($checkLogsPs) {
        try{
            $checkLogsPs.Streams.Error.ReadAll() | Out-Host  # Display errors
            $checkLogsPs.Streams.Verbose.ReadAll() | Out-Host  # Display verbose messages
            $checkLogsPs.Streams.Output.ReadAll() | Out-Host  # Display standard output
        }catch{
 
        }
    }

    # Collect output from push logs task
    if ($pushLogsPs) {
        try{
            $pushLogsPs.Streams.Error.ReadAll() | Out-Host
            $pushLogsPs.Streams.Verbose.ReadAll() | Out-Host
            $pushLogsPs.Streams.Output.ReadAll() | Out-Host
        }catch{
        }
    }
} while ($true)
