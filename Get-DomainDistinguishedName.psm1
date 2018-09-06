Function Get-DomainDistinguishedName {
    $DNSName = $env:USERDNSDOMAIN.Split(".") 
    for ($i=0; $i -lt $DNSName.length; $i++) {
        $DNSName[$i] = "DC=" + $DNSName[$i]
    }
    $DNSName = [String]::Join(",",$DNSName)
    return $DNSName
}
