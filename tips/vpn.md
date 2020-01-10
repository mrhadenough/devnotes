### Super easy way

Works even if ISP is blocking VPN/proxy traffic. And if no ssh traffic is alowed then luck is not on your side.

```
# mac
brew install sshuttle
# linux
apt install sshuttle

sshuttle -r root@1.2.3.4 0.0.0.0/0 -vv
sshuttle -r root@1.2.3.4 0.0.0.0/0

```

### Start socks proxy on 127.0.0.1:1080
```
ssh -N -D 1080 root@1.2.3.4
```

### Run socks5 proxy server by docker
```
docker run -d --name socks5 -p 1080:1080 -e PROXY_USER=<PROXY_USER> -e PROXY_PASSWORD=<PROXY_PASSWORD> serjs/go-socks5-proxy
```

### Easy way to setup VPN server via docker

On server

```
OVPN_DATA="ovpn-data"
IP_ADDRESS=$(curl -s ipinfo.io | grep -Po '\d+\.\d+\.\d+\.\d+')
docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$IP_ADDRESS
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
docker run -v $OVPN_DATA:/etc/openvpn --restart=always -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full client nopass
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient client > client.ovpn
echo http://$IP_ADDRESS:8001 && python3 -m http.server 8001
# open the link which showed up to download clint.ovpn
```

Allow connection to docker if your iptables doesn't allow this

```
# remove all iptables configurations
iptables -F
# allow all incoming traffic from outside internet
iptables -I INPUT -j ACCEPT
# allow to forward outcome traffic to docker
iptables -A FORWARD -i docker0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o docker0 -j ACCEPT
```

Source:

[Github source link](https://github.com/kylemanna/docker-openvpn)

[Digital Ocean community page](https://www.digitalocean.com/community/tutorials/how-to-run-openvpn-in-a-docker-container-on-ubuntu-14-04)

## Hard way

### OpenVPN LAN subnet expose to client

```
echo 1 > /proc/sys/net/ipv4/ip_forward
```

To enable the changes made in sysctl.conf you will need to run the command:

```
sysctl -p /etc/sysctl.conf

```

On VPN server run to forward connection

```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT
```

At `/etc/openvpn/server.conf` add this

```
push "route 192.168.0.0 255.255.0.0"

```

### Install setup OpenVPN server client

prepare ubuntu

https://help.ubuntu.com/lts/serverguide/openvpn.html

setup OpenVPN to change you IP

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-16-04

Base config of cahnging IP is `push "redirect-gateway def1 bypass-dhcp"`


### Important configurations lines

```
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 208.67.222.222"
push "dhcp-option DNS 208.67.220.220"
client-to-client

```

