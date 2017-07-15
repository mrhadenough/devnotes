
http://www.zabrosov.ru/ - usefull cmd

### Add swap to ubuntu

```
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# to see
swapon --show
```

### Install Ansible for ubuntu

```
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
```

### Install PostreSQL

`sudo apt-get install

resql postgresql-contrib`

### Install Nginx

`sudo apt-get install nginx`

### ntfs mount with permissions

`vim /etc/fstab`

`/dev/sda2 /mnt/excess ntfs-3g permissions,locale=en_US.utf8 0a 2`

### install oracle java 8 (fix fonts in intelij idea)

`sudo add-apt-repository ppa:webupd8team/java`

### Gnome 3 tiny title borders

Open a terminal window

`sudo sed -i "/title_vertical_pad/s/value=\"[0-9]\{1,2\}\"/value=\"0\"/g" /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml`

Close terminal window

Hit ALT-F2

type restart

hit enter

### Gnome 3 lag fix

tracker monitor http://askubuntu.com/a/353450

`sudo sed -i "s/X-GNOME-Autostart-enabled=true/X-GNOME-Autostart-enabled=false/g" /etc/xdg/autostart/tracker-*`

### Cent OS install addition repositories

`sudo yum install epel-release`

`yum repolist`

### kill process by name

```
kill -9 $(ps | grep <searchname> | grep <searchname2> | cut -f 1 -d ' ')
ps aux | grep 'celery worker' | awk '{print $2}' | xargs kill -9
killall <nameofprocess>
```

### Redis GUI

```
gem install redis-browser
redis-browser --url redis://127.0.0.1:6379/0
```

### Restore deleted files

`sudo extundelete /dev/sda5 --restore-directory /path/to/dir`

### Fix ntfs issue: Operation not permitted The NTFS partition is in an unsafe state

`sudo ntfsfix /dev/XY`


### Install Blender with Cycles and CUDA

Proprietary nvidia

`sudo apt-add-repository ppa:ubuntu-x-swat/x-updates`

PPA for Blender

`sudo add-apt-repository ppa:thomas-schiex/blender`

Update..

`sudo apt-get update`

Install

`sudo apt-get install nvidia-current nvidia-modprobe blender`


### Scrollable 'tail' command

`less <filepath>`

press shift+g

### Decode base64 and as hex
`echo "aGVsbG8=" | base64 --decode | hexdump -C`

### Send self ip address to another server
`while true; do host=$(curl -s http://checkip.dyndns.org | grep -P -o "(\d+\.)*\d+"); curl -H "Content-Type: application/json" -X POST -d "{\"host\": \"$host\"}" http://kostyadev.ngrok.io; sleep 1; done`

### Install pip dependency for jupiter
```
import pip

def install(package):
   pip.main(['install', package])

install('pymongo==3.3.0')
```
