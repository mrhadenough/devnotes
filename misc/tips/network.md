### Network stuff

connected devices in your network

`arp -a`

find ip for the website

`nslookup <host>`

more advanced lookup

`dig <host>`

### list of used ports and PIDs

on linux

`netstat -pltn`

on mac or linux

`netstat -vanp tcp`

`lsof -i -P | grep -i "listen"`

`lsof -n -i4TCP:8000 | grep LISTEN`

find proceess by name and show which files it uses

`lsof -c Paw | awk '{print $7}'`

`kill -9 $(lsof -t /path/to/blocked/file)`

### Get my IP

```
curl icanhazip.com
curl -s 'http://checkip.dyndns.org' | sed 's/.*Current IP Address: \([0-9\.]*\).*/\1/g'
host -t a dartsclink.com | sed 's/.*has address //'
curl curlmyip.com
curl ifconfig.me # this has a lot of different alternatives too, such as ifconfig.me/host
```

### check if port is open

`nmap -p 80 host.com`

### scan IP range

`nmap -sn 10.10.10.10./24`
`nmap -sP 46.101.244.159-161` using dash to set range

### port scanner

`sudo nmap -PU 10.10.10.10`

`nmap -Pn -p- 192.223.250.145-158` - scan all ports

### Make simple http server using python:

`sudo python -m SimpleHTTPServer 80`

### for python 3.x version, you may need :

`sudo python -m http.server 80`

### Flush DNS

windows

`ipconfig /flushdns`

mac

`killall -HUP mDNSResponder`

mac yosemite

`sudo discoveryutil udnsflushcaches`

linux

`nscd -i hosts`

### Know DNS

mac

`scutil --dns`

linux

`cat /etc/resolv.conf`

### Download file from ssh

```
scp your_username@remotehost.edu:foobar.txt /local/dir
scp ubuntu@54.174.38.155:/tmp/157.json /Users/napalm/Downloads/
scp -i ~/Downloads/taras-scan.pem /Users/napalm/Downloads/client1.key ubuntu@54.210.101.40:/tmp/client1.key
scp root@188.166.2.13:/data/sonar_reports/495.db ~/Downloads/495.db
```

### Make http request and format json

`curl -uUSER:PASS -s -XGET -H "Accept: application/json" https://my-host.squarespace.com/api/rest/commerce/contributions\?offset\=0\&limit\=10 | python -mjson.tool`

### Postgresql via ssh tunnel

```
ssh -i key.pem -N -L 1111:127.0.0.1:5432 remote_user@remote.server.com
psql -h 127.0.0.1 -p 1111 -U your-db-username database-name
```
