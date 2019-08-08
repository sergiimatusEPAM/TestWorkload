---
author: Various...
---

For complete guide use [Dominic's Field Guide](https://docs.google.com/document/d/10oA8ZwvNt0lqaACyZSwWk5gMW-TQDOobQz-AzN8B7OE)

# Build .NET Core application using DC/OS and Jenkins 
This is an initial set for show case of building .NET Core application on dynamically spinned up Jenkins Slave on Windows.


Spins up dynamic Jenkins slave on Windows in Docker container,
checkouts GitHub repository,
runs “dotnet build”, 
packs the TestWorkload application into zip, 
upload to Nexus artifacts repository, 
builds the application in a Docker image
and finally publishes the image to DockerHub.


## Example Workflow:
### at Windows slave nodes:
- install git with choco (`choco install git -y`)
- clone https://github.com/alekspv/TestWorkload.git repo
- gererate SSL certs (`powershell .\TestWorkload\DockerTLS\run.ps1`)

### at DC/OS cluster setup following services:
- Jenkins from [Marathon-templates/jenkins.json](https://github.com/alekspv/TestWorkload/blob/master/Marathon-templates/jenkins.json)
- Nexus from DC/OS catalog, just specify the static port `27092` as it has been used in the pipeline
- Marathon-lb from DC/OS catalog

### at DockerHub:
- sign up
- create `testworkload-app` repository. Grab full name, i.e. `sergiimatusepam/testworkload-app`

### at Nexus: 
- login with default credentials
- create raw(hosted) repository called `dotnet-sample` and uncheck box "Validate format"

### at Jenkins: 
- Submit (Global Credentials -> 'Username and password')[https://jenkins.io/doc/book/using/using-credentials/#adding-new-global-credentials] for Nexus and DockerHub. Name them `Nexus_token` and `DockerHub_token` respectively

- Install [Credentials Binding](https://plugins.jenkins.io/credentials-binding) plugin

- Create a Scripted Pipeline Job with defined at `Jenkinsfile`.
