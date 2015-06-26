# Target OS: Ubuntu/Debian

# Expected env variables:
dbname=$(DBNAME:-wordpress)
dbuser=$(DBUSER:-wpuser)
wpURL=$(SITENAME:-localhost)
userpass=$(USERPASS:-some secret)

# Install prerequisites
apt-get install -y apache2 wget

# Download, unpack and configure WordPress
wget -q -O - "http://wordpress.org/latest.tar.gz" | tar -xzf - -C /var/www --transform s/wordpress/$wpURL/
chown www-data: -R /var/www/$wpURL && cd /var/www/$wpURL
cp wp-config-sample.php wp-config.php
chmod 640 wp-config.php
mkdir uploads
sed -i "s/database_name_here/$dbname/;s/username_here/$dbuser/;s/password_here/$userpass/" wp-config.php

# Create Apache virtual host
echo "
ServerName $wpURL
ServerAlias www.$wpURL
DocumentRoot /var/www/$wpURL
DirectoryIndex index.php

Options FollowSymLinks
AllowOverride All

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
" > /etc/apache2/sites-available/$wpURL

# Enable the site
a2ensite $wpURL
service apache2 restart

# Output
WPVER=$(grep "wp_version = " /var/www/$wpURL/wp-includes/version.php |awk -F\' '{print $2}')
echo -e "\nWordPress version $WPVER is successfully installed!"
echo -en "\aPlease go to http://$wpURL and finish the installation\n"
