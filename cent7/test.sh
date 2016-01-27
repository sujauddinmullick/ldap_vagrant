migration_file="test1.txt"

old_DOMAIN="$DEFAULT_MAIL_DOMAIN =\"padl.com\";"
new_DOMAIN="$DEFAULT_MAIL_DOMAIN =\"msystechnologies.local\";"
sed -i 's/$old_DOMAIN/$new_DOMAIN/g' $migration_file
