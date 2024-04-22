import 'package:flutter/material.dart';

import '../service/downloader.dart';

class DownloadStatusWidget extends StatelessWidget {
  const DownloadStatusWidget({
    super.key,
    required this.downLoader,
  });

  final DownLoader downLoader;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                
                    await downLoader.cancelDownload();
                },
                child: const Text(
                  
                       'Cancel'
                     
                ),
              ),
             
             
              
              
            ],
          ),
        ],
      );
  }
}
