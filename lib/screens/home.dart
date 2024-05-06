import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yt_downloader/models/download_history.dart';
// import 'package:yt_downloader/models/downloaded.dart';
import 'package:yt_downloader/models/video_functions.dart';
import 'package:yt_downloader/screens/download_screen.dart';
import 'package:yt_downloader/widgets/ad_container.dart';
import 'package:yt_downloader/widgets/link_section.dart';
import 'package:yt_downloader/widgets/progress_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _textEditingController = TextEditingController();
  Box? downloadBox, videoFnBox;

  //declaring variables
  int _progress = 0;
  DownloadTaskStatus? downloadTaskStatus;
  int? status;

  final ReceivePort _port = ReceivePort();

  //Callback function of download Isolate
  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  void initState() {
    //getting folder path
    downloadBox = Hive.box(DownloadHistory.downloadBoxName);
    videoFnBox = Hive.box(VideoFunctions.videoFnBoxName);

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  void _bindBackgroundIsolate() {
    //Running download in background Isolate
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // String id = data[0];
      downloadTaskStatus = DownloadTaskStatus(data[1]);
      _progress = data[2];
    });
  }

  void snackBarPrompt(String? message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message!)));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Youtube Downloader'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, DownloadScreen.routeName);
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: SizedBox(
          height: size.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Paste video link below'),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _textEditingController.text = '';
                            videoFnBox!.put('isLoading', false);
                            videoFnBox!.put('showDownloadProgress', false);
                          });
                        },
                        child: const Text('Clear'))
                  ],
                ),
                SizedBox(
                  height: size.height * 0.1,
                  child: TextField(
                    controller: _textEditingController,
                    onSubmitted: (value) async {
                      final videoUrlId = _textEditingController.text.trim();
                      if (videoUrlId.isEmpty || value.trim().isEmpty) {
                        snackBarPrompt('please insert a video link.');
                        return;
                      }
                      //get video details
                      await VideoFunctions().getVideoDetails(value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      suffixIcon: IconButton(
                          onPressed: () async {
                            final videoUrlId =
                                _textEditingController.text.trim();
                            if (videoUrlId.isEmpty) {
                              snackBarPrompt('please insert a video link.');
                              return;
                            }
                            //get video details
                            await VideoFunctions().getVideoDetails(videoUrlId);
                          },
                          icon: const Icon(Icons.arrow_circle_right)),
                      hintText: 'https://youtu.be/Xc-05akm',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable:
                        Hive.box(VideoFunctions.videoFnBoxName).listenable(),
                    builder: (context, box, _) {
                      var isLoading = box.get('isLoading', defaultValue: false);
                      return isLoading
                          ? const Column(
                              children: [
                                Center(child: Text('Gathering video Info...')),
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.redAccent,
                                  ),
                                )
                              ],
                            )
                          : Container();
                    }),
                const SizedBox(height: 5),
                ValueListenableBuilder(
                    valueListenable:
                        Hive.box(VideoFunctions.videoFnBoxName).listenable(),
                    builder: (context, box, _) {
                      final isLoading =
                          box.get('isLoading', defaultValue: false);
                      final videoTitle = box.get('videoTitle');
                      final videoThumbnail = box.get('videoThumbnail');
                      final showDownloadProgress =
                          box.get('showDownloadProgress', defaultValue: false);
                      final videoUrlId = _textEditingController.text.trim();
                      return !isLoading && videoUrlId.isNotEmpty
                          ? SizedBox(
                              height: size.height * 0.35,
                              width: size.width,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height * 0.2,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  videoThumbnail!))),
                                    ),
                                    Text('$videoTitle'),
                                    //download button
                                    if (!showDownloadProgress)
                                      MaterialButton(
                                        color: Colors.red,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          videoFnBox!.put(
                                              'showDownloadProgress', true);
                                          //download video
                                          VideoFunctions().downloadVideo();
                                        },
                                        child: const Text('Download'),
                                      ),
                                    //Progress bar
                                    if (showDownloadProgress)
                                      ProgressBar(progress: _progress),
                                    if (showDownloadProgress)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable: Hive.box(
                                                      VideoFunctions
                                                          .videoFnBoxName)
                                                  .listenable(),
                                              builder: (context, box, _) {
                                                final isPause = box.get(
                                                    'isPause',
                                                    defaultValue: false);
                                                return MaterialButton(
                                                  onPressed: () {
                                                    videoFnBox!.put(
                                                        'isPause', !isPause);

                                                    if (isPause) {
                                                      VideoFunctions
                                                          .pauseDownload(
                                                              videoFnBox!.get(
                                                                  'taskId'));
                                                    } else {
                                                      VideoFunctions
                                                          .resumeDownload(
                                                              videoFnBox!.get(
                                                                  'taskId'));
                                                    }
                                                  },
                                                  child: Icon(isPause
                                                      ? Icons.play_arrow
                                                      : Icons.pause),
                                                );
                                              }),
                                          MaterialButton(
                                            onPressed: () {
                                              //cancel download
                                              VideoFunctions.cancelDownload(
                                                  videoFnBox!.get('taskId'));
                                            },
                                            child: const Icon(Icons.stop),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              //retry download
                                              VideoFunctions.retryDownload(
                                                  videoFnBox!.get('taskId'));
                                            },
                                            child: const Icon(Icons.replay),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            )
                          : Container();
                    }),
                const AdContainer(),
                const SizedBox(height: 10),
                const LinkSection(),
              ],
            ),
          )),
    );
  }
}
