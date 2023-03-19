# Athena WSL
Official Athena OS WSL images.

Creating the WSL RootFS image. Be sure that the image is not stored locally in your machine and no Athena WSL containers have been created. If so, delete them.

Create a docker container from the Athena WSL image:
```
docker create --name athena-wsl docker.io/athenaos/wsl
```
Export the RootFS of Athena WSL container:
```
docker export -o install.tar athena-wsl
```
Create `.tar.gz` archive:
```
gzip .\install.tar
```
