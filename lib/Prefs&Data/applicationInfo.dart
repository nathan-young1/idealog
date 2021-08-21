import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

/// Information about this application, like the name, version, build number e.t.c.
class ApplicationInfo{
  static late final String fullName_And_version;
  static late final String appName;
  static late final String buildNumber;
  static late final String version;
  static late final String packageName;


  static Future<void> initialize() async {
    PackageInfo appInfo = await PackageInfo.fromPlatform();
    appName = appInfo.appName;
    buildNumber = appInfo.buildNumber;
    version = appInfo.version;
    packageName = appInfo.packageName;
    fullName_And_version = "$appName v${version.split('.').take(2).join(".").toString()}";
  }
}