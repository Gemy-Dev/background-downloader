import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:file_downloader/service/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const downLoadSenderPort = 'downloader_send_port';

class DownLoader extends ChangeNotifier with WidgetsBindingObserver {
  DownLoader._();
  static final _instance = DownLoader._();
  factory DownLoader() => _instance;
  final ReceivePort _port = ReceivePort();

  String? downloadTaskId;

  int downloadTaskStatus = 0;

  int downloadTaskProgress = 0;

  bool isDownloading = false;
  bool _isAppInForeground = true;

  /// [initDownloadController] method will initialize the downloader controller and perform certain operations like registering the port, initializing the register callback etc.
  initDownloadController() {
    _bindBackgroundIsolate();
  }

  /// [disposeDownloadController] is used to unbind the isolates and dispose the controller
  disposeDownloadController() {
    _unbindBackgroundIsolate();
  }

  /// [_bindBackgroundIsolate] is used to register the [SendPort] with the name [downloader_send_port].
  /// If the registration is successful then it will return true else it will return false.
  _bindBackgroundIsolate() async {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      downLoadSenderPort,
    );

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    } else {
      _port.listen((message) {
        downloadTaskId = message[0];
        downloadTaskStatus = message[1];
        downloadTaskProgress = message[2];
        // check if app is not in foreground if it true show notification to update download progress indecator
        if (!_isAppInForeground) {
          LocalNotificationService.showTextNotification(
              id: 100,
              title: getDownloadStatusString(),
              body: '$downloadTaskProgress/100',
              progress: downloadTaskProgress);
        }
        if (message[1] == 2) {
          isDownloading = true;
        } else {
          isDownloading = false;
        }
        notifyListeners();
      });
      await FlutterDownloader.registerCallback(registerCallback);
    }
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(downLoadSenderPort);
  }

  static registerCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName(downLoadSenderPort);
    send!.send([id, status, progress]);
  }

  Future<void> downloadFile(
      {required String url, bool showNotification = false}) async {
    late String downloadDirPath;
    if (Platform.isIOS) {
      downloadDirPath = (await getDownloadsDirectory())!.path;
    } else {
      downloadDirPath = (await getApplicationDocumentsDirectory()).path;
    }
    try {
      isDownloading = true;
      downloadTaskId = await FlutterDownloader.enqueue(
        url: url,
       // optional: header send with url (auth token etc)
        savedDir: downloadDirPath,
        saveInPublicStorage: true,
        showNotification:
            !_isAppInForeground, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on the notification to open the downloaded file (for Android)
      );

      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  /// [pauseDownload] pauses the current download task
  Future pauseDownload() async {
    try {
      
    log(downloadTaskId ?? '');
    await FlutterDownloader.pause(taskId: downloadTaskId ?? '');

    notifyListeners();
    } catch (e) {
      
    }
  }

  /// [resumeDownload] resumes the paused download task
  Future resumeDownload() async {
    try {
      
    await FlutterDownloader.resume(taskId: downloadTaskId ?? '');
    notifyListeners();
    } catch (e) {
      
    }
  }

  /// [cancelDownload] cancels the current download task
  Future<void> cancelDownload() async {
    try {
    await FlutterDownloader.cancel(taskId: downloadTaskId ?? '');

    downloadTaskStatus = 5; // 5 is canceld
    isDownloading = false;
    notifyListeners();
      
    } catch (e) {
      
    }
  }

  String getDownloadStatusString() {
    late String downloadStatus;

    switch (downloadTaskStatus) {
      case 0:
        downloadStatus = 'Undefined';
        break;
      case 1:
        downloadStatus = 'Enqueued';
        break;
      case 2:
        downloadStatus = 'Downloading';
        break;
      case 3:
        downloadStatus = 'Compleate';
        break;
      case 4:
        downloadStatus = 'Failed';
        break;
      case 5:
        downloadStatus = 'Cancled';
        break;
      case 6:
        downloadStatus = 'Paused';
        break;
      default:
        downloadStatus = "Error";
    }

    return downloadStatus;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      LocalNotificationService.showTextNotification(
          id: 100,
          title: '',
          body: getDownloadStatusString(),
          progress: downloadTaskProgress);
      _isAppInForeground = false;
    } else if (state == AppLifecycleState.resumed) {
      LocalNotificationService.cancleNotification(100);
      _isAppInForeground = true;
    }
  }
}
