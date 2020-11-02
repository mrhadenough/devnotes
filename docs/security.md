### Sign SSL cerificate

```
sudo git clone https://github.com/certbot/certbot
cd certbot
./certbot-auto -h
./certbot-auto certonly --standalone \
    -d some.domain.io \
    --non-interactive --agree-tos --email chris@example.com

# or
./certbot-auto certonly -a standalone -d example.io


# in /etc/enginx/sites-enabled/example.com.conf
ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
```

### Self sign SSL certificate
openssl req -newkey rsa:4096 -nodes -sha256 -keyout /var/www/certs/example.io.key -x509 -days 365 -out example.io.crt

### Generate pem file
`openssl genrsa -out private.pem 2048`

With passphrase
`openssl genrsa -des3 -out private.pem 2048`

Export the RSA Public Key to a File

`openssl req -new -key private.pem -x509 -days 3650 -out public.pem`

`openssl rsa -in private.pem -outform PEM -pubout -out public.pem`


### Check SSL certificate expiration

```
echo | openssl s_client -connect yourdomain.tld:443 -servername yourdomain.tld 2>/dev/null | openssl x509 -noout -dates

# check the cert file directly
openssl x509 -noout -dates -in /etc/letsencrypt/live/yourdomain.tld/cert.pem

```

In **ansible** There is no option to store passphrase-protected private key

For that we need to add the passphrase-protected private key in the `ssh-agent`

Start the `ssh-agent` in the background.

```
# eval "$(ssh-agent -s)"
```

Add SSH private key to the ssh-agent

```
# ssh-add ~/.ssh/id_rsa
```
