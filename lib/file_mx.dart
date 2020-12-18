import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageMx {

  // Check if storage permission is granted.
  Future<bool> checkStoragePermission() async {
    final permissionResult = await Permission.storage.request();
    return (permissionResult.isGranted) ? true : false;
  }

  // get user directory
  Future<String> getUserDirectoryPath() async {
    if (await checkStoragePermission()) {
      final Directory userDirectory = (Platform.isAndroid)
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      return userDirectory.path;
    } else {
      return "";
    }
  }

}

class FileMx {

  final String userDirectory;

  FileMx(this.userDirectory);

  // Functions related to operations on directories:

  // Get the path of a folder in user directory.
  Future<String> getUserDirectoryFolder(String folderName) async {
    // Create folder in user directory if it does not exist.
    final String folderPath = join(userDirectory, folderName);
    await createDirectory(folderPath);
    return folderPath;
  }

  // Create directory if it doesn't exist.
  // Reference: https://api.flutter.dev/flutter/dart-io/Directory-class.html
  Future<void> createDirectory(String folderPath) async {
    final Directory targetDirectory = Directory(folderPath);
    final bool targetDirectoryExists = await targetDirectory.exists();
    if (!targetDirectoryExists) targetDirectory.create(recursive: true);
  }

  // Note that "list" and "listSync" are different.
  // list: https://api.flutter.dev/flutter/dart-io/Directory/list.html
  // listSync: https://api.flutter.dev/flutter/dart-io/Directory/listSync.html
  Map<String, String> getDirectoryItems(String folderPath) {
    Map<String, String> directoryItems = {};
    final Directory targetDirectory = Directory(folderPath);
    final List<FileSystemEntity> directoryItemList = targetDirectory.listSync(followLinks: false);
    for (FileSystemEntity item in directoryItemList) {
      if (item is File) {
        final String filePath = item.path;
        directoryItems[basename(filePath)] = filePath;
      }
    }
    return directoryItems;
  }

  // Functions related to file operations:

  // Copy a file from assets folder to user directory.
  // e.g. FileMx().copyAssetsFileToUserDirectory("bibles", "KJV.bible");
  Future<String> copyAssetsFileToUserDirectory(
      String folderName, String filename) async {

    // Get the path of user directory folder
    final String folderPath = await getUserDirectoryFolder(folderName);

    // Write a file from the copied data.
    final filePath = join(folderPath, filename);
    final File targetFile = File(filePath);
    final bool targetFileExists = await targetFile.exists();
    if (!targetFileExists) {
      final ByteData data =
      await rootBundle.load("assets/$folderName/$filename");
      writeByteDataToFile(data, filePath);
    }
    return filePath;
  }

  // Write byte data to a file.
  // Note that "writeAsBytes" and "writeAsBytesSync" are different.
  // writeAsBytes: https://api.flutter.dev/flutter/dart-io/File/writeAsBytes.html
  // writeAsBytesSync: https://api.flutter.dev/flutter/dart-io/File/writeAsBytesSync.html
  void writeByteDataToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    File(path).writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)); // Do not set flush to true.
  }

}