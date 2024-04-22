import 'package:file_downloader/service/notification.dart';
import 'package:flutter/material.dart';

import 'package:flutter_downloader/flutter_downloader.dart';

import 'screen/file_download_screen.dart';
const debug = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: debug);
 await
 
 
  LocalNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FileDownloadScreen(
      ),
    );
  }
}