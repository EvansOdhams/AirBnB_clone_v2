#!/usr/bin/python3
"""
Fabric script that deletes out-of-date archives using the function do_clean
"""

from fabric.api import env, run, local, put
from datetime import datetime
from os import path

env.hosts = ['<IP web-01>', '<IP web-02>']
env.user = 'ubuntu'  # Update with your SSH username
env.key_filename = 'my_ssh_private_key'  # Update with your private key file path
env.use_ssh_config = True

def do_clean(number=0):
    """
    Deletes out-of-date archives from versions and releases folders
    """
    number = int(number)
    if number < 1:
        number = 1

    local_archives = sorted(local("ls -1t versions", capture=True).split('\n'))
    archives_to_delete = local_archives[number:]

    for archive in archives_to_delete:
        local("rm -f versions/{}".format(archive))

    remote_releases = run("ls -1t /data/web_static/releases").split('\n')
    releases_to_delete = remote_releases[number:]

    for release in releases_to_delete:
        release_path = "/data/web_static/releases/{}".format(release)
        run("rm -rf {}".format(release_path))

if __name__ == '__main__':
    current_time = datetime.now().strftime("%Y%m%d%H%M%S")
    archive_name = "web_static_{}.tgz".format(current_time)

    # Create a new archive and upload it to the server
    local("tar -czvf versions/{} web_static".format(archive_name))
    put("versions/{}".format(archive_name), "/tmp/{}".format(archive_name))
    
    # Call do_clean with the desired number of archives to keep (e.g., 2)
    do_clean(2)

    # Clean up temporary local archive
    local("rm -f versions/{}".format(archive_name))
