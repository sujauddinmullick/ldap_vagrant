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

#yum update -y
yum install openldap openldap-servers openldap-clients vim httpd -y

#Add following section in config.ldif file
echo $conf_ldif
echo -e "olcConnMaxPending: 100 \nolcConnMaxPendingAuth: 1000 \nolcIdleTimeout: 180 \n" >> "${conf_ldif}"


sed -i 's/Manager/root/g' $monitor_ldif
sed -i 's/my-domain/msystechnologies/g' $monitor_ldif
sed -i 's/com/local/g' $monitor_ldif

sed -i 's/Manager/root/g' $hdb_file
sed -i 's/my-domain/msystechnologies/g' $hdb_file
sed -i 's/com/local/g' $hdb_file

{ echo "olcRootPW: "; slappasswd -s mst12345; } | sed -e 'N;s/\n/ /' >> $hdb_file

yum install migrationtoools -y

mkdir /etc/openldap/ssl

openssl req -new -x509 -nodes -out /etc/openldap/ssl/slapdcert.pem -keyout /etc/openldap/ssl/slapdkey.pem -days 365 -subj "/C=IN/ST=TN/L=Chennai/O=Company Ltd/OU=section/CN=msystechnologies.local"

# Unit-test done till here. 
chown -Rf root:ldap /etc/openldap/ssl
chmod -Rf 750 /etc/openldap/ssl

#start slapd service 

systemctl start slapd

if [ $? == 0 ]; then
   echo "\nslapd startup succeeded\n"
fi
   echo "\nslapd startup failed\n"
                                 
ldapadd -Y EXTERNAL -H ldapi:// -f  /etc/openldap/schema/core.ldif
ldapadd -Y EXTERNAL -H ldapi:// -f  /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:// -f  /etc/openldap/schema/nis.ldif


ldapadd -x -w mst12345 -D "cn=root,dc=msystechnologies,dc=local" -f /vagrant/base.ldif 


