. "$PSScriptRoot/logs/events.ps1"
. "$PSScriptRoot/system/store.ps1"

function scan {
    $logs = get_logs
    store_file -file_name "logs.txt" -file_contents $logs
}