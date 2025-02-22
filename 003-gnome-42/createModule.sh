#!/bin/sh
MODULENAME=003-gnome

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

### packages outside Slackware repository

currentPackage=audacious
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
info=$(DownloadLatestFromGithub "audacious-media-player" ${currentPackage})
version=${info#* }
cp $SCRIPTPATH/extras/audacious/${currentPackage}-gtk.SlackBuild .
sh ${currentPackage}-gtk.SlackBuild || exit 1
rm -fr $MODULEPATH/${currentPackage}

currentPackage=audacious-plugins
mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
info=$(DownloadLatestFromGithub "audacious-media-player" ${currentPackage})
version=${info#* }
cp $SCRIPTPATH/extras/audacious/${currentPackage}-gtk.SlackBuild .
sh ${currentPackage}-gtk.SlackBuild || exit 1
rm -fr $MODULEPATH/${currentPackage}

if [ $SLACKWAREVERSION != "current" ]; then
	currentPackage=meson
	mkdir $MODULEPATH/${currentPackage} && cd $MODULEPATH/${currentPackage}
	cp $SCRIPTPATH/extras/meson/* .
	sh ${currentPackage}.SlackBuild || exit 1
	rm -fr $MODULEPATH/package-${currentPackage}
	rm -fr $MODULEPATH/${currentPackage}*
	/sbin/upgradepkg --install-new --reinstall $MODULEPATH/packages/meson-*.txz
	rm $MODULEPATH/packages/meson-*.txz
fi

# required from now on
installpkg $MODULEPATH/packages/*.txz || exit 1

# only required for building not for run-time
rm $MODULEPATH/packages/boost*
rm $MODULEPATH/packages/cups*
rm $MODULEPATH/packages/dbus-python*
rm $MODULEPATH/packages/egl-wayland*
rm $MODULEPATH/packages/gst-plugins-bad-free*
rm $MODULEPATH/packages/iso-codes*
rm $MODULEPATH/packages/krb5*
rm $MODULEPATH/packages/libsass*
rm $MODULEPATH/packages/libwnck3*
rm $MODULEPATH/packages/llvm*
rm $MODULEPATH/packages/rust*
rm $MODULEPATH/packages/sassc*
rm $MODULEPATH/packages/xtrans*

# slackware current only removal -- these are already in base
if [ $SLACKWAREVERSION == "current" ]; then
	rm $MODULEPATH/packages/libnma*
fi

# some packages (e.g nautilus and vte) require this folder
mkdir -p /usr/local > /dev/null 2>&1
ln -s /usr/include /usr/local/include > /dev/null 2>&1

if [ $SLACKWAREVERSION != "current" ]; then
	currentPackage=gsettings-desktop-schemas
	cd $SCRIPTPATH/gnome/${currentPackage} || exit 1
	sh ${currentPackage}.SlackBuild || exit 1
	installpkg $MODULEPATH/packages/${currentPackage}-*.txz || exit 1
	find $MODULEPATH -mindepth 1 -maxdepth 1 ! \( -name "packages" \) -exec rm -rf '{}' \; 2>/dev/null
	
	currentPackage=gtk4
	cd $SCRIPTPATH/gnome/${currentPackage} || exit 1
	sh ${currentPackage}.SlackBuild || exit 1
	installpkg $MODULEPATH/packages/${currentPackage}-*.txz || exit 1
	find $MODULEPATH -mindepth 1 -maxdepth 1 ! \( -name "packages" \) -exec rm -rf '{}' \; 2>/dev/null

	currentPackage=libhandy
	cd $SCRIPTPATH/gnome/${currentPackage} || exit 1
	sh ${currentPackage}.SlackBuild || exit 1
	installpkg $MODULEPATH/packages/${currentPackage}-*.txz || exit 1
	find $MODULEPATH -mindepth 1 -maxdepth 1 ! \( -name "packages" \) -exec rm -rf '{}' \; 2>/dev/null

	currentPackage=libnma
	cd $SCRIPTPATH/gnome/${currentPackage} || exit 1
	sh ${currentPackage}.SlackBuild || exit 1
	installpkg $MODULEPATH/packages/${currentPackage}-*.txz || exit 1
	find $MODULEPATH -mindepth 1 -maxdepth 1 ! \( -name "packages" \) -exec rm -rf '{}' \; 2>/dev/null

	currentPackage=libsoup3
	cd $SCRIPTPATH/gnome/${currentPackage} || exit 1
	sh ${currentPackage}.SlackBuild || exit 1
	installpkg $MODULEPATH/packages/${currentPackage}-*.txz || exit 1
	find $MODULEPATH -mindepth 1 -maxdepth 1 ! \( -name "packages" \) -exec rm -rf '{}' \; 2>/dev/null
	rm $MODULEPATH/packages/libsoup3*

	currentPackage=vte
	cd $SCRIPTPATH/gnome/${currentPackage} || exit 1
	sh ${currentPackage}.SlackBuild || exit 1
	installpkg $MODULEPATH/packages/${currentPackage}-*.txz || exit 1
	find $MODULEPATH -mindepth 1 -maxdepth 1 ! \( -name "packages" \) -exec rm -rf '{}' \; 2>/dev/null
fi

# gnome packages
for package in \
	mozjs91 \
	upower \
	libstemmer \
	exempi \
	tracker3 \
	gtksourceview5 \
	libwpe \
	wpebackend-fdo \
	bubblewrap \
	geoclue2 \
	geocode-glib \
	geocode-glib2 \
	libgweather \
	libpeas \
	gsound \
	gnome-autoar \
	gnome-desktop \
	gnome-settings-daemon \
	libadwaita \
	gnome-bluetooth \
	libnma-gtk4 \
	gnome-control-center \
	mutter \
	gjs \
	gnome-shell \
	gnome-session \
	gnome-menus \
	nautilus \
	nautilus-python \
	gdm \
	gspell \
	gnome-text-editor \
	eog \
	evince \
	gnome-system-monitor \
	gnome-console \
	gnome-tweaks \
	gnome-user-share \
	libwnck4 \
	gnome-browser-connector \
	file-roller \
	gnome-backgrounds \
	xdg-desktop-portal-gnome \
; do
cd $SCRIPTPATH/gnome/$package || exit 1
sh ${package}.SlackBuild || exit 1
installpkg $MODULEPATH/packages/$package-*.txz || exit 1
find $MODULEPATH -mindepth 1 -maxdepth 1 ! \( -name "packages" \) -exec rm -rf '{}' \; 2>/dev/null
done

### fake root

cd $MODULEPATH/packages && ROOT=./ installpkg *.t?z
rm *.t?z

### install additional packages, including porteux utils

InstallAdditionalPackages

### fix some .desktop files

sed -i "s|image/x-icns|image/x-icns;image/heic;image/jxl|g" $MODULEPATH/packages/usr/share/applications/org.gnome.eog.desktop

### copy build files to 05-devel

CopyToDevel

### copy language files to 08-multilanguage

CopyToMultiLanguage

### module clean up

cd $MODULEPATH/packages/

rm -R etc/dbus-1/system.d
rm -R etc/dconf
rm -R etc/geoclue
rm -R etc/opt
rm -R usr/lib${SYSTEMBITS}/aspell
rm -R usr/lib${SYSTEMBITS}/glade
rm -R usr/lib${SYSTEMBITS}/gnome-settings-daemon-3.0
rm -R usr/lib${SYSTEMBITS}/graphene-1.0
rm -R usr/lib${SYSTEMBITS}/gtk-2.0
rm -R usr/lib${SYSTEMBITS}/tracker-3.0
rm -R usr/lib*/python2*
rm -R usr/lib*/python3*/site-packages/pip*
rm -R usr/share/dbus-1/services/org.freedesktop.ColorHelper.service
rm -R usr/share/dbus-1/services/org.freedesktop.IBus.service
rm -R usr/share/dbus-1/services/org.freedesktop.portal.IBus.service
rm -R usr/share/dbus-1/services/org.freedesktop.portal.Tracker.service
rm -R usr/share/dbus-1/services/org.gnome.ArchiveManager1.service
rm -R usr/share/dbus-1/services/org.gnome.evince.Daemon.service
rm -R usr/share/dbus-1/services/org.gnome.FileRoller.service
rm -R usr/share/dbus-1/services/org.gnome.Nautilus.Tracker3.Miner.Extract.service
rm -R usr/share/dbus-1/services/org.gnome.Nautilus.Tracker3.Miner.Files.service
rm -R usr/share/dbus-1/services/org.gnome.ScreenSaver.service
rm -R usr/share/dbus-1/services/org.gnome.Shell.PortalHelper.service
rm -R usr/share/gjs-1.0
rm -R usr/share/glade/pixmaps
rm -R usr/share/gnome/autostart
rm -R usr/share/gnome/shutdown
rm -R usr/share/gtk-4.0
rm -R usr/share/ibus
rm -R usr/share/installed-tests
rm -R usr/share/libgweather-4
rm -R usr/share/pixmaps
rm -R usr/share/vala
rm -R usr/share/zsh
rm -R var/lib/AccountsService

rm etc/xdg/autostart/blueman.desktop
rm etc/xdg/autostart/ibus*.desktop
rm usr/bin/canberra*
rm usr/bin/gtk4-builder-tool
rm usr/bin/gtk4-demo
rm usr/bin/gtk4-demo-application
rm usr/bin/gtk4-icon-browser
rm usr/bin/gtk4-launch
rm usr/bin/gtk4-print-editor
rm usr/bin/gtk4-widget-factory
rm usr/bin/js[0-9]*
rm usr/lib${SYSTEMBITS}/gstreamer-1.0/libgstfluidsynthmidi.*
rm usr/lib${SYSTEMBITS}/gstreamer-1.0/libgstneonhttpsrc.*
rm usr/lib${SYSTEMBITS}/gstreamer-1.0/libgstopencv.*
rm usr/lib${SYSTEMBITS}/gstreamer-1.0/libgstopenexr.*
rm usr/lib${SYSTEMBITS}/gstreamer-1.0/libgstqmlgl.*
rm usr/lib${SYSTEMBITS}/gstreamer-1.0/libgstqroverlay.*
rm usr/lib${SYSTEMBITS}/gstreamer-1.0/libgsttaglib.*
rm usr/lib${SYSTEMBITS}/gstreamer-1.0/libgstwebrtc.*
rm usr/lib${SYSTEMBITS}/gstreamer-1.0/libgstzxing.*
rm usr/lib${SYSTEMBITS}/libcanberra-gtk.*
rm usr/lib${SYSTEMBITS}/libgstopencv-1.0.*
rm usr/lib${SYSTEMBITS}/libgstwebrtcnice.*
rm usr/share/applications/org.gtk.gtk4.NodeEditor.desktop

[ "$SYSTEMBITS" == 64 ] && find usr/lib/ -mindepth 1 -maxdepth 1 ! \( -name "python*" \) -exec rm -rf '{}' \; 2>/dev/null
find usr/share/backgrounds/gnome/ -mindepth 1 -maxdepth 1 ! \( -name "adwaita*" \) -exec rm -rf '{}' \; 2>/dev/null
find usr/share/gnome-background-properties/ -mindepth 1 -maxdepth 1 ! \( -name "adwaita*" \) -exec rm -rf '{}' \; 2>/dev/null

mv $MODULEPATH/packages/usr/lib${SYSTEMBITS}/libmozjs-* $MODULEPATH/
GenericStrip
AggressiveStripAll
mv $MODULEPATH/libmozjs-* $MODULEPATH/packages/usr/lib${SYSTEMBITS}

### copy cache files

PrepareFilesForCache

### generate cache files

GenerateCaches

### finalize

Finalize
