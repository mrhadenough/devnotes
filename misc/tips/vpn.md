### Easy way to setup VPN server via docker

On server

```
OVPN_DATA="ovpn-data"
IP_ADDRESS=$(curl -s ipinfo.io | grep -Po '\d+\.\d+\.\d+\.\d+')
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_genconfig -u udp://$IP_ADDRESS:1194
docker run --volumes-from $OVPN_DATA --rm -it kylemanna/openvpn ovpn_initpki
docker run --volumes-from ovpn-data -p 1194:1194/udp --cap-add=NET_ADMIN -d kylemanna/openvpn
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_getclient client > client.ovpn
```

Local

```
scp root@<address_of_the_server>:/root/vpn/client.ovpn ~/Downloads/client.ovpn
```


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

