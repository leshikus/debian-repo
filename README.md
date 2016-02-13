# debian-repo

The ligthtweight script creates and maintains signed Debian repository.
Useful to keep a standard list of packages on a number of Debain installations.

## Synopsis

Run the script to create a repository
```sh
  sh update-repo.sh /package/path /repo/path
```

## Parameters

The directory `/package/path` contains `.deb` files for repository.
The directory `/repo/path` is where the new signed repository is to be created.

## Usage

You can get `.deb` packages from the existing installation. The following command
places .deb files in `/var/cache/apt/archives`:
  
```sh
apt-get install --download-only
```

To download all packages in the system use
```sh
dpkg -l |  grep "^ii"| awk ' {print $2} ' | xargs sudo apt-get -y --force-yes install --reinstall --download-only
```

The script assumes Nginx is used for the repository provisioning.  The default `/repo/path` is `/var/www/html/repo`,
and the repository can be added to `/etc/apt/source.list` in the following form:
```sh
deb http://your_host/repo ./
```

Now you can update the packages using
```sh
wget http://your_host/repo/GPG-KEY -O - | apt-key add -
apt-get update
apt-get upgrade
```

The script may be used to add new packages to `/repo/path` and update signatures. It does not delete packages, delete them
manually if you no longer need them.

## Installation

The following script installs required packages (and requires superuser permission to run).
```sh
sh install.sh
```
