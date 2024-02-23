# Description: This script will store a file in a local cache directory to be accessed at a later date. This may be required by more than one function but should be encrypted incase of sensitive date.

function store_file(
    [string]$file_path,
    [string]$file_name,
    [string]$file_contents
){
    # Create the cache directory if it doesn't exist
    $cache_dir = "C:\cache"
    if (-not (Test-Path $cache_dir)) {
        New-Item -ItemType Directory -Path $cache_dir
    }

    # create private key
    $private_key = New-Object System.Security.Cryptography.RSACryptoServiceProvider

    # encrypt the file contents
    $encrypted_file_contents = $private_key.Encrypt($file_contents, $true)

    # Store the file in the cache directory
    $file_path = Join-Path -Path $cache_dir -ChildPath $file_name
    Set-Content -Path $file_path -Value $encrypted_file_contents
}

# Description: This script will retrieve a file from a local cache directory. This may be required by more than one function but should be encrypted incase of sensitive date.

function retrieve_file(
    [string]$file_name
){
    # Create the cache directory if it doesn't exist
    $cache_dir = "C:\cache"
    if (-not (Test-Path $cache_dir)) {
        New-Item -ItemType Directory -Path $cache_dir
    }

    # create private key
    $private_key = New-Object System.Security.Cryptography.RSACryptoServiceProvider

    # Retrieve the file from the cache directory
    $file_path = Join-Path -Path $cache_dir -ChildPath $file_name
    $file_contents = Get-Content -Path $file_path

    # decrypt the file contents
    $decrypted_file_contents = $private_key.Decrypt($file_contents, $true)

    return $decrypted_file_contents
}
```