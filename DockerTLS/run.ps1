param(
  $ServerName = [System.Net.Dns]::GetHostEntry([string]$env:computername).HostName,
  $IPAddresses = ((Get-NetIPAddress -AddressFamily IPv4).IPAddress) -Join ',',
  $AlternativeNames = "gateway.docker.internal"
)

if (!(Test-Path c:\docker-tls\client\.docker)) {
  mkdir c:\docker-tls\client\.docker
}

docker container run --rm `
  --user ContainerAdministrator `
  -e SERVER_NAME=$ServerName `
  -e IP_ADDRESSES=$IPAddresses `
  -e ALTERNATIVE_NAMES=$AlternativeNames `
  -v "c:\programdata\docker:C:\ProgramData\docker" `
  -v "c:\docker-tls\client\.docker:C:\Users\containeradministrator\.docker" `
  sergiimatusepam/dockertls-windows:latest

restart-service docker -force
