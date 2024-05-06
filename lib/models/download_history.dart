import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'downloaded.dart';

class DownloadHistory {
  static String get downloadBoxName => 'downloaded';
  final List<DownloadedFile> _downloadedFiles = [];

  List<DownloadedFile> get downloadedFiles => _downloadedFiles;

  void addDownloadHistory(DownloadedFile? downloadFile) async {
    // if (_downloadedFiles.keys.contains(downloadFile!.taskId)) {
    //   debugPrint('Contains key');
    //   return;
    // } else {
    var downloadBox = Hive.box(downloadBoxName);
    downloadBox.put(downloadFile!.id, downloadFile);
  }

  int getAllList() {
    var length = _downloadedFiles.length;
    debugPrint('$length');
    return length;
  }
}
