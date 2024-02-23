
function log(
    [string]$message,
    [string]$log_level
){
    # Get the current date and time
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    # Get the current script name
    $script_name = $MyInvocation.MyCommand.Name
    # Get the current script line number
    $line_number = $MyInvocation.ScriptLineNumber
    # Get the current script file path
    $script_path = $MyInvocation.MyCommand.Path

    # Create the log message
    $log_message = "$date $log_level $script_name $line_number $script_path $message"

    # Log the message to the console
    Write-Host $log_message
}

function debug(
    [string]$message
){
    log -message $message -log_level "DEBUG"
}
function info(
    [string]$message
){
    log -message $message -log_level "INFO"
}
function warn(
    [string]$message
){
    log -message $message -log_level "WARN"
}
function error(
    [string]$message
){
    log -message $message -log_level "ERROR"
}
function fatal(
    [string]$message
){
    log -message $message -log_level "FATAL"
}
function trace(
    [string]$message
){
    log -message $message -log_level "TRACE"
}
function save_logs(
    [string]$logs
){
    $log_file = "$PSScriptRoot\logs.txt"
    [System.IO.File]::WriteAllText($log_file, $logs)
}
