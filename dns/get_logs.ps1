function Get-DNSLogs {
    try {
        # Collect DNS Server logs
        $dnsLogs = Get-WinEvent -LogName "Microsoft-Windows-DNS-Server/Service" -ErrorAction Stop

        # Return the collected logs
        return $dnsLogs
    }
    catch {
        Write-Error "Error collecting DNS logs: $_"
        return $null
    }
}
