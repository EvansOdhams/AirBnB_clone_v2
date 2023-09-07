#!/usr/bin/env bash
# sets up the web servers for the deployment of web_static

# Install Nginx if it's not already installed
if ! command -v nginx &>/dev/null; then
    sudo apt-get -y update
    sudo apt-get -y install nginx
fi

# Create necessary directories if they don't exist
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create a fake HTML file for testing
echo "This is a test" | sudo tee /data/web_static/releases/test/index.html

# Create or recreate the symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership of the /data/ folder to the ubuntu user and group recursively
sudo chown -R diplomas:diplomas /data/

# Update Nginx configuration to serve content to /hbnb_static
nginx_config="location /hbnb_static/ {\n\talias /data/web_static/current/;\n}\n"
sudo sed -i "/server_name _;/a $nginx_config" /etc/nginx/sites-available/default

# Restart Nginx to apply the new configuration
sudo service nginx restart

exit 0
