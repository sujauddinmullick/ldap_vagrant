#!/usr/bin/env bash

###########################################################
#This script is intended to install and configure openldap
#server on "cent os 7 x64" machine. Originally this script 
#is called by vagrant file to automate VM provisioning.
#
#Copywright @Msystechnologies.com
#Author suja.uddin@msystechnologies.com
#Date 22/01/2016
###########################################################


base_dir="/etc/openldap/slapd.d/"
hdb_file=$base_dir"cn=config/olcDatabase={2}hdb.ldif"
conf_ldif="/etc/openldap/slapd.d/cn=config.ldif"
monitor_ldif=$base_dir"cn=config/olcDatabase={1}monitor.ldif"

#make sure the system is up to date, and install ldap packages

yum update -y
yum install openldap openldap-clients vim nss-pam-ldapd.x86_64 -y

#configure ldap client

authconfig --enableldap --enableldapauth --ldapserver=ldap://172.30.36.128:1389 --ldapbasedn="dc=msystechnologies,dc=local" --enablemkhomedir --enablemd5 --kickstart --update


