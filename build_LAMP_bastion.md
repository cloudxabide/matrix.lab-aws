# build a LAMP/bastion Host


```
cat << EOF > /etc/httpd/conf.d/www.linuxrevolution.com.conf

<VirtualHost *:80>
ServerAdmin webadmin@linuxrevolution.com
ServerName  www.linuxrevolution.com
DocumentRoot /var/www/html/www.linuxrevolution.com

ErrorLog /var/log/httpd/www.linuxrevolution.com_error.log
CustomLog /var/log/httpd/www.linuxrevolution.com_access.log combined

RewriteEngine On
RewriteCond %{HTTPS} off [OR]
RewriteCond %{HTTP_HOST} ^www\. [NC]
RewriteCond %{HTTP_HOST} ^(?:www\.)?(.+)$ [NC]
RewriteRule ^ https://%1%{REQUEST_URI} [L,NE,R=301]

#RewriteEngine on
#RewriteCond %{SERVER_NAME} =www.linuxrevolution.com
#RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>
EOF
