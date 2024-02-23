. "$PSScriptRoot/logger.ps1"
function CreateEncryptionKey(
    [string]$key_path
) {
    info("Creating encryption key.")
    $key = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $key.PersistKeyInCsp = $true
    debug("Saving...")
    $key_path = $key_path
    [System.IO.File]::WriteAllText($key_path, $key.ToXmlString($true))
    return $key
}
function GetEncryptionKey(
    [string]$key_path
) {
    if (-not (Test-Path key_path)) {
        info("Key not found")
        return CreateEncryptionKey -key_path $key_path
    }
    else {
        info("Key found")
        return RetrieveEncryptionKey -key_path $key_path
    }
}

function RetrieveEncryptionKey(
    [string]$key_path
) {
    info("Retrieving encryption key.")
    $key = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $key.FromXmlString([System.IO.File]::ReadAllText($key_path))
    debug("Key retrieved.")
    return $key
}