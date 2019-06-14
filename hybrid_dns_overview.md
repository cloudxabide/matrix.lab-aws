# Hybrid DNS

## Overview
Hybrid DNS has been one of the more challenging aspects of a hybrid cloud architecture.  I feel this is due to a number of factors:
* highly personalized based on the approach a person (company) has become familiar  
* there are so many possible ways to "do it right" (too many options make *any* option difficult to chose)  
*

So - for my example hybrid cloud I have an on-prem environment (legacy) and my new shiny #awsome cloud hosted by AWS.

I use several Top-Level Domains for public access (as well as on-prem) and tertiary domains for testing

domain                   | location   | DNS provider   | purpose
:------------------------|:----------:|:---------------|:------
cloudXabide.com          | N/A        | route 53       | Parent domain for public presence 
awscloud.cloudXabide.com | AWS cloud  | route 53       | Provide DNS resolution for publicly accessible AWS cloud end-points
linuxrevolution.com      | Homelab    | route 53       | Parent domain for publicly accessible on-prem end-points
matrix.lab               | Homelab    | freeIPA        | Parent domain for Homelab resources (internal only)
CORP.matrix.lab          | Homelab    | Windows AD     | Domain for Homelab Windows Domain resources (internal only)

## cloudXabide.com
Domain I use for public testing 

### awscloud.cloudXabide.com
Tertiary domain used to identify resources hosted AWS cloud

## matrix.lab
Parent domain I use for all of my Homelab hosts

### CORP.matrix.lab
Tertiary domain created to test Windows AD integration and provide AD Domain Services

## linuxrevolution.com 
TLD I use for my a public presence for Linux (on-prem) testing  
Public website (http redirect to blog)  
VPN end-point  
Plex server (http redirect to blog)   
