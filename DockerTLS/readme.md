---
author: taylorb-microsoft
---

# Protect the Docker daemon socket on Windows
This is an initial set of PowerShell scripts that utalize OpenSSL to automate creating self signed keys and certificates for Docker on Windows.  These scripts follow the directions at https://docs.docker.com/engine/security/https/.


## Example Workflow:
On your client machine run:
```powershell
  . .\DockerCertificateTools.ps1
  Install-OpenSSL
  New-OpenSSLCertAuth
  New-ClientKeyandCert
```

Then either run:
```powershell 
New-ServerKeyandCert -serverKeyFile "c:\myDockerKeys\server-key.pem" -serverCert "c:\myDockerKeys\server-cert.pem" -serverIPAddresses @($(([System.Net.DNS]::GetHostAddresses("$($env:COMPUTERNAME)")|Where-Object {$_.AddressFamily -eq "InterNetwork"}   |  select-object IPAddressToString)[0].IPAddressToString), "127.0.0.1")
``` 
Where you don't need to provide the container hosts name/IP Address, the script will detect automatically.
Then copy the server-cert.pem/server-key.pem and ca.pem file to the c:\programdata\docker\certs.d directory and create a tag.txt file in c:\programdata\docker directory.
```powershell
mkdir c:\programdata\docker\certs.d
Copy-Item C:\myDockerKeys\ca.pem C:\Users\Administrator\.docker\
Copy-Item C:\myDockerKeys\*.pem C:\ProgramData\docker\certs.d\

Copy-Item daemon.json C:\ProgramData\docker\config\daemon.json
```
Restart docker service:
```powershell
Restart-Service -Name docker -Force

```


