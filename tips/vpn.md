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
# open the link which showed up
```

[Source link](https://www.digitalocean.com/community/tutorials/how-to-run-openvpn-in-a-docker-container-on-ubuntu-14-04)


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

