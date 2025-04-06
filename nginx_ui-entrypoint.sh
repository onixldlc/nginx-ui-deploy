#!/bin/sh

# if nginx folder is empty then copy default files
if [ -z "$(ls -A /etc/nginx)" ]; then
    echo "Copying default nginx configuration files..."
    cp -r /etc/nginx-default/* /etc/nginx/
fi

# add all the config to the available sites
cp /sites/default.conf /etc/nginx/sites-available/default
cp /sites/nginx-ui.conf /etc/nginx/sites-available/nginx-ui

# if env SERVER_NAME is set then replace the nginx-ui server_name and enable it
if [ -n "$SERVER_NAME" ]; then
    echo "Setting server_name to $SERVER_NAME"
    sed -i "s/localhost/$SERVER_NAME/" /etc/nginx/sites-available/nginx-ui
fi

# enable the default sites
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/nginx-ui /etc/nginx/sites-enabled/nginx-ui

# start nginx
echo "Starting nginx..."
nginx &

# start nginx-ui
echo "Starting nginx-ui..."
/usr/local/bin/nginx-ui