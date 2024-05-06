import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:yt_downloader/models/downloaded.dart';
import 'package:yt_downloader/models/video_functions.dart';
import 'package:yt_downloader/screens/download_screen.dart';
import 'package:yt_downloader/screens/main_page_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await Hive.initFlutter();
  Hive.registerAdapter(DownloadedFileAdapter());
  await Hive.openBox('downloaded');
  await Hive.openBox(VideoFunctions.videoFnBoxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainPageScreen(),
      routes: {
        DownloadScreen.routeName: (context) => const DownloadScreen(),
      },
    );
  }
}
