$version=$(select-string -Path Dockerfile -Pattern "ENV VERSION").ToString().split()[-1]
docker tag sergiimatusepam/dockertls-windows sergiimatusepam/dockertls-windows:$version
docker tag sergiimatusepam/dockertls-windows sergiimatusepam/dockertls-windows:dind
docker push sergiimatusepam/dockertls-windows:$version
docker push sergiimatusepam/dockertls-windows:dind
docker push sergiimatusepam/dockertls-windows
