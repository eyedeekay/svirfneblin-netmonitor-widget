#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEDIR=netmonitor/
SOURCEBIN=netmonitor/boddy.lua
IFACEBIN=nmap-auto-wrapper
LIBFACE=monitor_functions/nmap-auto-functions
CONNBIN=nmap-auto-scanner
EXPLBIN=exploit-auto-select
SOURCEDOC=README.md
DEBFOLDER=svirfneblin-netmonitor-widget

DEBVERSION=$(date +%Y%m%d)

cd $DEBFOLDER

git pull origin master

DEBFOLDERNAME="../$DEBFOLDER-$DEBVERSION"
DEBPACKAGENAME=$DEBFOLDER\_$DEBVERSION

rm -rf $DEBFOLDERNAME
# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp -R ./ $DEBFOLDERNAME/
cd $DEBFOLDERNAME

pwd

# Create the packaging skeleton (debian/*)
dh_make -s --indep --createorig 

mkdir -p debian/tmp/usr
cp -R usr debian/tmp/usr

# Remove make calls
grep -v makefile debian/rules > debian/rules.new 
mv debian/rules.new debian/rules 

dpkg-source --commit

# debian/install must contain the list of scripts to install 
# as well as the target directory
echo etc/xdg/svirfneblin/rc.lua.boddy.example etc/xdg/svirfneblin >> debian/install
echo etc/xdg/svirfneblin/$SOURCEBIN etc/xdg/svirfneblin/$SOURCEDIR >> debian/install
echo usr/bin/$IFACEBIN usr/bin >> debian/install
echo usr/bin/$LIBFACE usr/bin/monitor_functions >> debian/install
echo usr/bin/$CONNBIN usr/bin >> debian/install
echo usr/bin/$EXPLBIN usr/bin >> debian/install
cp $SOURCEDOC usr/share/doc/$DEBFOLDER/$SOURCEDOC
echo usr/share/doc/$DEBFOLDER/$SOURCEDOC usr/share/doc/$DEBFOLDER >> debian/install

echo "Source: $DEBFOLDER
Section: unknown
Priority: optional
Maintainer: cmotc <cmotc@openmailbox.org>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.5
Homepage: https://www.github.com/cmotc/svirfneblin-netmonitor-widget
#Vcs-Git: git@github.com:cmotc/svirfneblin-netmonitor-widget
#Vcs-Browser: https://www.github.com/cmotc/svirfneblin-netmonitor-widget

Package: $DEBFOLDER
Architecture: all
Depends: lightdm, lightdm-gtk-greeter, awesome (>= 3.4), svirfneblin-panel \${misc:Depends}
Description: A network monitoring widget for awesomewm
" > debian/control

#echo "gsettings set org.gnome.desktop.session session-name awesome-gnome
#dconf write /org/gnome/settings-daemon/plugins/cursor/active false
#gconftool-2 --type bool --set /apps/gnome_settings_daemon/plugins/background/active false
#" > debian/postinst
# Remove the example files
rm debian/*.ex
rm debian/*.EX

dpkg-source --commit

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc >> ../log
