$version=$(select-string -Path Dockerfile -Pattern "ENV VERSION").ToString().split()[-1]
docker tag dockertls sergiimatusepam/dockertls-windows:$version
docker tag dockertls sergiimatusepam/dockertls-windows
docker push sergiimatusepam/dockertls-windows:$version
docker push sergiimatusepam/dockertls-windows
