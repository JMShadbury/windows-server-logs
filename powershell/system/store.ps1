. "$PSScriptRoot\util\key.ps1"
. "$PSScriptRoot\util\logger.ps1"

function store_file(
    [string]$file_name,
    [string]$file_contents
){
    # Create the cache directory if it doesn't exist
    $cache_dir = "$PSScriptRoot\cache"
    if (-not (Test-Path $cache_dir)) {
        New-Item -ItemType Directory -Path $cache_dir
    }

    info("Storing file: $file_name")

    # Get or create the encryption key
    $private_key = GetEncryptionKey -key_path "$PSScriptRoot\key.xml"

    # Encrypt the symmetric key using RSA
    $aesManaged = New-Object System.Security.Cryptography.AesManaged
    $aesManaged.GenerateKey()
    $aesManaged.GenerateIV()
    $symmetricKey = $aesManaged.Key
    $iv = $aesManaged.IV
    $encryptedSymmetricKey = $private_key.Encrypt($symmetricKey, $true)
    $encryptedIV = $private_key.Encrypt($iv, $true)

    # Encrypt the file contents using the symmetric key
    $encryptor = $aesManaged.CreateEncryptor($symmetricKey, $iv)
    $ms = New-Object System.IO.MemoryStream
    $cs = New-Object System.Security.Cryptography.CryptoStream $ms, $encryptor, "Write"
    $sw = New-Object System.IO.StreamWriter $cs
    $sw.Write($file_contents)
    $sw.Flush()
    $cs.FlushFinalBlock()
    $encrypted_file_contents = $ms.ToArray()

    # Combine the encrypted symmetric key, IV, and the encrypted data with lengths
    $combinedData = [BitConverter]::GetBytes($encryptedSymmetricKey.Length) + $encryptedSymmetricKey +
                    [BitConverter]::GetBytes($encryptedIV.Length) + $encryptedIV +
                    $encrypted_file_contents

    # Store the combined data in the cache directory
    $file_path = Join-Path -Path $cache_dir -ChildPath $file_name
    [System.IO.File]::WriteAllBytes($file_path, $combinedData)
}


function retrieve_file(
    [string]$file_name
){
    # Create the cache directory if it doesn't exist
    $cache_dir = "$PSScriptRoot\cache"
    if (-not (Test-Path $cache_dir)) {
        New-Item -ItemType Directory -Path $cache_dir
    }

    # Use the same key for decryption
    $private_key = RetrieveEncryptionKey

    # Retrieve the file from the cache directory
    $file_path = Join-Path -Path $cache_dir -ChildPath $file_name
    $encrypted_file_contents = [System.IO.File]::ReadAllBytes($file_path)

    # Decrypt the file contents
    $decrypted_file_contents = $private_key.Decrypt($encrypted_file_contents, $true)
    $decrypted_text = [System.Text.Encoding]::UTF8.GetString($decrypted_file_contents)

    return $decrypted_text
}