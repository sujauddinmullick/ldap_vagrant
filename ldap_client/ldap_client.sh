#!/usr/bin/env bash

###########################################################
#This script is intended to install and configure openldap
#client on "cent os 7 x64" machine. Originally this script 
#is called by vagrant file to automate VM provisioning.
#
#Copywright @Msystechnologies.com
#Author suja.uddin@msystechnologies.com
#Date 22/01/2016
###########################################################



#make sure the system is up to date, and install ldap packages

yum update -y
yum install openldap openldap-clients vim nss-pam-ldapd.x86_64 -y

#configure ldap client

authconfig --enableldap --enableldapauth --ldapserver=ldap://172.30.36.128:1389 --ldapbasedn="dc=msystechnologies,dc=local" --enablemkhomedir --enablemd5 --kickstart --update


