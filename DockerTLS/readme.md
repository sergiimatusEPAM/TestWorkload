# Protect the Docker daemon socket on Windows
Create TLS certs for Docker, inside a Docker container. This avoids installing OpenSSL directly on your machine. As a source - following repo was used https://github.com/StefanScherer/dockerfiles-windows/tree/master/dockertls. 

## Usage

### Build
Run `build.ps1` to build container. Then run `push.ps1` to push it to DockerHub.

### Test
Run `test.ps1` to generate certs/configs and store them into `test` folder. This action doesn't affect current docker engine configuration. It can be used for validating changes, that will be applied.

### Production setup
Run `run.ps1` to generate certs/configs and store them into appropriate folders. After successfull script execution, docker engine should be restarted with `restart-service docker -force` command to apply new config.
