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

## Customizing and building the image

Clone this repository, edit `Dockerfile` and then run `docker build` as usual:

```
git clone https://github.com/Athena-OS/athena-wsl.git
cd athena-wsl
docker buildx build --tag 'athena-wsl:latest' .
```

## Push to Docker registry
Push the image to Docker Hub by:
```
sudo docker push athenaos/wsl:latest
```
If requested, the login must be performed by:
```
sudo docker login
```
