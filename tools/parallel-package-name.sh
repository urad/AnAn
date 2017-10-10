#!/bin/bash
# Change the package and application name of AnkiDroid for parallel install
# Written by Tim Rae 18-11-2015

# Input arguments are packageId and app name
NEW_ID=$1		# e.g. com.ichi2.anki.a
NEW_NAME=$2		# e.g. AnkiDroid.A
ue
ROOT="AnkiDroid/src/main/"
MANIFEST="AndroidManifest.xml"
CONSTANTS="res/values/constants.xml"

OLD_ID=`grep applicationId AnkiDroid/build.gradle | sed "s/.*applicationId \"//" | sed "s/\"//"`
echo OLD_ID=$OLD_ID
OLD_NAME=`grep "name=\"app_name\"" $ROOT$CONSTANTS | sed "s/.*name=\"app_name\">//" | sed "s/<\/string>//"`
echo OLD_NAME=$OLD_NAME
sleep 1

echo -n Changing $ROOT$CONSTANTS
sed -i -e "s/name=\"app_name\">$OLD_NAME/name=\"app_name\">$NEW_NAME/g" $ROOT$CONSTANTS
echo donel
sleep 1

echo -n Changing build.gradle
sed -i -e "s/applicationId \"$OLD_ID/applicationId \"$NEW_ID/g" AnkiDroid/build.gradle
echo done
sleep 1

echo  -n Changing Manifest
sed -i -e "s/android:authorities=\"$OLD_ID/android:authorities=\"$NEW_ID/g" $ROOT$MANIFEST
sed -i -e "s/permission android:name=\"$OLD_ID.permission/permission android:name=\"$NEW_ID.permission/g" $ROOT$MANIFEST
echo done
sleep 1

echo -n Changing android:targetPackage value in all xml files
find $ROOT/res/xml -type f -exec sed -i -e "s/android:targetPackage=\"$OLD_ID\"/android:targetPackage=\"$NEW_ID\"/g"  {} \;
echo done
