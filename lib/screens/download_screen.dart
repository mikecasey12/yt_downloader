import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yt_downloader/models/download_history.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});
  static const routeName = '/downloads';

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  Box? downloadBox;
  List? downloadedFiles;
  @override
  void initState() {
    downloadBox = Hive.box(DownloadHistory.downloadBoxName);
    downloadedFiles = downloadBox!.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Downloads'),
      ),
      body: SizedBox(
        height: size.height,
        child: downloadedFiles!.isEmpty
            ? const Center(
                child: Text('No download history'),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      height: size.height * 0.2,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  downloadedFiles![index].videoThumbnail))),
                    ),
                    title: Text(
                      '${downloadedFiles![index].videoTitle}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    trailing: TextButton(
                      onPressed: () async {
                        await FlutterDownloader.open(
                            taskId: downloadedFiles![index].taskId);
                      },
                      child: const Text('Open'),
                    ),
                  );
                },
                itemCount: downloadedFiles!.length),
      ),
    );
  }
}
