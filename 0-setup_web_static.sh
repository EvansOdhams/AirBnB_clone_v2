#!/usr/bin/env bash

# Install Nginx if not already installed
if ! dpkg -l | grep -q nginx; then
    sudo apt-get -y update
    sudo apt-get -y install nginx
fi

# Create necessary directories if they don't exist
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/

# Create a fake HTML file for testing
echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" | sudo tee /data/web_static/releases/test/index.html

# Create or recreate the symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership of the /data/ folder to the ubuntu user and group recursively
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration to serve the content of /data/web_static/current/
# to hbnb_static using alias
config_content=$(cat <<EOF
location /hbnb_static {
    alias /data/web_static/current/;
}
EOF
)

# Remove the default symbolic link created by Nginx
sudo rm -f /etc/nginx/sites-enabled/default

# Create a new Nginx configuration file for the hbnb_static location
echo "$config_content" | sudo tee /etc/nginx/sites-available/hbnb_static

# Create a symbolic link to enable the new configuration
sudo ln -sf /etc/nginx/sites-available/hbnb_static /etc/nginx/sites-enabled/

# Restart Nginx to apply changes
sudo service nginx restart
