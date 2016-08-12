#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEDIR=netmonitor/
SOURCEBIN=netmonitor/boddy.lua
IFACEBIN=sv-nm-hosts
IFACEBINV=sv-nm-hosts-list
LIBFACE=monitor_functions/nmap-auto-functions
LIBLIST=monitor_functions/get_hostlist
LIBRANGE=monitor_functions/get_range
LIBSCAN=monitor_functions/host_scan
EXPLOIT=exploits/http-cgi-shellshock.sh
EXPLOITLIB=exploits/http-cgi-testcgils.sh
LOGBINA=sv-nm-last-scan
LOGBINB=sv-nm-last-find
CONNBIN=sv-nm-scan-host
CONNBINV=sv-nm-scan-host-list
EXPLBIN=sv-nm-expl-auto
EXPLBIN=sv-nm-expl-auto-list
SOURCEDOC=README.md
INSTALLDOC=INSTALL.md
HACKDOC=SCRIPTING.md
DEBFOLDER=svirfneblin-netmonitor-widget

DEBVERSION=$(date +%Y%m%d)

if [ -n "$BASH_VERSION" ]; then
	TOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
	TOME=$( cd "$( dirname "$0" )" && pwd )
fi
cd $TOME

git pull origin master

DEBFOLDERNAME="$TOME/../$DEBFOLDER-$DEBVERSION"
DEBPACKAGENAME=$DEBFOLDER\_$DEBVERSION

# Copy your script to the source dir
cp -R $TOME $DEBFOLDERNAME/
cd $DEBFOLDERNAME

pwd

# Create the packaging skeleton (debian/*)
dh_make --indep --createorig

mkdir -p debian/tmp/usr
cp -R usr debian/tmp/usr

# Remove make calls
grep -v makefile debian/rules > debian/rules.new
mv debian/rules.new debian/rules

# debian/install must contain the list of scripts to install
# as well as the target directory
echo etc/xdg/svirfneblin/rc.lua.boddy.example etc/xdg/svirfneblin >> debian/install
echo etc/xdg/svirfneblin/$SOURCEBIN etc/xdg/svirfneblin/$SOURCEDIR >> debian/install
echo usr/bin/$IFACEBIN usr/bin >> debian/install
echo usr/bin/$IFACEBINV usr/bin >> debian/instal
echo usr/bin/$LOGBINA usr/bin >> debian/install
echo usr/bin/$LOGBINB usr/bin >> debian/install
echo usr/bin/$LIBFACE usr/bin/monitor_functions >> debian/install
echo usr/bin/$LIBRANGE usr/bin/monitor_functions >> debian/install
echo usr/bin/$LIBLIST usr/bin/monitor_functions >> debian/install
echo usr/bin/$LIBSCAN usr/bin/monitor_functions >> debian/install
echo usr/bin/$CONNBIN usr/bin >> debian/install
echo usr/bin/$CONNBINV usr/bin >> debian/install
echo usr/bin/$EXPLBIN usr/bin >> debian/install
echo usr/bin/$EXPLBINV usr/bin >> debian/install
echo usr/bin/$EXPLOIT usr/bin/exploits >> debian/install
echo usr/bin/$EXPLOITLIB usr/bin/exploits >> debian/install
echo usr/share/doc/$DEBFOLDER/$SOURCEDOC usr/share/doc/$DEBFOLDER >> debian/install
echo usr/share/doc/$DEBFOLDER/$INSTALLDOC usr/share/doc/$DEBFOLDER >> debian/install
echo usr/share/doc/$DEBFOLDER/$HACKDOC usr/share/doc/$DEBFOLDER >> debian/install

echo "Source: $DEBFOLDER
Section: unknown
Priority: optional
Maintainer: idk <eyedeekay@i2pmail.org>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.5
Homepage: https://www.github.com/cmotc/svirfneblin-netmonitor-widget
#Vcs-Git: git@github.com:cmotc/svirfneblin-netmonitor-widget
#Vcs-Browser: https://www.github.com/cmotc/svirfneblin-netmonitor-widget

Package: $DEBFOLDER
Architecture: all
Depends: awesome (>= 3.4), svirfneblin-panel \${misc:Depends}
Description: A network monitoring widget for awesomewm.
" > debian/control

#echo "gsettings set org.gnome.desktop.session session-name awesome-gnome
#dconf write /org/gnome/settings-daemon/plugins/cursor/active false
#gconftool-2 --type bool --set /apps/gnome_settings_daemon/plugins/background/active false
#" > debian/postinst
# Remove the example files
rm debian/*.ex
rm debian/*.EX

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc >> ../log
