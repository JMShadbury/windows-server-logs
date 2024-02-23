. "$PSScriptRoot/logs/events.ps1"
. "$PSScriptRoot/system/store.ps1"

function scan {
    $logs = get_logs
    $logs
}