function Upload-ToS3 {
    param (
        [string]$filePath,
        [string]$bucketName
    )
    Write-S3Object -BucketName $bucketName -File $filePath -Key (Split-Path $filePath -Leaf)
}