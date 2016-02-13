# debian-repo

The ligthtweight script creates and maintains signed Debian repository.
Useful to keep a standard list of packages on a number of Debain installations.

## Usage

Run the script to create a repository
```sh
  sh update-repo.sh /package/path /repo/path
```

## Parameters

The directory `/package/path` contains `.deb` files for repository.
The directory `/repo/path` is where new signed repository is to be created.

## Notes

The script does not delete packages from `/repo/path`, delete them
manually if you no longer need them.

You can get `.deb` packages from the existing installation. The following command
places .deb files in `/var/cache/apt/archives`:
  
```sh
apt-get install --download-only
```

To download all packages for in the system use
```sh
dpkg -l |  grep "^ii"| awk ' {print $2} ' | xargs sudo apt-get -y --force-yes install --reinstall --download-only
```

To update some debian installation using your repository in `/etc/apt/source.list` the following lines
```sh
deb file:///repo/path ./
```
If `/repo/path` is avaiable on HTTP server, use
```sh
deb http://repo/path ./
```

Now you can update the packages using
```sh
apt-get update
apt-get upgrade
```

