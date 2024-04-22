
import 'package:file_downloader/service/downloader.dart';
import 'package:flutter/material.dart';

import '../widget/download_status_widget.dart';
class FileDownloadScreen extends StatefulWidget {

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

final url='https://file-examples.com/storage/fee868065066261f19c04c3/2017/04/file_example_MP4_1920_18MG.mp4';
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
                            url:url,
                          );
                        },
                        child: const Text(
                          "Download File",
                        ),
                      ),
                    )
                  : DownloadStatusWidget(downLoader: downLoader);
            }),
      ),
    );
  }
}

