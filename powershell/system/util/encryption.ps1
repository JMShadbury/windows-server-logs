function CreateEncryptionKey(
    [string]$key_path
) {
    $key = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $key.PersistKeyInCsp = $true
    $key_path = $key_path
    [System.IO.File]::WriteAllText($key_path, $key.ToXmlString($true))
    return $key
}
function GetEncryptionKey(
    [string]$key_path
) {
    if (-not (Test-Path key_path)) {
        return CreateEncryptionKey -key_path $key_path
    }
    else {
        return RetrieveEncryptionKey
    }
}

function RetrieveEncryptionKey(
    [string]$key_path
) {

    $key = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $key.FromXmlString([System.IO.File]::ReadAllText($key_path))
    return $key
}