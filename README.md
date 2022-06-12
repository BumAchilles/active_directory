# 01 Installing the Domain  Controller

1. Use `sconfig` to:
    - Change the Hostname
    - Change the IP Address to Static
    - Change the DNS server to our own IP address

2. Install the Active Directory Windows Feature

```shell 
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

3. Import PowerShell Module and Install Forest

```
Import-Module ADDSDeployment
```

```
Install-Module ADDSDeployment
```
# Set the Domain Name

# After reboot DC will set DNS IP to a loopback address

4. Configure Static IP on DC

```
Get-NetIPAddress -IPAddress '192.168.100.156'
```

```
Set-DnsClientServerAddress -InterfaceIndex 12 -ServerAddresses 192.168.0.254
```


```
Get-NetIPAddress
```


# Joining the Workstation to the Domain Controller



```
Add-Computer -Domainname jelly.com -Credential jelly/administrator -Force -Restart
```
