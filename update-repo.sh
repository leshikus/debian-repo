#!/bin/sh

set -e
cd `dirname "$0"`

from=${1:-../packages}
to=${2:-../repo}
key=

from=`cd "$from"; pwd -P`
to=`mkdir -p "$to"; cd "$to; pwd -P`

clean_deb_signatures() {
  signatures=`ar t "$1" | grep '^_gpg'`
  ar d "$1" $signatures
}

get_key() {
  gpg --list-keys | awk 'NR == 3 { sub(/.*\//, "", $2); print $2 }'
}

gen_key() {
  cd "$to"

  key=`get_key`
  if test -z "$key"
  then
    gpg --gen-key gen-key.conf
    key=`get_key`
  fi

  rm -f GPG-KEY
  gpg --output GPG-KEY --armor --export $key
}


sign_repo() {
  cd "$to"
  apt-ftparchive packages . >Packages
  gzip -9c <Packages >Packages.gz
  bzip2 -c <Packages >Packages.bz2

  apt-ftparchive release . >Release
  gpg --clearsign -o InRelease Release
  gpg -abs -o Release.gpg Release
}

copy_new_packages() (
  cd "$from"
  for deb in *.dev
  do
    to_deb="$to/$deb"
    test -f "$to_deb" || {
      clean_deb_signatures "$deb"
      cp "$deb" "$to_deb"
      dpkg-sig --sign builder "$to_deb"
    }
  done
)

copy_new_packages
gen_key
sign_repo
 
