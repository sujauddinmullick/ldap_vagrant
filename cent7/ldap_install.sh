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
conf_ldif= $base_dir"cn=config.ldif"
monitor_ldif=$base_dir"cn=config/olcDatabase={1}monitor.ldif"

#make sure the system is up to date, and install ldap packages

yum update -y
yum install openldap openldap-servers openldap-clients vim httpd -y

#Add following section in config.ldif file

echo -e "olcConnMaxPending: 100 \nolcConnMaxPendingAuth: 1000 \nolcIdleTimeout: 180 \n" >> $conf_ldif
"""
#modify this file to add domain /etc/openldap/slapd.d/cn=config/olcDatabase=
#{1}monitor.ldif

sed -i 's/Manager/root/g' $monitor_ldif
sed -i 's/my-domain/msystechnologies/g' $monitor_ldif
sed -i 's/com/local/g' $monitor_ldif

#Copy the final encrypted output "slappasswd" for use in the olcPW section in 
#olcDatabase={2}hdb.ldif file in /etc/openldap/slapd.d/cn=config directory

{ echo "olcRootPW: "; slappasswd -s mst12345; } | sed -e 'N;s/\n/ /' >> $hdb_file

#Now test the configuration

slaptest -u

if [ $? == 0 ]; then
   echo "\nldap config file test succeeded\n"
fi
   echo $?
   echo "\nldap config file test failed\n"
   exit 1

# Unit-test done till here.  


#create self signed cert

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
   exit 1

#we need to import schemas.

ldapadd -Y EXTERNAL -H ldapi:// -f  /etc/openldap/schema/core.ldif
ldapadd -Y EXTERNAL -H ldapi:// -f  /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:// -f  /etc/openldap/schema/nis.ldif


# check how pwd can be passed?
ldapadd -x -W -D "cn=root,dc=msystechnologies,dc=local" -f /vagrant/base.ldif

yum install migrationtoools -y

#we need to modify migrate_common.ph file for our domain

/usr/share/migrationtools/migrate_passwd.pl /etc/passwd people.ldif

/usr/share/migrationtools/migrate_passwd.pl /etc/group group.ldif



#Now import these users to ldap
ldapadd -xWD "cn=root,dc=msystechnologies,dc=local" -f people.ldif
ldapadd -xWD "cn=root,dc=msystechnologies,dc=local" -f group.ldif
"""
