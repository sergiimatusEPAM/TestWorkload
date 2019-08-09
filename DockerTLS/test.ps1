param(
  $ServerName = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain,
  $IPAddresses = ((Get-NetIPAddress -AddressFamily IPv4).IPAddress) -Join ',',
  $AlternativeNames = [System.Net.Dns]::GetHostEntry([string]$env:computername).HostName
)

if (!(Test-Path .\test\client\.docker)) {
  mkdir ".\test\client\.docker"
}
if (!(Test-Path .\test\server)) {
  mkdir ".\test\server"
}

docker container run --rm `
  --user ContainerAdministrator `
  -e SERVER_NAME=$ServerName `
  -e IP_ADDRESSES=$IPAddresses `
  -e ALTERNATIVE_NAMES=$AlternativeNames `
  -v "$(pwd)\test\server:C:\ProgramData\docker" `
  -v "$(pwd)\test\client\.docker:C:\Users\containeradministrator\.docker" `
  sergiimatusepam/dockertls-windows:latest
