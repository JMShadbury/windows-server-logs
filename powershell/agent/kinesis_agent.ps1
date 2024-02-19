function installAgent(){
    $installerUrl = "https://kinesis-agent.s3.ap-southeast-2.amazonaws.com/AWSKinesisTap.1.2.10.2.msi"
    $installerPath = "C:\temp\KinesisAgentInstaller.msi"
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
    Start-Process msiexec.exe -ArgumentList "/i $installerPath /quiet" -Wait
}

function configureAgent(){
    $configSource = "C:\temp\appsettings.json"
    $configPath = "C:\Program Files\Amazon\AWSKinesisTap\appsettings.json"
    Copy-Item $configSource $configPath
}

function startAgent(){
    Start-Service -Name "AWSKinesisTap" 
}
