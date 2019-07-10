# escape=`

# Installer image
FROM mcr.microsoft.com/windows/servercore:1903 AS installer

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Retrieve .NET Core Runtime
ENV DOTNET_VERSION 2.2.6

RUN Invoke-WebRequest -OutFile dotnet.zip https://dotnetcli.blob.core.windows.net/dotnet/Runtime/$Env:DOTNET_VERSION/dotnet-runtime-$Env:DOTNET_VERSION-win-x64.zip; `
    $dotnet_sha512 = 'b4ad5fdc9729e4be5bda5cfa7d7eaf9967c7792e099ff139e08b4617118e0ec7c62f0252a235f9b3e861e3014795c4bbd75e1edda0d284567f456d935cd02d14'; `
    if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { `
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
        exit 1; `
    }; `
    `
    Expand-Archive dotnet.zip -DestinationPath dotnet; `
    Remove-Item -Force dotnet.zip


# Runtime image
FROM mcr.microsoft.com/windows/nanoserver:1903

COPY --from=installer ["/dotnet", "/Program Files/dotnet"]

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;C:\Program Files\dotnet"
USER ContainerUser

# Configure web servers to bind to port 80 when present
ENV ASPNETCORE_URLS=http://+:80 `
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true


FROM mcr.microsoft.com/windows/nanoserver:1903 as demoapp
# Downloading artifact
RUN Invoke-WebRequest -OutFile demoapp.zip http://ec2-54-226-133-173.compute-1.amazonaws.com:27092/repository/dotnet-sample/artifact-1.0.0.zip; `
    Expand-Archive demoapp.zip -DestinationPath demoapp; `
    Remove-Item -Force demoapp.zip

FROM mcr.microsoft.com/windows/nanoserver:1903 
COPY --from=demoapp demoapp ./
WORKDIR /demoapp
ENTRYPOINT ["dotnet", "DemoApp.dll"]
