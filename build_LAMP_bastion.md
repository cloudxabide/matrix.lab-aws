# build a LAMP/bastion Host

## Overview
I deploy a bastion host with a LAMP stack to provide HTTP/HTTPS until OKD is spun-up and serving web pages.  
I also utilize LetsEncrypt to create Certs for the SSL content.


## Install and Configure LAMP and libreNMS
NOTE: Assuming you're doing this on CentOS (else you need to add subscription)  
- Install CentOS 7 on your host  
- run the ["finish script"](Build/finish_co7-nms-srv01.sh)
- reboot
- create a CNAME for "librenms" -> co7-nms-srv01 on co7-ipa-srv01.matrix.lab  
- login to the portal (http://librenms.matrix.lab) and start adding hosts


 


