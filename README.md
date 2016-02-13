# debian-repo

The ligthtweight script creates and maintains signed debian repository.

Usage: run the script to create a repository
  sh update-repo.sh package_dir repo_dir

where
  package_dir  a directory which contains .deb files for repository
               apt-get install --download-only places .deb files under
               /var/cache/apt/archives

  repo_dir     a directory where new signed repository is to be created
               you can expose this directory via web server and
               specify deb http://server_address/repo_dir ./ in
               /etc/apt/sources.list

Notes
  The script does not delete packages from the package_dir, delete them
  manually if you no longer need them.
