#Select all IPv4 interfaces that have a *192* IP address
$interfacesToUpdate = Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.ServerAddresses -like "*192*"}

foreach($i in $interfacesToUpdate){
    echo "DNS Servers for $($i.InterfaceAlias) are : $($i.ServerAddresses -join ', ')" 
    $newDnsServers = @("127.0.0.2")    
    $externalAddresses = $i.ServerAddresses | Where-Object {$_ -notlike "*127*"}
    $externalAddresses.ForEach({$newDnsServers += $_})
    echo "New DNS Servers for $($i.InterfaceAlias) are : $($newDnsServers -join ', ')" 
    Set-DNSClientServerAddress –interfaceIndex $i.InterfaceIndex –ServerAddresses $newDnsServers
}

#Do a ping to a expected DNS resolved domain
ping test.ping