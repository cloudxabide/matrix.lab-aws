# build a LAMP/bastion Host

## Overview
I deploy a bastion host with a LAMP stack to provide HTTP/HTTPS until OKD is spun-up and serving web pages.  
I also utilize LetsEncrypt to create Certs for the SSL content.


## Install and Configure the LAMP 
Assuming you're doing this on CentOS (else you need to add subscription)  

```
id -u morpheus &>/dev/null || useradd -u2025 -G10 -c "Morpheus McChicken" -p '$6$MIxbq9WNh2oCmaqT$10PxCiJVStBELFM.AKTV3RqRUmqGryrpIStH5wl6YNpAtaQw.Nc/lkk0FT9RdnKlEJEuB81af6GWoBnPFKqIh.' morpheus
usermod -a -G apache morpheus

yum -y update
yum -y install httpd php php-pear mariadb php-mysql


firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
sed -i -e 's/memory_limit = 128M/;memory_limit = 128M\nmemory_limit = 512M/g' /etc/php.ini
```

## Create vhost(s) config files
```
for VHOST in linuxrevolution.com www.linuxrevolution.com plex.linuxrevolution.com music.linuxrevolution.com
do 
# Non-SSL vhost files
cat << EOF > /etc/httpd/conf.d/${VHOST}.conf
<VirtualHost *:80>
ServerAdmin webadmin@${VHOST}
ServerName  ${VHOST}
DocumentRoot /var/www/html/${VHOST}
 
ErrorLog /var/log/httpd/${VHOST}_error.log
CustomLog /var/log/httpd/${VHOST}_access.log combined
</VirtualHost>
EOF

# SSL vhost files
cat << EOF > /etc/httpd/conf.d/${VHOST}-le-ssl.conf 
<VirtualHost *:443>
ServerAdmin webadmin@${VHOST}
ServerName  ${VHOST}
DocumentRoot /var/www/html/${VHOST}

ErrorLog /var/log/httpd/${VHOST}_error.log
CustomLog /var/log/httpd/${VHOST}_access.log combined
SSLCertificateFile /etc/letsencrypt/live/${VHOST}/cert.pem
SSLCertificateKeyFile /etc/letsencrypt/live/${VHOST}/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
SSLCertificateChainFile /etc/letsencrypt/live/${VHOST}/chain.pem
EOF

## Create Default "landing pages"
mkdir -p /var/www/html/${VHOST}
cat << EOF > /var/www/html/${VHOST}/index.html
<HTML><HEAD><TITLE> ${VHOST}| Home Page | &#169 2019</TITLE>
</HEAD>
<BODY>
Welcome to ${VHOST}
</BODY>
</HTML>
EOF

done

chown -R apache:apache /var/www/html/
find /var/www/html/ -type f -exec sudo chmod 0644 {} \;
find /var/www/html/ -type d -exec sudo chmod 0775 {} \;
restorecon -RFvv /var/www/html
```

## Safety Nets (fail2ban)
Disable Password for SSH  
Install/configure Fail2Ban  

```
cp /etc/ssh/sshd_config  /etc/ssh/sshd_config.`date +%F`
sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart sshd

# Install EPEL
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install fail2ban
systemctl enable fail2ban
cat << EOF > /etc/fail2ban/jail.d/10-sshd.conf
[sshd]
enabled = true
EOF
systemctl enable fail2ban
systemctl start fail2ban
fail2ban-client status
```

## Certifcate Automation
```
yum -y install certbot python2-certbot-apache

for VHOST in linuxrevolution.com www.linuxrevolution.com plex.linuxrevolution.com music.linuxrevolution.com
do 
  echo "/var/www/html/${VHOST}/" | ./certbot-auto certonly -d ${VHOST} --webroot
done

## Web content
So, while the redirect *should* occur via the vhost file, I create this as well...
```
cat << EOF > /var/www/html/plex.linuxrevolution.com/index.html
<HTML><HEAD><TITLE> LinuxRevolution | Plex y'all | &#169 2019</TITLE>
<META http-equiv="refresh" content="1;URL='http://plex.linuxrevolution.com:32400/'">
</HEAD>
<BODY>
Gettin after some Plex Yo...
</BODY>
</HTML>
EOF
```


