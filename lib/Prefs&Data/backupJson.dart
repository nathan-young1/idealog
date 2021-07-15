import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:idealog/Databases/idealog-db/idealog_Db.dart';
import 'package:idealog/Prefs&Data/GoogleUserData.dart';
import 'package:idealog/auth/code/authHandler.dart';
import 'package:idealog/core-models/ideaModel.dart';
import 'package:path_provider/path_provider.dart';

class BackupJson{
  BackupJson._();

  static final BackupJson instance = BackupJson._();

  String? _googleJsonFileId;
  late final drive.DriveApi _driveApi;
  static const String _DRIVE_SPACE =  "appDataFolder";
  static const String _FILE_NAME = 'Idealog.json';
  drive.File? _lastBackupFileIfExists;

  
  /// Create an authenticated client in other to use drive api.
  Future<void> _authenticateDriveUser() async {
    final authHeaders = await GoogleUserData.instance.googleSignInAccount!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    _driveApi = drive.DriveApi(authenticateClient);
  }

  Future<void> initialize() async {
    await _authenticateDriveUser();
    await _getLastBackupFileIfExists();
  }

  /// Get the last backup file in google drive if any exists and set the google json id.
  Future<void> _getLastBackupFileIfExists() async {
    bool Function(drive.File) equalsFileName = (e) => e.name!.trim() == _FILE_NAME;

    List<drive.File> filesInAppScope = (await _driveApi.files.list(spaces: _DRIVE_SPACE)).files!;
    _lastBackupFileIfExists = filesInAppScope.any(equalsFileName)?filesInAppScope.lastWhere(equalsFileName):null;

     if (_lastBackupFileIfExists != null){
       _setGoogleJsonFileId(_lastBackupFileIfExists!);
      }
  }

  /// Set ID from the uploaded drive.File id.
  void _setGoogleJsonFileId(drive.File driveFile) => _googleJsonFileId = driveFile.id;

  /// Download the file from the drive.
  Future<void> downloadFromDrive() async {

    // if _googleJsonFileId is null it means there is no backUp file on the drive.
    if(_googleJsonFileId != null){
      final drive.Media downloadedJson = (await _driveApi.files.get(_googleJsonFileId!,downloadOptions: drive.DownloadOptions.fullMedia)) as drive.Media;
      String filePath = (await getTemporaryDirectory()).path + "/$_FILE_NAME";
      File jsonFile = new File(filePath);

      // If the temporary file exists then delete it.
      if(await jsonFile.exists()) jsonFile.deleteSync();

      await for(var byte in downloadedJson.stream){
        await jsonFile.writeAsBytes(byte,mode: FileMode.writeOnlyAppend);
      }

      // Convert json string to object on isolate.
        List<Idea> fileResult = (await compute(_fromJsonToObject,jsonFile.readAsStringSync()))
        .map((idea) =>  Idea.fromJson(json: idea))
        .toList();
        
        await jsonFile.delete();

        //Write all ideas from json to the database.
        fileResult.forEach((idea) async => await IdealogDb.instance.writeToDb(idea: idea));
    } else {
        try {
          throw _DriveBackupDoesNotExist();
        } on _DriveBackupDoesNotExist catch (e) {
          print(e);
        }
    }
  }

  Future<void> deleteFile() async {
    await _driveApi.files.delete(_googleJsonFileId!);
    print('delete');
  }

  /// This is a debugging method
  Future<void> _listAllFiles() async {
    List<drive.File> filesInAppScope = (await _driveApi.files.list(spaces: _DRIVE_SPACE)).files!;
    List<String?> ids = filesInAppScope.map((e) => e.id).toList();
    print(ids);
  }

}


  /// Convert a json string to object.
List<dynamic> _fromJsonToObject(String source) => json.decode(source) as List<dynamic>;




/// Custom Exception class For when [Backup file] does not exist.
class _DriveBackupDoesNotExist implements Exception {

  String _message = "No backup file exists in the drive";
  
  @override
  String toString() {
    return _message;
  }

  String get message => _message;

}