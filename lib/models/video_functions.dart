import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoFunctions extends ChangeNotifier {
//returns boxName for VideoFunctions
  static String get videoFnBoxName => 'videoFnBox';

  //open folder directory
  static void selectDownloadDirectory() async {
    //open box
    final videoFnBox = Hive.box(videoFnBoxName);
    final savePath = await FilePicker.platform.getDirectoryPath();

    //create YT Folder in folderpath
    String ytFolder = '$savePath/YT Downloader';
    Directory fp = Directory(ytFolder);
    if (!await fp.exists()) {
      fp.create(recursive: true);
      debugPrint('Folder Created');
    } else {
      debugPrint('Folder Already Exists');
    }
    await videoFnBox.put('savePath', ytFolder);
  }

  //download video function
  Future downloadVideo() async {
    final videoFnBox = Hive.box(videoFnBoxName);
    final videoId = videoFnBox.get('videoId');
    final manifest =
        await YoutubeExplode().videos.streamsClient.getManifest(videoId);
    final MuxedStreamInfo streamInfo = manifest.muxed.bestQuality;

    debugPrint(streamInfo.toString());

    //getting stream url, file path and filename
    final streamUrl = streamInfo.url.toString();
    final savePath = videoFnBox.get('savePath');
    final fileName = videoFnBox.get('fileName');

    //downloading file with FlutterDownloader package
    try {
      final taskId = await FlutterDownloader.enqueue(
        url: streamUrl,
        savedDir: savePath,
        fileName: fileName,
      );
      videoFnBox.put('taskId', taskId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //pause download functions
  static void pauseDownload(String? taskId) async {
    await FlutterDownloader.pause(taskId: taskId!);
  }

  //resume download functions
  static void resumeDownload(String? taskId) async {
    await FlutterDownloader.resume(taskId: taskId!);
  }

  //retry download function
  static void retryDownload(String? taskId) async {
    await FlutterDownloader.retry(taskId: taskId!);
  }

  //stop/cancel download function
  static void cancelDownload(String? taskId) async {
    await FlutterDownloader.cancel(taskId: taskId!);
  }

  //open downloaded file
  static void openDownloadedFile(String? taskId) async {
    await FlutterDownloader.open(taskId: taskId!);
  }

  VideoId getVideoIdFn(String videoUrlId) {
    final videoFnBox = Hive.box(videoFnBoxName);
    try {
      final videoId = VideoId(videoUrlId);
      videoFnBox.put('videoId', videoId.value);
      return videoId;
    } catch (err) {
      if (err == YoutubeExplodeException) {
        rethrow;
      } else {
        rethrow;
      }
    }
  }

  //get video information function
  Future<void> getVideoDetails(String videoUrlId) async {
    final videoId = getVideoIdFn(videoUrlId);
    final videoFnBox = Hive.box(videoFnBoxName);
    try {
      videoFnBox.put('isLoading', true);
      final videoData =
          await YoutubeExplode().videos.get(videoId).whenComplete(() {
        videoFnBox.put('isLoading', false);
      });

      //Editing the file name and removing illegal characters
      String fileName = '${videoData.title}.mp4'
          .replaceAll(r'\', '')
          .replaceAll('/', '')
          .replaceAll('*', '')
          .replaceAll('?', '')
          .replaceAll('"', '')
          .replaceAll('<', '')
          .replaceAll('>', '')
          .replaceAll('|', '');

      //inserting values inside box
      videoFnBox.put('fileName', fileName);
      videoFnBox.put('videoThumbnail', videoData.thumbnails.highResUrl);
      videoFnBox.put('videoTitle', videoData.title);
    } on YoutubeExplodeException catch (_) {
      rethrow;
    } catch (err) {
      if (err == FormatException) {
        rethrow;
      } else {
        rethrow;
      }
    }
  }
}
