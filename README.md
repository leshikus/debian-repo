# debian-repo

The ligthtweight script creates and maintains signed debian repository.

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

To download all packages for particular installation use
```sh
dpkg -l |  grep "^ii"| awk ' {print $2} ' | xargs sudo apt-get -y --force-yes install --reinstall --download-only
```

To update some debian installation using your repository:
  1. Add the following lines in your /etc/apt/source.list
     deb file:///repo/path ./

     If /repo/path is avaiable on HTTP server, use
     deb http://repo/path ./

  2. Update the packages
     apt-get update
     apt-get upgrade

