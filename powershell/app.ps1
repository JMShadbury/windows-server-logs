"$PSScriptRoot/agent/kinesis_agent.ps1"
"$PSScriptRoot/user_details/user.ps1"

function createSchedule(){

    $path = '-File '+$PSScriptRoot+'\agent\kinesis_agent.ps1"'
    $Action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $path
    $Trigger = New-ScheduledTaskTrigger -AtLogon
    $Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    Register-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -TaskName "SetEnvironmentVariables" -Description "Set system-level environment variables for CloudWatch"
}

function main(){
    getAgent
    installAgent
    configureAgent
    startAgent
    createSchedule
}
