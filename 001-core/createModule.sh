#!/bin/sh
MODULENAME=001-core

source "$PWD/../builder-utils/setflags.sh"

SetFlags "$MODULENAME"

source "$PWD/../builder-utils/cachefiles.sh"
source "$PWD/../builder-utils/downloadfromslackware.sh"
source "$PWD/../builder-utils/genericstrip.sh"
source "$PWD/../builder-utils/helper.sh"
source "$PWD/../builder-utils/latestfromgithub.sh"

### create module folder

mkdir -p $MODULEPATH/packages > /dev/null 2>&1

### download packages from slackware repositories

DownloadFromSlackware

### packages outside slackware repository

currentPackage=sysvinit
version=3.08
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
cp $SCRIPTPATH/extras/${currentPackage}/* .
wget https://github.com/slicer69/sysvinit/releases/download/$version/sysvinit-$version.tar.xz -O ${currentPackage}-$version.tar.gz || exit 1
sh ${currentPackage}.SlackBuild || exit 1
rm -fr $MODULEPATH/${currentPackage}

# temporary to build procps
installpkg $MODULEPATH/packages/ncurses*.txz || exit 1

currentPackage=procps
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
cp $SCRIPTPATH/extras/${currentPackage}/* .
version=$(curl -s https://gitlab.com/${currentPackage}-ng/${currentPackage}/-/tags?format=atom | grep ' <title>' | grep -v rc | sort -V -r | head -1 | cut -d '>' -f 2 | cut -d '<' -f 1)
sed -i "s|VERSION=\${VERSION.*|VERSION=\${VERSION:-${version//[vV]}}|g" ${currentPackage}.SlackBuild
wget https://gitlab.com/${currentPackage}-ng/${currentPackage}/-/archive/${version}/${currentPackage}-${version}.tar.gz
sh ${currentPackage}.SlackBuild || exit 1
rm -fr $MODULEPATH/${currentPackage}
rm -fr $MODULEPATH/package-${currentPackage}

currentPackage=neofetch
mkdir -p $MODULEPATH/${currentPackage}/package/usr/bin && cd $MODULEPATH/${currentPackage}
wget https://github.com/hykilpikonna/hyfetch/archive/refs/heads/master.zip -O ${currentPackage}.zip || exit 1
unzip ${currentPackage}.zip
rm ${currentPackage}.zip
cp -p */${currentPackage} package/usr/bin
sed -i "s|has pkginfo && tot pkginfo -i|#has pkginfo && tot pkginfo -i|g" package/usr/bin/${currentPackage}
chown 755 package/usr/bin/${currentPackage}
chmod +x package/usr/bin/${currentPackage}
version=$(date -r package/usr/bin/${currentPackage} +%Y%m%d)
cd $MODULEPATH/${currentPackage}/package
/sbin/makepkg -l y -c n $MODULEPATH/packages/${currentPackage}-$version-noarch-1.txz > /dev/null 2>&1
rm -fr $MODULEPATH/${currentPackage}

currentPackage=p7zip
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
wget -r -nd --no-parent $SLACKBUILDREPOSITORY/system/${currentPackage}/ -A * || exit 1
info=$(DownloadLatestFromGithub "p7zip-project" ${currentPackage})
version=${info#* }
filename=${info% *}
sed -i "s|make |make -j${NUMBERTHREADS} |g" ${currentPackage}.SlackBuild
sed -i "s|VERSION=\${VERSION.*|VERSION=\${VERSION:-$version}|g" ${currentPackage}.SlackBuild
sed -i "s|TAG=\${TAG:-_SBo}|TAG=|g" ${currentPackage}.SlackBuild
sed -i "s|PKGTYPE=\${PKGTYPE:-tgz}|PKGTYPE=\${PKGTYPE:-txz}|g" ${currentPackage}.SlackBuild
sed -i "s|-O2 |-O3 -march=${ARCHITECTURELEVEL} -s -flto |g" ${currentPackage}.SlackBuild
sh ${currentPackage}.SlackBuild || exit 1
mv /tmp/${currentPackage}*.t?z $MODULEPATH/packages
rm -fr $MODULEPATH/${currentPackage}

currentPackage=pptp
version=1.10.0
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
wget -r -nd --no-parent $SLACKBUILDREPOSITORY/network/${currentPackage}/ -A * || exit 1
wget http://downloads.sourceforge.net/pptpclient/pptp-$version.tar.gz || exit 1
sed -i "s|VERSION=\${VERSION.*|VERSION=\${VERSION:-$version}|g" ${currentPackage}.SlackBuild
sed -i "s|TAG=\${TAG:-_SBo}|TAG=|g" ${currentPackage}.SlackBuild
sed -i "s|PKGTYPE=\${PKGTYPE:-tgz}|PKGTYPE=\${PKGTYPE:-txz}|g" ${currentPackage}.SlackBuild
sed -i "s|-O2 |-O3 -march=${ARCHITECTURELEVEL} -s -flto |g" ${currentPackage}.SlackBuild
sh ${currentPackage}.SlackBuild || exit 1
mv /tmp/${currentPackage}*.t?z $MODULEPATH/packages
rm -fr $MODULEPATH/${currentPackage}

currentPackage=unrar
version=7.0.7
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
wget -r -nd --no-parent $SLACKBUILDREPOSITORY/system/${currentPackage}/ -A * || exit 1
wget https://www.rarlab.com/rar/unrarsrc-$version.tar.gz || exit 1
sed -i "s|make |make -j${NUMBERTHREADS} |g" ${currentPackage}.SlackBuild
sed -i "s|VERSION=\${VERSION.*|VERSION=\${VERSION:-$version}|g" ${currentPackage}.SlackBuild
sed -i "s|TAG=\${TAG:-_SBo}|TAG=|g" ${currentPackage}.SlackBuild
sed -i "s|PKGTYPE=\${PKGTYPE:-tgz}|PKGTYPE=\${PKGTYPE:-txz}|g" ${currentPackage}.SlackBuild
sed -i "s|-O2 |-O3 -march=${ARCHITECTURELEVEL} -s -flto |g" ${currentPackage}.SlackBuild
sed -i "s|-j1 ||g" ${currentPackage}.SlackBuild
sed -i "s|libunrar.so.5|libunrar.so.7|g" ${currentPackage}.SlackBuild
sh ${currentPackage}.SlackBuild || exit 1
mv /tmp/${currentPackage}*.t?z $MODULEPATH/packages
rm -fr $MODULEPATH/${currentPackage}

currentPackage=duktape
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
cp $SCRIPTPATH/extras/${currentPackage}/* .
sh ${currentPackage}.SlackBuild || exit 1
rm -fr $MODULEPATH/${currentPackage}

currentPackage=polkit
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
wget -r -nd --no-parent -l1 http://ftp.slackware.com/pub/slackware/slackware64-current/source/l/${currentPackage}/ || exit 1
sed -i "s|Djs_engine=mozjs|Djs_engine=duktape|g" ${currentPackage}.SlackBuild
sed -i "s|Dman=true|Dman=false|g" ${currentPackage}.SlackBuild
sh ${currentPackage}.SlackBuild || exit 1
mv /tmp/${currentPackage}*.t?z $MODULEPATH/packages
rm -fr $MODULEPATH/${currentPackage}

### packages that require specific stripping

currentPackage=aaa_libraries
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
mv ../packages/${currentPackage}-[0-9]* .
version=`ls * -a | cut -d'-' -f2- | sed 's/\.txz$//'`
ROOT=./ installpkg ${currentPackage}-*.txz
mkdir ${currentPackage}-stripped-$version
cp --parents -P lib64/libfuse.* ${currentPackage}-stripped-$version/
cp --parents -P lib64/libgssapi_krb5.* ${currentPackage}-stripped-$version/
cp --parents -P lib64/libk5crypto.* ${currentPackage}-stripped-$version/
cp --parents -P lib64/libkrb5.* ${currentPackage}-stripped-$version/
cp --parents -P lib64/libkrb5support.* ${currentPackage}-stripped-$version/
cp --parents -P lib64/libsigsegv.* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib64/libatomic.* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib64/libcares.* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib64/libcups.* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib64/libgcc_s.* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib64/libgmp.* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib64/libgmpxx.* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib64/libgomp.* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib64/libltdl.* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib64/libslang.* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib64/libstdc++.so.6* ${currentPackage}-stripped-$version/
cd $MODULEPATH/${currentPackage}/${currentPackage}-stripped-$version
/sbin/makepkg -l y -c n $MODULEPATH/packages/${currentPackage}-stripped-$version.txz > /dev/null 2>&1
rm -fr $MODULEPATH/${currentPackage}

if [ $SLACKWAREVERSION == "current" ]; then
	currentPackage=avahi
	mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
	mv ../packages/${currentPackage}-[0-9]* .
	version=`ls * -a | cut -d'-' -f2- | sed 's/\.txz$//'`
	ROOT=./ installpkg ${currentPackage}-*.txz
	mkdir ${currentPackage}-stripped-$version
	cp --parents -P usr/lib64/libavahi-client.* ${currentPackage}-stripped-$version/
	cp --parents -P usr/lib64/libavahi-common.* ${currentPackage}-stripped-$version/
	cp --parents -P usr/lib64/libavahi-glib.* ${currentPackage}-stripped-$version/
	cd $MODULEPATH/${currentPackage}/${currentPackage}-stripped-$version
	/sbin/makepkg -l y -c n $MODULEPATH/packages/${currentPackage}-stripped-$version.txz > /dev/null 2>&1
	rm -fr $MODULEPATH/${currentPackage}
fi

currentPackage=binutils
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
mv ../packages/${currentPackage}-[0-9]* .
version=`ls * -a | cut -d'-' -f2- | sed 's/\.txz$//'`
ROOT=./ installpkg ${currentPackage}-*.txz
mkdir ${currentPackage}-stripped-$version
cp --parents usr/bin/ar ${currentPackage}-stripped-$version/
cp --parents usr/bin/strip ${currentPackage}-stripped-$version/
cp --parents -P usr/lib$SYSTEMBITS/libbfd* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib$SYSTEMBITS/libsframe* ${currentPackage}-stripped-$version/
cd $MODULEPATH/${currentPackage}/${currentPackage}-stripped-$version
/sbin/makepkg -l y -c n $MODULEPATH/packages/${currentPackage}-stripped-$version.txz > /dev/null 2>&1
rm -fr $MODULEPATH/${currentPackage}

currentPackage=fftw
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
mv ../packages/${currentPackage}-[0-9]* .
version=`ls * -a | cut -d'-' -f2- | sed 's/\.txz$//'`
ROOT=./ installpkg ${currentPackage}-*.txz
mkdir ${currentPackage}-stripped-$version
cp --parents -P usr/lib64/libfftw3f.* ${currentPackage}-stripped-$version/
cd $MODULEPATH/${currentPackage}/${currentPackage}-stripped-$version
/sbin/makepkg -l y -c n $MODULEPATH/packages/${currentPackage}-stripped-$version.txz > /dev/null 2>&1
rm -fr $MODULEPATH/${currentPackage}

currentPackage=ntp
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
mv ../packages/${currentPackage}-[0-9]* .
version=`ls * -a | cut -d'-' -f2- | sed 's/\.txz$//'`
ROOT=./ installpkg ${currentPackage}-*.txz
mkdir ${currentPackage}-stripped-$version
cp --parents -P usr/bin/ntpdate ${currentPackage}-stripped-$version/
cp --parents -P usr/sbin/ntpdate ${currentPackage}-stripped-$version/
cp --parents -P usr/sbin/ntpd ${currentPackage}-stripped-$version/
cd $MODULEPATH/${currentPackage}/${currentPackage}-stripped-$version
/sbin/makepkg -l y -c n $MODULEPATH/packages/${currentPackage}-stripped-$version.txz > /dev/null 2>&1
rm -fr $MODULEPATH/${currentPackage}

currentPackage=openldap
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
mv ../packages/${currentPackage}-[0-9]* .
version=`ls * -a | cut -d'-' -f2- | sed 's/\.txz$//'`
ROOT=./ installpkg ${currentPackage}-*.txz
mkdir ${currentPackage}-stripped-$version
cp --parents etc/openldap/ldap.conf.new ${currentPackage}-stripped-$version/
mv ${currentPackage}-stripped-$version/etc/openldap/ldap.conf.new ${currentPackage}-stripped-$version/etc/openldap/ldap.conf
cp --parents usr/include/* ${currentPackage}-stripped-$version/
cp --parents -P usr/lib$SYSTEMBITS/libl* ${currentPackage}-stripped-$version/
cd $MODULEPATH/${currentPackage}/${currentPackage}-stripped-$version
/sbin/makepkg -l y -c n $MODULEPATH/packages/${currentPackage}-stripped-$version.txz > /dev/null 2>&1
rm -fr $MODULEPATH/${currentPackage}

### fake root

cd $MODULEPATH/packages && ROOT=./ installpkg *.t?z
rm *.t?z

### install additional packages, including porteux utils

InstallAdditionalPackages

### install certificates -- requires perl installed

TEMPBUNDLE="$(mktemp -t "${CERTBUNDLE}.tmp.XXXXXX")"

cd $MODULEPATH/packages/etc/ssl/certs
cp -s ../../../usr/share/ca-certificates/mozilla/* .

for i in *.crt; do
	sed -e '$a\' "$i" >> "$TEMPBUNDLE";
	rename crt pem "$i"
done

c_rehash . > /dev/null

chmod 0644 "$TEMPBUNDLE"
mv -f "$TEMPBUNDLE" ca-certificates.crt

### install kbd fonts

cd $MODULEPATH/packages
find usr/share/kbd -type f -name "*.gz" -exec gunzip {} \;

### set NetworkManager to use internal dhcp

sed -i "s|dhcp=dhclient|dhcp=internal|g" $MODULEPATH/packages/etc/NetworkManager/NetworkManager.conf || exit 1
sed -i "s|#dhcp=internal|dhcp=internal|g" $MODULEPATH/packages/etc/NetworkManager/conf.d/00-dhcp-client.conf || exit 1

### fix symlinks

cd $MODULEPATH/packages/bin
cp -s fusermount3 fusermount
cd $MODULEPATH/packages/usr/bin
cp -s python3 python

### fix permissions

cd $MODULEPATH/packages

chmod 644 etc/rc.d/rc.bluetooth
chmod 755 etc/rc.d/rc.networkmanager
chmod 644 etc/rc.d/rc.fuse3
chmod 644 etc/rc.d/rc.loop
chmod 644 etc/rc.d/rc.sshd
chmod 644 etc/rc.d/rc.wireless

### copy build files to 05-devel

CopyToDevel

### copy language files to 08-multilanguage

CopyToMultiLanguage

### module clean up

cd $MODULEPATH/packages/

rm -R lib/systemd
rm -R lib64/pkgconfig
rm -R mnt/*
rm -R usr/etc
rm -R usr/lib/ldscripts
rm -R usr/lib/modprobe.d
rm -R usr/lib/udev
rm -R usr/lib64/guile
rm -R usr/lib64/services
rm -R usr/lib64/krb5/plugins
rm -R usr/lib64/locale/C.utf8
rm -R usr/lib64/p7zip/Codecs
rm -R usr/lib64/python2.7
rm -R usr/lib64/python*/idlelib
rm -R usr/lib64/python*/lib2to3
rm -R usr/lib64/python*/site-packages/demo
rm -R usr/lib64/python*/turtledemo
rm -R usr/lib64/sasl2
rm -R usr/lib64/systemd
rm -R usr/local/etc
rm -R usr/local/games
rm -R usr/local/include
rm -R usr/local/info
rm -R usr/local/lib
rm -R usr/local/lib64
rm -R usr/local/man
rm -R usr/local/sbin
rm -R usr/local/share
rm -R usr/local/src
rm -R usr/share/applications
rm -R usr/share/common-lisp
rm -R usr/share/glib-2.0/gdb
rm -R usr/share/glib-2.0/gettext
rm -R usr/share/glib-2.0/valgrind
rm -R usr/share/guile
rm -R usr/share/icu
rm -R usr/share/info
rm -R usr/share/kbd/keymaps/amiga
rm -R usr/share/kbd/keymaps/atari
rm -R usr/share/kbd/keymaps/mac
rm -R usr/share/kbd/keymaps/ppc
rm -R usr/share/kbd/keymaps/sun
rm -R usr/share/lynx
rm -R usr/share/mc/examples
rm -R usr/share/mc/help
rm -R usr/share/mc/hints
rm -R usr/share/terminfo/[0-9]
rm -R usr/share/terminfo/[A-Z]
rm -R usr/share/terminfo/b
rm -R usr/share/terminfo/c
rm -R usr/share/terminfo/e
rm -R usr/share/terminfo/f
rm -R usr/share/terminfo/g
rm -R usr/share/terminfo/h
rm -R usr/share/terminfo/i
rm -R usr/share/terminfo/j
rm -R usr/share/terminfo/k
rm -R usr/share/terminfo/m
rm -R usr/share/terminfo/n
rm -R usr/share/terminfo/o
rm -R usr/share/terminfo/p
rm -R usr/share/terminfo/q
rm -R usr/share/terminfo/s
rm -R usr/share/terminfo/t
rm -R usr/share/terminfo/u
rm -R usr/share/terminfo/w
rm -R usr/share/terminfo/z
rm -R usr/x86_64-slackware-linux

rm etc/init.d
rm etc/motd
rm etc/openvpn/sample-config-files
rm etc/rc.d/rc.inet2
rm usr/bin/7za
rm usr/bin/7zr
rm usr/bin/smbtorture
rm usr/bin/wpa_gui
rm usr/lib64/libqgpgme.*
rm usr/lib64/libslang.so.1*
rm usr/lib64/p7zip/7za
rm usr/lib64/p7zip/7zr
rm usr/libexec/samba/rpcd_*
rm usr/share/pixmaps/wpa_gui.png
rm var/db/Makefile

find usr/lib64/python* -type d -name 'test' -prune -exec rm -rf {} +
find usr/lib64/python* -type d -name 'tests' -prune -exec rm -rf {} +

# move out libc because it can't be stripped at all
mv $MODULEPATH/packages/lib64/libc.so* $MODULEPATH/
mv $MODULEPATH/packages/lib64/libc-* $MODULEPATH/
GenericStrip
mv $MODULEPATH/libc.so* $MODULEPATH/packages/lib64
mv $MODULEPATH/libc-* $MODULEPATH/packages/lib64

# move out stuff that can't be stripped
mv $MODULEPATH/packages/lib64 $MODULEPATH/
AggressiveStrip
mv $MODULEPATH/lib64 $MODULEPATH/packages/

### copy cache files

PrepareFilesForCache

### finalize

Finalize
