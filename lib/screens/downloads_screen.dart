import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leafguard/widgets/shimmers.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  late Future<List<FileSystemEntity>> _futureFiles;
    int shimmerCount = 5;

  @override
  void initState() {
    super.initState();
    _futureFiles = _loadDownloads();
  }

  Future<List<FileSystemEntity>> _loadDownloads() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) return [];

    final downloadsDir = Directory('/storage/emulated/0/Download/LeafGuard');

    if (await downloadsDir.exists()) {
      final files = downloadsDir
          .listSync()
          .where((file) => file.path.endsWith('.pdf'))
          .toList();

      files.sort((a, b) {
        final aTime = File(a.path).lastModifiedSync();
        final bTime = File(b.path).lastModifiedSync();
        return bTime.compareTo(aTime);
      });

      return files;
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: const Color(0xFF388E3C),
          title: null,
          flexibleSpace: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: const Text(
                'Downloads',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 20),
              FutureBuilder<List<FileSystemEntity>>(
                future: _futureFiles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: shimmerCount,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            AppShimmers.imageShimmer(height: 100),
                            SizedBox(height: 12),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(
                        child: Text(
                          'Failed to load files.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          )
                        )
                      )
                    );
                  } else {
                    final files = snapshot.data ?? [];
                    if (files.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const Center(
                          child: Text(
                            'No PDF files found.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            )
                          )
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final fileName = files[index].path.split('/').last;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Material(
                            elevation: 6,
                            shadowColor: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            child: ListTile(
                              minTileHeight: 80,
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              leading: SvgPicture.asset(
                                'assets/images/document-text.svg',
                                height: 40,
                                width: 40,
                                color: const Color(0xFFd54d57),
                              ),
                              title: Text(
                                fileName,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz_rounded)),
                              onTap: () {
                                OpenFile.open('/storage/emulated/0/Download/LeafGuard/$fileName');
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}