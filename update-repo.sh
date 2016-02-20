#!/bin/sh

set -e
umask 022

dir=`dirname "$0"`
dir=`cd "$dir"; pwd -P`

from=${1:-"$dir"/../packages}
to=${2:-/var/www/html/repo}

parse_parameters() {
  for deb in "$from"/*.deb
  do
    test -f "$deb" || {
      echo No .deb packages in "$from"
      exit 1
    }
    break
  done

  from=`cd "$from"; pwd -P`
  to=`mkdir -p "$to"; cd "$to"; pwd -P`

  date >"$to"/timestamp
}

clean_deb_signatures() {
  ar d "$1" `ar t "$1" | grep '^_gpg'`
}

get_key() {
  gpg --list-keys | awk 'NR == 3 { sub(/.*\//, "", $2); print $2 }'
}

gen_key() {
  key=`get_key`
  if test -z "$key"
  then
    gpg --import "$dir"/rsa.gpg
    key=`get_key`
  fi

  cd "$to"
  rm -f GPG-KEY
  gpg --output GPG-KEY --armor --export $key
}


sign_repo() {
  cd "$to"
  apt-ftparchive packages . >Packages
  gzip -9c <Packages >Packages.gz
  bzip2 -c <Packages >Packages.bz2

  apt-ftparchive release . >Release

  rm -f InRelease Release.gpg
  gpg --clearsign -o InRelease Release
  gpg -abs -o Release.gpg Release
}

copy_new_packages() (
  added=0
  cd "$from"
  for deb in *.deb
  do
    to_deb="$to/$deb"
    test -f "$to_deb" || {
      cp --no-preserve=all "$deb" "$to_deb"
      clean_deb_signatures "$to_deb"
      dpkg-sig --sign builder "$to_deb"
      added=`expr $added + 1`
    }
  done
  if expr $added
  then
    echo "Added $added packages"
  else
    echo No new .deb packages in "$from"
    exit 1
  fi
)

parse_parameters
gen_key
copy_new_packages
sign_repo
 
