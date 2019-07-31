---
author: sergii_matus@epam.com
---

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
At DC/OS cluster setup following services:
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
- Place name of Docker Image which is going to be used to build dotnet application at "Jenkins on Mesos" plugin. I.e. `sergiimatusepam/dotnet-builder`

  Go to Manage Jenkins -> Configure System -> follow "Advanced" after "Mesos Cloud" section -> follow "Advanced" after "Use Docker Containerizer" -> Use `sergiimatusepam/dotnet-builder:latest`
  Also you may use your own image, see `dotnet-builder\DockerFile.jenkins.windows.slave` file for pre-configuration, depending on your needs.

- For enabling docker-in-docker support, mark checkbox `Use custom docker command shell` and provide wrapper script relative path from root of disk `C:\` (for example if script is placed in `c:\wrapper.cmd` you need to specify `wrapper.cmd`). Volume with client SSL certs need to be added with following parameters:

    `Container Path: C:\Users\containeradministrator\.docker`  
    `Host Path: c:\docker-tls\client\.docker`

  And the last step - add two container environment variables via adding two additional plugin parameters:

    `Name: env`
    `Value: DOCKER_HOST=tcp://gateway.docker.internal:2376`   
   `Name: env`
    `Value: DOCKER_TLS_VERIFY=1`

- Submit (Global Credentials -> 'Username and password')[https://jenkins.io/doc/book/using/using-credentials/#adding-new-global-credentials] for Nexus and DockerHub. Name them `Nexus_token` and `DockerHub_token` respectively

- Install [Credentials Binding](https://plugins.jenkins.io/credentials-binding) plugin

- Create a Scripted Pipeline Job with defined at `Jenkinsfile`. 
