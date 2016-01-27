# ldap server uses cent7 directory and ldap client uses ldap_client directory.

#How to start vagrant:
#Server:
1. go to cent7 directory
2. modify the Vagrantfile as per your rerquirement
2. run vagrant up --provision
#Client:
1. go to ldap_client directory
2. modify the Vagrantfile as per your requirement
2. run vagrant up --provision

Now ldap server and ldap client are up in vagrant boxes.
disable the firewall in both the machine as well as host machine. 

# ldap_vagrant
