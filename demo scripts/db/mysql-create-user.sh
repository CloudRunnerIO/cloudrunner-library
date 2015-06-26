# Expected env variables:
ROOTPASS=""
if [ -n "$ROOTPASS" ]; then
	ROOTPASS="-p$ROOTPASS"
fi
# Optional:
# $DBNAME, $DBUSER, $USERPASS

if [ -n "DBNAME" ]; then
	echo "CREATE DATABASE $DBNAME;" | mysql -u root $ROOTPASS 2&>1 || echo "$DBNAME already exists"
fi
if [ -n "$DBUSER" ]; then
	echo "CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$USERPASS';" | mysql -u root $ROOTPASS 2&>1 || echo "$DBUSER already exists"
fi
if [ -n "$DBNAME" && -n "$DBUSER" ]; then
	echo "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';" | mysql -u root $ROOTPASS
fi
echo "FLUSH PRIVILEGES;" | mysql -u root $ROOTPASS
echo "Done"
