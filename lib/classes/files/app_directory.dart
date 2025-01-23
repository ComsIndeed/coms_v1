import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class AppDirectoryProvider with ChangeNotifier {
  Directory mainDirectory;
  Directory tempDirectory;

  AppDirectoryProvider._(this.mainDirectory, this.tempDirectory);

  static AppDirectoryProvider initialize(
      {Directory? newMainDirectory, Directory? newTempDirectory}) {
    final defaultMainDirectory = Directory("/storage/emulated/0/Pyrite/");
    final finalMainDirectory = newMainDirectory ?? defaultMainDirectory;

    final defaultTempDirectory = Directory("temp");
    final finalTempPath = path.join(finalMainDirectory.path,
        newTempDirectory?.path ?? defaultTempDirectory.path);
    final finalTempDirectory = Directory(finalTempPath);

    final appDirectoryProvider =
        AppDirectoryProvider._(finalMainDirectory, finalTempDirectory);

    !finalMainDirectory.existsSync()
        ? finalMainDirectory.createSync(recursive: true)
        : null;

    !finalTempDirectory.existsSync()
        ? finalTempDirectory.createSync(recursive: true)
        : null;

    return appDirectoryProvider;
  }

  void notifyChanges() => notifyChanges();
}
