# forticlient

## Update (06/02/2018)
-   Add support pkcs12 certificate.

Connect to a FortiNet VPNs through docker


## Usage

The container uses the forticlientsslvpn_cli linux binary to manage ppp interface

All of the container traffic is routed through the VPN, so you can in turn route host traffic through the container to access remote subnets.


### Linux

```bash
# Create a docker network, to be able to control addresses
docker network create --subnet=172.16.0.0/28 \
                      --opt com.docker.network.bridge.name=myvpn \
                      --opt com.docker.network.bridge.enable_icc=true \
                      --opt com.docker.network.bridge.enable_ip_masquerade=true \
                      --opt com.docker.network.bridge.host_binding_ipv4=0.0.0.0 \
                      --opt com.docker.network.driver.mtu=9001 \
                      myvpn

# Start the priviledged docker container with a static ip
docker run -d --rm \
  --privileged \
  --net myvpn --ip 172.16.0.3 \
  --volume /path/dircertfile:/srv
  -e VPNADDR=host:port \
  -e VPNUSER=me@domain \
  -e VPNPASS=secretuser \
  -e CERTFILE=/srv/pk12file.pem \
  -e CERTPASS=secretcert \
  --name yourname \
  ieperez/forticlient

# Add route for you remote subnet (ex. 10.201.0.0/16)
ip route add 10.201.0.0/16 via 172.16.0.3

# Access remote host from the subnet
ssh 10.201.8.1
```
## Docker environment file.

Create file Variables.

```bash
vim .env
```
```bash
VPNADDR=hostvpn:port
VPNUSER=username
VPNPASS=userpass
CERTFILE=/srv/pkcs12.pem
CERTPASS=certpass
```

Run docker with env file.

```bash
docker run -d --rm -privileged \
  --env-file ./.env
  --net myvpn --ip 172.16.0.3 \
  --name vpn-forticlient \
  -v /path/dircertfile.pem:/srv/pkcs12.pem \
  ieperez/forticlient
```
# Add route for you remote subnet (ex. 10.201.0.0/16)
ip route add 10.201.0.0/16 via 172.16.0.3

# Access remote host from the subnet
ssh 10.201.8.1

## Docker secret.

Manage password user and password certificate with docker secret.

Secrets use:

User password:
```bash
echo "password" | docker secret create vpn-user-pass -
```
Example with labels:
```bash
echo "dkljdlaskjdlkasjdjsa" | docker secret create -l user.edu.ext -l education -l forticlient vpn-user-edu-pass -
```

Certificate password:
```bash
echo "password" | docker secret create vpn-cert-pass -
```
Example with labels:
```bash
echo "lñkñlkñlkñlkñljñljjkkl" | docker secret create -l user.edu.ext -l pkcs12 -l education -l forticlient vpn-cert-edu-pass -
```

Docker-compose....

## Misc

If you don't want to use a docker network, you can find out the container ip once it is started with:
```bash
# Find out the container IP
docker inspect --format '{{ .NetworkSettings.IPAddress }}' <container>

```

### Precompiled binaries

Thanks to [https://hadler.me](https://hadler.me/linux/forticlient-sslvpn-deb-packages/) for hosting up to date precompiled binaries which are used in this Dockerfile.
