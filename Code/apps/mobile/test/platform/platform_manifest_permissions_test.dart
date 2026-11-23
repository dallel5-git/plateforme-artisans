import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MOB-004 — Permissions et Intents natifs // régression #MOB-004', () {
    final androidManifestFile = File(
      'android/app/src/main/AndroidManifest.xml',
    );
    final infoPlistFile = File('ios/Runner/Info.plist');
    final frInfoPlistStrings = File('ios/Runner/fr.lproj/InfoPlist.strings');
    final arInfoPlistStrings = File('ios/Runner/ar.lproj/InfoPlist.strings');

    test(
      'AndroidManifest.xml déclare les requêtes d intent tel, https et '
      'WhatsApp dans <queries> // régression #MOB-004',
      () {
        expect(androidManifestFile.existsSync(), isTrue);
        final manifestContent = androidManifestFile.readAsStringSync();

        // android:scheme="tel" (appel téléphonique)
        expect(
          manifestContent,
          contains('android:scheme="tel"'),
          reason: 'AndroidManifest.xml doit déclarer scheme="tel"',
        );

        // android:scheme="https" (liens web et wa.me)
        expect(
          manifestContent,
          contains('android:scheme="https"'),
          reason: 'AndroidManifest.xml doit déclarer scheme="https"',
        );

        // package WhatsApp
        expect(
          manifestContent,
          contains('android:name="com.whatsapp"'),
          reason: 'AndroidManifest.xml doit déclarer package com.whatsapp',
        );
      },
    );

    test(
      'Info.plist déclare NSCameraUsageDescription, '
      'NSPhotoLibraryUsageDescription et LSApplicationQueriesSchemes '
      '// régression #MOB-004',
      () {
        expect(infoPlistFile.existsSync(), isTrue);
        final plistContent = infoPlistFile.readAsStringSync();

        expect(
          plistContent,
          contains('<key>NSCameraUsageDescription</key>'),
          reason: 'Info.plist doit déclarer NSCameraUsageDescription',
        );

        expect(
          plistContent,
          contains('<key>NSPhotoLibraryUsageDescription</key>'),
          reason: 'Info.plist doit déclarer NSPhotoLibraryUsageDescription',
        );

        expect(
          plistContent,
          contains('<key>LSApplicationQueriesSchemes</key>'),
          reason: 'Info.plist doit déclarer LSApplicationQueriesSchemes',
        );

        expect(
          plistContent,
          contains('<string>tel</string>'),
          reason: 'LSApplicationQueriesSchemes doit inclure tel',
        );

        expect(
          plistContent,
          contains('<string>https</string>'),
          reason: 'LSApplicationQueriesSchemes doit inclure https',
        );

        expect(
          plistContent,
          contains('<string>whatsapp</string>'),
          reason: 'LSApplicationQueriesSchemes doit inclure whatsapp',
        );
      },
    );

    test(
      'Localisations iOS fr et ar définies dans InfoPlist.strings '
      '// régression #MOB-004',
      () {
        expect(
          frInfoPlistStrings.existsSync(),
          isTrue,
          reason: 'ios/Runner/fr.lproj/InfoPlist.strings doit exister',
        );
        final frContent = frInfoPlistStrings.readAsStringSync();
        expect(frContent, contains('NSCameraUsageDescription'));
        expect(frContent, contains('NSPhotoLibraryUsageDescription'));

        expect(
          arInfoPlistStrings.existsSync(),
          isTrue,
          reason: 'ios/Runner/ar.lproj/InfoPlist.strings doit exister',
        );
        final arContent = arInfoPlistStrings.readAsStringSync();
        expect(arContent, contains('NSCameraUsageDescription'));
        expect(arContent, contains('NSPhotoLibraryUsageDescription'));
      },
    );
  });
}
