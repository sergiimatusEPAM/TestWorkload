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
  Also you may use your own image, see `DockerFile.jenkins.windows.slave` file for pre-configuration, depending on your needs.

- Add a static node named `build-docker` as a Jenkins slave on Windows for building a docker images. Note, the step requires as there is currently limitation - Docker in Docker concept doesn't work on Windows yet.
  
  For this follow [Step by step guide to set up master and agent machines on Windows](https://wiki.jenkins.io/display/JENKINS/Step+by+step+guide+to+set+up+master+and+agent+machines+on+Windows)  
  Please note that "Launch agent via Java Web Start" method was renamed to "Launch agent by connecting it to master"

- Submit (Global Credentials -> 'Username and password')[https://jenkins.io/doc/book/using/using-credentials/#adding-new-global-credentials] for Nexus and DockerHub. Name them `Nexus_token` and `DockerHub_token` respectively

- Install [Credentials Binding](https://plugins.jenkins.io/credentials-binding) plugin

- Create a Scripted Pipeline Job with defined at `Jenkinsfile`. 
