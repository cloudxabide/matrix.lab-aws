# The Build Directory

This directory is utilized to deploy my hosts in an "old-school" fashion.  The classic "chicken-and-egg" scenario.  I need to spin up *some* infrastructure, before I can spin up the infrastrcutre, that spins up the infrastructe.  Right?

You will find

File                 | Purpose | Notes
|:-------------------|:--------|:----- 
build_KVM.sh         | This script accepts a hostname to deploy a VM referencing the "config file" | depends on: .myconfig
.myconfig            | Contains parameters/specifications to build a VM | The format is in the file
finish-(hostname).sh | This script should be run post build to deploy the "app stack" on the host | 
HOSTNAME.ks          | This is the Kickstart file used to do the initial build of the host
post-install.sh      | N/A at this time | This file will contain post-install tasks that are universal for all hosts
