import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/auth/code/authHandler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupJson{
  BackupJson._();

  static final BackupJson instance = BackupJson._();

  String? googleJsonFileId;
  late final drive.DriveApi driveApi;
  static const String _DRIVE_SPACE =  "appDataFolder";
  static const String _FILE_NAME = 'idealog.json';
  static const String SHARED_PREF_KEY_NAME = "GoogleJsonFileId";
  drive.File? lastBackupFileIfExists;
  
  /// Create an authenticated client in other to use drive api.
  Future<void> _authenticateDriveUser() async {
    final authHeaders = await GoogleUserData.instance.googleSignInAccount!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    driveApi = drive.DriveApi(authenticateClient);
  }

  Future<void> initialize() async {
    await _authenticateDriveUser();
    SharedPreferences pref = await SharedPreferences.getInstance();
    googleJsonFileId = pref.containsKey(SHARED_PREF_KEY_NAME)? pref.getString(SHARED_PREF_KEY_NAME) : null;

    if (googleJsonFileId == null){
      await _getLastBackupFileIfExists();
      if (lastBackupFileIfExists != null){
       _setGoogleJsonFileId(lastBackupFileIfExists!);
      }
    }

  }

  /// Get the last backup file in google drive if any exists.
  Future<void> _getLastBackupFileIfExists() async {
    bool Function(drive.File) equalsFileName = (e) => e.name!.trim() == _FILE_NAME;
    List<drive.File> allFilesInDriveAppScope = (await driveApi.files.list(spaces: _DRIVE_SPACE)).files!;
    lastBackupFileIfExists = allFilesInDriveAppScope.any(equalsFileName)?allFilesInDriveAppScope.lastWhere(equalsFileName):null;
  }

  /// upload the file to the drive.
  Future<void> uploadToDrive() async {
    // if the file id exists it means we just need to update the file in google drive not create a new one.
    bool isUpdate = googleJsonFileId != null;

    var driveFile = new drive.File()
    ..name = _FILE_NAME
    ..parents = [_DRIVE_SPACE];
    
    String filePath = (await getTemporaryDirectory()).path + "/$_FILE_NAME";
    // Encode to json on a different isolate.
    File jsonFile = new File(filePath)
    ..writeAsStringSync(await compute(convertToJson,await IdealogDb.instance.allIdeasForJson));

    Uint8List jsonFile_AsBytes = await jsonFile.readAsBytes();
    Stream<Uint8List> streamFromBytes = Future.value(jsonFile_AsBytes).asStream();
    drive.Media driveMedia = drive.Media(streamFromBytes,jsonFile_AsBytes.lengthInBytes);

    // if it is an update then update else create the file.
    if(isUpdate){
      await driveApi.files.update(driveFile, googleJsonFileId!, uploadMedia: driveMedia);
    } else {
      final drive.File uploadedFile = await driveApi.files.create(driveFile, uploadMedia: driveMedia);
      _setGoogleJsonFileId(uploadedFile);
    }

    await jsonFile.delete();
  }

  /// Convert a list of strings to json format.
  String convertToJson(List<String> allIdeasForJson) => jsonEncode(allIdeasForJson.toString());
  /// Convert a json string to object.
  dynamic fromJsonToObject(String source) => jsonDecode(source);

  /// Set ID from the uploaded drive.File id.
  Future<void> _setGoogleJsonFileId(drive.File driveFile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    googleJsonFileId = driveFile.id;
    await pref.setString(SHARED_PREF_KEY_NAME, driveFile.id!);
  }

  /// Download the file from the drive.
  Future<void> downloadFromDrive() async {
    // if googleJsonFileId is null it means there is no backUp file on the drive.
    final drive.Media downloadedJson = (await driveApi.files.get(googleJsonFileId!,downloadOptions: drive.DownloadOptions.fullMedia)) as drive.Media;
    String filePath = (await getTemporaryDirectory()).path + "/$_FILE_NAME";
    File jsonFile = new File(filePath);
    downloadedJson.stream.listen((byte)=> jsonFile.writeAsBytesSync(byte,mode: FileMode.writeOnlyAppend),
    onDone: () async { 
      // Convert json string to object on isolate.
      var fileResult = await compute(fromJsonToObject,jsonFile.readAsStringSync());
      print("file result $fileResult");
      jsonFile.deleteSync();
      });
  }
}