#!/bin/sh

# If you've non-standard directories, set these
ACLOCAL_DIR=m4
#GETTEXT_DIR=

ACLOCAL="aclocal -I$ACLOCAL_DIR"
export ACLOCAL

for dir in $GETTEXT_DIR /usr/share/gettext /usr/local/share/gettext; do
  if test -f $dir/config.rpath; then
    /bin/cp -f $dir/config.rpath .
    break
  fi
done

if test ! -f doc/wiki/Authentication.txt; then
  cd doc
  wget https://www.dovecot.org/tmp/wiki2-export.tar.gz
  tar xzf wiki2-export.tar.gz
  if [ $? != 0 ]; then
    echo "Failed to uncompress wiki docs"
    exit
  fi
  mv wiki2-export/*.txt wiki/
  rm -rf wiki2-export wiki2-export.tar.gz
  cd ..
fi

cd doc/wiki
cp -f Makefile.am.in Makefile.am
echo *.txt | sed 's, , \\/	,g' | tr '/' '\n' >> Makefile.am
cd ../..

autoreconf -i

rm -f ChangeLog
