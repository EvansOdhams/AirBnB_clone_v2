# Puppet manifest for setting up web servers

# Ensure the Nginx package is installed
package { 'nginx':
  ensure => installed,
}

# Create necessary directories
file { ['/data', '/data/web_static', '/data/web_static/releases', '/data/web_static/shared', '/data/web_static/releases/test']:
  ensure => 'directory',
  recurse => true,
  owner => 'root',
  group => 'root',
  mode => '0755',
}

# Create a test HTML file
file { '/data/web_static/releases/test/index.html':
  ensure => 'file',
  content => '<html>\n  <head>\n  </head>\n  <body>\n    Holberton School\n  </body>\n</html>',
  owner => 'root',
  group => 'root',
  mode => '0644',
}

# Create a symbolic link
file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test',
  owner => 'root',
  group => 'root',
}

# Configure Nginx to serve web_static content
file { '/etc/nginx/sites-available/default':
  ensure => 'file',
  source => 'puppet:///modules/web_static/default',
  notify => Service['nginx'],
}

# Ensure Nginx is running and enabled
service { 'nginx':
  ensure => 'running',
  enable => true,
}

