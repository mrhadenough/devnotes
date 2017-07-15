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

https://help.ubuntu.com/lts/serverguide/openvpn.html

setup OpenVPN to change you IP

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-16-04
