#!/bin/bash

# Purpose:  Scripted addition of forwarding zones to freeIPA
# Status:   Development yet - untested

AWS_r53_ENDPOINTS="10.0.0.81 10.0.1.69 10.1.0.91 10.1.1.162"


ipa dnsforwardzone-add ec2.internal. --forwarder=10.0.0.81 --forwarder=10.1.0.91 --forward-policy=first
ipa dnsforwardzone-mod --forward-policy=only ec2.internal

ipa dnsforwardzone-show  ec2.internal
nslookup ip-10-0-0-81.ec2.internal
nslookup ip-10-0-0-123.ec2.internal

# Disable DNSSEC (temporary, hopefully?)...
cp /etc/named.conf /etc/named.conf.`date +%F`
sed -i -e 's/dnssec-enable yes/dnssec-enable no/g' /etc/named.conf
sed -i -e 's/dnssec-validation yes/dnssec-validation no/g' /etc/named.conf
ipactl restart
