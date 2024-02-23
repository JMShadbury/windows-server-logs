
function get_event_log(
    [string]$log_name
){
    # Get the events from the specified log
    $events = Get-WinEvent -LogName $log_name
    return $events
}

function init_logs {
    try {
        # Get all event logs
        $application_log = get_event_log -log_name "Application"
        $system_log = get_event_log -log_name "System"

            # Check if logs are empty
            if (-not $application_log -and -not $system_log) {
                Write-Host "No events found in Application and System logs."
                return
            }

        # Add log name to each event
        $app_temp = $application_log | Select-Object @{Name="LogName";Expression={"Application"}}, ProviderName, TimeCreated, Id, Message
        $sys_temp = $system_log | Select-Object @{Name="LogName";Expression={"System"}}, ProviderName, TimeCreated, Id, Message

        # Merge the logs
        $merged_logs = $app_temp + $sys_temp | Sort-Object TimeCreated

        #format the merged logs for cloudwatch logs
        $merged_logs = $merged_logs | ForEach-Object {
            $log = $_
            $log.Message = $log.LogName + ": " + $log.Message
            $log
        } | Format-Table -Property LogName, ProviderName, TimeCreated, Id, Message | Out-String

        return $merged_logs

    } catch {
        Write-Host "Error getting logs: $_"
    }
}

function checkLogs { 
    $app_log = get_event_log -log_name "Application"
    $sys_log = get_event_log -log_name "System"

    $app_log_cached = retrieve_file -file_name "event_log.txt"
    $sys_log_cached = retrieve_file -file_name "system_log.txt"

    if ($app_log -ne $app_log_cached -or $sys_log -ne $sys_log_cached) {
        into("Update logs.")
        store_file -file_name "event_log.txt" -file_contents $app_log
        store_file -file_name "system_log.txt" -file_contents $sys_log
    }
    else {
        info("Logs are up to date.")
    }
}
