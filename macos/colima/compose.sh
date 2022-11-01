ARCH=aarch64
VERSION=v2.12.2
curl -LO https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-darwin-${ARCH}
mkdir -p ~/.docker/cli-plugins
mv docker-compose-darwin-${ARCH} ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
