#!/bin/sh
source "$PWD/../builder-utils/slackwarerepository.sh"

REPOSITORY="$1"

GenerateRepositoryUrls "$REPOSITORY"

DownloadPackage "aaa_base" &
DownloadPackage "aaa_glibc-solibs" &
DownloadPackage "aaa_libraries" &
DownloadPackage "aaa_terminfo" &
DownloadPackage "acl" &
DownloadPackage "acpid" &
DownloadPackage "attr" &
DownloadPackage "bash" &
DownloadPackage "bc" &
DownloadPackage "bin" &
wait
DownloadPackage "bluez" &
DownloadPackage "bluez-firmware" &
DownloadPackage "bridge-utils" &
DownloadPackage "brotli" &
DownloadPackage "bzip2" &
DownloadPackage "ca-certificates" &
DownloadPackage "cdrtools" &
DownloadPackage "cifs-utils" &
DownloadPackage "coreutils" &
DownloadPackage "cpio" &
wait
DownloadPackage "cracklib" &
DownloadPackage "curl" &
DownloadPackage "cyrus-sasl" &
DownloadPackage "dbus" &
DownloadPackage "dbus-glib" &
DownloadPackage "dcron" &
DownloadPackage "devs" &
DownloadPackage "dhcpcd" &
DownloadPackage "dialog" &
wait
DownloadPackage "diffutils" &
DownloadPackage "dmapi" &
DownloadPackage "dmidecode" &
DownloadPackage "dnsmasq" &
DownloadPackage "dosfstools" &
DownloadPackage "dvd+rw-tools" &
DownloadPackage "e2fsprogs" &
DownloadPackage "elfutils" &
DownloadPackage "elogind" &
DownloadPackage "etc" &
DownloadPackage "ethtool" &
wait
DownloadPackage "eudev" &
DownloadPackage "exfatprogs" &
DownloadPackage "f2fs-tools" &
DownloadPackage "file" &
DownloadPackage "findutils" &
DownloadPackage "flex" &
DownloadPackage "floppy" &
DownloadPackage "fuse3" &
DownloadPackage "gawk" &
DownloadPackage "gd" &
wait
DownloadPackage "gdbm" &
DownloadPackage "gettext" &
DownloadPackage "glib2" &
DownloadPackage "glibc" &
DownloadPackage "glibc-zoneinfo" &
DownloadPackage "gnome-keyring" &
DownloadPackage "gnupg" &
DownloadPackage "gnutls" &
DownloadPackage "gpgme" &
DownloadPackage "gpm" &
wait
DownloadPackage "gptfdisk" &
DownloadPackage "grep" &
DownloadPackage "gzip" &
DownloadPackage "hdparm" &
DownloadPackage "hostname" &
DownloadPackage "hwdata" &
DownloadPackage "icu4c" &
DownloadPackage "infozip" &
DownloadPackage "inih" &
wait
DownloadPackage "iproute2" &
DownloadPackage "iptables" &
DownloadPackage "iputils" &
DownloadPackage "iw" &
DownloadPackage "jansson" &
DownloadPackage "kbd" &
DownloadPackage "keyutils" &
DownloadPackage "kmod" &
DownloadPackage "less" &
wait
DownloadPackage "libaio" &
DownloadPackage "libarchive" &
DownloadPackage "libassuan" &
DownloadPackage "libcap" &
DownloadPackage "libcap-ng" &
DownloadPackage "libffi" &
DownloadPackage "libgcrypt" &
DownloadPackage "libgpg-error" &
DownloadPackage "libgudev" &
DownloadPackage "libidn2" &
DownloadPackage "libidn" &
wait
DownloadPackage "libimobiledevice" &
DownloadPackage "libimobiledevice-glue" &
DownloadPackage "libldap" &
DownloadPackage "libmbim" &
DownloadPackage "libmnl" &
DownloadPackage "libndp" &
DownloadPackage "libnetfilter_conntrack" &
DownloadPackage "libnfnetlink" &
DownloadPackage "libnftnl" &
DownloadPackage "libnih" &
wait
DownloadPackage "libnl3" &
DownloadPackage "libnsl" &
DownloadPackage "libpcap" &
DownloadPackage "libplist" &
DownloadPackage "libpsl" &
DownloadPackage "libpwquality" &
DownloadPackage "libqmi" &
DownloadPackage "libraw1394" &
DownloadPackage "libseccomp" &
wait
DownloadPackage "libssh2" &
DownloadPackage "libtasn1" &
DownloadPackage "libtirpc" &
DownloadPackage "libunistring" &
DownloadPackage "liburing" & # required by samba
DownloadPackage "libusb" &
DownloadPackage "libusb-compat" &
DownloadPackage "libusbmuxd" &
DownloadPackage "libxml2" &
DownloadPackage "libzip" &
DownloadPackage "lmdb" &
wait
DownloadPackage "lm_sensors" &
DownloadPackage "lsof" &
DownloadPackage "lvm2" &
DownloadPackage "lynx" &
DownloadPackage "lz4" &
DownloadPackage "lzip" &
DownloadPackage "lzo" &
DownloadPackage "mc" &
DownloadPackage "mdadm" &
wait
DownloadPackage "mlocate" &
DownloadPackage "ModemManager" &
DownloadPackage "mozilla-nss" &
DownloadPackage "mpfr" &
DownloadPackage "ncurses" &
DownloadPackage "nettle" &
DownloadPackage "net-tools" &
DownloadPackage "NetworkManager" &
DownloadPackage "network-scripts" &
wait
DownloadPackage "newt" &
DownloadPackage "nfs-utils" &
DownloadPackage "nghttp2" &
DownloadPackage "ntfs" &
DownloadPackage "openssh" &
DownloadPackage "openssl" &
DownloadPackage "openvpn" &
DownloadPackage "p11-kit" &
wait
DownloadPackage "pam" &
DownloadPackage "parted" &
DownloadPackage "patch" &
DownloadPackage "pciutils" &
DownloadPackage "pcre2" &
DownloadPackage "pcre" &
DownloadPackage "pkgtools" &
DownloadPackage "popt" &
wait
DownloadPackage "ppp" &
DownloadPackage "pptp" &
DownloadPackage "python3" &
DownloadPackage "python-urllib3" &
DownloadPackage "readline" &
DownloadPackage "rpcbind" &
DownloadPackage "rpm2tgz" &
DownloadPackage "rpm" &
wait
DownloadPackage "rp-pppoe" &
DownloadPackage "rsync" &
DownloadPackage "samba" &
DownloadPackage "screen" &
DownloadPackage "sdparm" &
DownloadPackage "sed" &
DownloadPackage "sg3_utils" &
DownloadPackage "shadow" &
DownloadPackage "sharutils" &
DownloadPackage "slackpkg" &
DownloadPackage "smartmontools" &
wait
DownloadPackage "sqlite" &
DownloadPackage "squashfs-tools" &
DownloadPackage "sshfs" &
DownloadPackage "sudo" &
DownloadPackage "sysfsutils" &
DownloadPackage "sysklogd" &
DownloadPackage "sysvinit-functions" &
wait
DownloadPackage "sysvinit-scripts" &
DownloadPackage "talloc" &
DownloadPackage "tar" &
DownloadPackage "tcl" &
DownloadPackage "tdb" &
DownloadPackage "telnet" &
DownloadPackage "tevent" &
DownloadPackage "traceroute" &
wait
DownloadPackage "uring" &
DownloadPackage "usb_modeswitch" &
DownloadPackage "usbmuxd" &
DownloadPackage "usbutils" &
DownloadPackage "utempter" &
DownloadPackage "util-linux" &
DownloadPackage "wget" &
DownloadPackage "which" &
DownloadPackage "whois" &
wait
DownloadPackage "wireless_tools" &
DownloadPackage "wpa_supplicant" &
DownloadPackage "xfsdump" &
DownloadPackage "xfsprogs" &
DownloadPackage "xxHash" &
DownloadPackage "xz" &
DownloadPackage "zlib" &
DownloadPackage "zstd" &
wait

### slackware current only packages

if [ $SLACKWAREVERSION == "current" ]; then
	DownloadPackage "avahi" &
	DownloadPackage "lua" &
	DownloadPackage "lzlib" &
	DownloadPackage "userspace-rcu" &
	wait
fi

### packages that require specific striping

DownloadPackage "binutils" &
DownloadPackage "fftw" & # required by pulse plugins
DownloadPackage "ntp" &
DownloadPackage "openldap" &
wait

### script clean up

rm FILE_LIST
rm serverPackages.txt
