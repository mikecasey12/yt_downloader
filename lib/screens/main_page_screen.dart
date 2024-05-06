import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:yt_downloader/models/admob_service.dart';
import 'package:yt_downloader/models/video_functions.dart';
import 'package:yt_downloader/screens/home.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({super.key});

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  BannerAd? _banner;
  Box? videoFnBox;
  String? savePath;

  @override
  void initState() {
    super.initState();
    videoFnBox = Hive.box(VideoFunctions.videoFnBoxName);
    savePath = videoFnBox!.get('savePath');
    if (savePath == null) {
      VideoFunctions.selectDownloadDirectory();
    }
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId!,
        listener: AdMobService.bannerAdListener,
        request: const AdRequest())
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Home(),
      bottomNavigationBar: Container(
        height: 55,
        margin: const EdgeInsets.only(bottom: 5),
        child: _banner == null ? Container() : AdWidget(ad: _banner!),
      ),
    );
  }
}
