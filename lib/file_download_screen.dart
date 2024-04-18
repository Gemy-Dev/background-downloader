import 'dart:developer';

import 'package:file_downloader/service/downloader.dart';
import 'package:file_downloader/service/observer.dart';
import 'package:flutter/material.dart';

class FileDownloadScreen extends StatefulWidget {
  /// [url] is the url of the file to be downloaded


  /// [index] is the index of the selected file url.



  const FileDownloadScreen({
    super.key,



  });

  @override
  State<FileDownloadScreen> createState() => _FileDownloadScreenState();
}

class _FileDownloadScreenState extends State<FileDownloadScreen> {

  final DownLoader downLoader = DownLoader();
  @override
  void initState() {
    if(!downLoader.isDownloading){

    downLoader.initDownloadController();
    }
   WidgetsBinding.instance.addObserver(downLoader);
    super.initState();
  }
  

  @override
  void dispose() {
    downLoader.disposeDownloadController();
       WidgetsBinding.instance.addObserver(downLoader);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File DownLoader"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListenableBuilder(
            listenable: downLoader,
            builder: (context, _) {
              return !downLoader.isDownloading && downLoader.getDownloadStatusString()!='Paused'
                  ? Center(
                      child: FilledButton(
                        onPressed: () {
                          downLoader.downloadFile(
                            url:'https://file-examples.com/storage/fef545ae0b661d470abe676/2017/04/file_example_MP4_1920_18MG.mp4',
                          );
                        },
                        child: const Text(
                          "Download File",
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(
                          value: downLoader.downloadTaskProgress / 100,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          downLoader.getDownloadStatusString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                downLoader.getDownloadStatusString() ==
                                        'Downloading'
                                    ? await downLoader.pauseDownload()
                                    : await downLoader.resumeDownload();
                              },
                              child: Text(
                                downLoader.getDownloadStatusString() ==
                                        'Downloading'
                                    ? 'Puase'
                                    : 'Reusem',
                              ),
                            ),
                           
                            IconButton(
                              onPressed: () async {
                                await downLoader.cancelDownload();
                              },
                              icon: const Icon(
                                Icons.cancel,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
            }),
      ),
    );
  }
}
