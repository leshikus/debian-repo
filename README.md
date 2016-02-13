# debian-repo

The ligthtweight script creates and maintains signed debian repository.

Usage: run the script to create a repository
  sh update-repo.sh /package/path /repo/path

where
  /package/path a directory which contains .deb files for repository
                apt-get install --download-only places .deb files under
                /var/cache/apt/archives

  /repo/path    a directory where new signed repository is to be created

Notes
  The script does not delete packages from /repo/path, delete them
  manually if you no longer need them.

  To update some debian installation using your repository:
  1. Add the following lines in your /etc/apt/source.list
     deb file:///repo/path ./

     If /repo/path is avaiable on HTTP server, use
     deb http://repo/path ./

  2. Update the packages
     apt-get update
     apt-get upgrade

