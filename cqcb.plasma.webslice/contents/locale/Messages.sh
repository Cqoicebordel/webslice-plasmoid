#! /usr/bin/env bash
# Copied this script from gmail-plasmoid-0.7.20 which is copyrighted as follows:
# Copyright (C) 2009 Mark McCans <mjmccans@gmail.com>
# under the GPLv2 or later
# Modifications for QML plasmoids by:
# Copyright (C) 2012 Glad Deschrijver <glad.deschrijver@gmail.com>
# Modifications for gettext-0.18.3 and kdictionary by:
# Copyright (C) 2013 Symeon Huang <librehat@outlook.com>
# Modifications for Webslice
# Copyright (C) 2018 Cqoicebordel

# Go to script dir
cd "${0%/*}"
DIR=$(pwd)

#NAME=$(basename $(dirname $DIR))
NAME="plasma_applet_"`grep "X-KDE-PluginInfo-Name" ../../metadata.desktop | sed 's/.*=//'`
API=$(grep "X-Plasma-API" ../../metadata.desktop | sed 's/.*=//')
case "$API" in
  "python") SCRIPTEXT="py" ;;
  "ruby-script") SCRIPTEXT="rb" ;;
  "webkit") SCRIPTEXT="js" ;;
  "declarativeappletscript") SCRIPTEXT="js" ;;
  * ) exit ;;
esac

VERSION=$(grep "X-KDE-PluginInfo-Version" ../../metadata.desktop | sed 's/.*=//')

XGETTEXT="xgettext --from-code=UTF-8 -kde -ci18n -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 \
          -ki18ncp:1c,2,3 -ktr2i18n:1 -kI18N_NOOP:1 -kI18N_NOOP2:1c,2 -kaliasLocale \
          -kki18n:1 -kki18nc:1c,2 -kki18np:1,2 -kki18ncp:1c,2,3xgettext -ki18n -ki18nc
          -ki18ncp -ki18np"
# EXTRACTRC="./extractrc"

if [ "x$1" != "x" ]; then
    if [ ! -d "$1" ]; then
        mkdir -p "$1/LC_MESSAGES"
    fi
fi

# $EXTRACTRC ../ui/*.ui > ./rc.$SCRIPTEXT
#echo 'i18nc("NAME OF TRANSLATORS","Your names");' >> ./rc.$SCRIPTEXT
#echo 'i18nc("EMAIL OF TRANSLATORS","Your emails");' >> ./rc.$SCRIPTEXT
#$XGETTEXT rc.$SCRIPTEXT ../code/*.$SCRIPTEXT -o "$NAME.pot"
#gettext-0.18.3 or later supports JavaScript
touch rc.$SCRIPTEXT
$XGETTEXT ../ui/*.qml ../config/*.qml rc.$SCRIPTEXT -L JavaScript -o "$NAME.pot"
sed -e 's/charset=CHARSET/charset=UTF-8/g' -i "$NAME.pot"
sed -e 's/SOME DESCRIPTIVE TITLE./plasma-applet-webslice language translation file./g' -i "$NAME.pot"
sed -e "s/Copyright (C) YEAR THE PACKAGE'S COPYRIGHT HOLDER/Copyright (C) 2018 Cqoicebordel/g" -i "$NAME.pot"
sed -e 's/This file is distributed under the same license as the PACKAGE package./This file is distributed under the same license as the plasma-applet-webslice package./g' -i "$NAME.pot"
sed -e 's/FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.//g' -i "$NAME.pot"
sed -e "s/Project-Id-Version: PACKAGE VERSION/Project-Id-Version: $VERSION/g" -i "$NAME.pot"

for d in */; do
    if [ -d "$d" ]; then
        if [ -f "$d/LC_MESSAGES/$NAME.po" ]; then
            echo "Merging $NAME.pot -> $d/LC_MESSAGES/$NAME.po ..."
            msgmerge -U -N --backup=none "$d/LC_MESSAGES/$NAME.po" "$NAME.pot"
        else
            echo "Copying $NAME.pot -> $d/LC_MESSAGES/$NAME.po ..."
            cp "$NAME.pot" "$d/LC_MESSAGES/$NAME.po"
        fi
    fi
done

for d in */; do
    echo "Making $d/LC_MESSAGES/$NAME.mo ..."
    msgfmt "$d/LC_MESSAGES/$NAME.po" -o "$d/LC_MESSAGES/$NAME.mo"
done

rm -f rc.$SCRIPTEXT
#rm -f $NAME.pot
