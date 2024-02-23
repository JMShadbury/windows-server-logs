. "$PSScriptRoot/logs/events.ps1"
. "$PSScriptRoot/system/store.ps1"
. "$PSScriptRoot/system/util/logger.ps1"
. "$PSScriptRoot/amazon/cloudwatch.ps1"

$first_run = $true
function scan {
    if ($first_run) {
        info("First run, Initialize logs.")
        $first_run = $false
        $event_logs = init_logs
        store_file -file_name "event_logs.txt" -file_contents $event_logs
    }
    else {
        info("Not first run")
    }
    
}

# Push to CloudWatch
while ($true) {
    scan
    Start-Sleep -Seconds 600  # Sleep for 10 minutes
}

# System Scan
while ($true) {
    push_logs
    Start-Sleep -Seconds 60 # Sleep for 1 minute
}
