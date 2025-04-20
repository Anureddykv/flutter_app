import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';

import 'project_model.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Future<String> uploadMedia(XFile file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = file.name;
      final fileRef = storageRef.child('uploads/$fileName');
      final uploadTask = fileRef.putFile(File(file.path));
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading media: $e');
      return '';
    }
  }

  Future<void> downloadMedia(String url, String filename) async {
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: '/storage/emulated/0/Download',
      // Define the directory to save
      fileName: filename,
      showNotification: true,
      // Show a notification when downloading
      openFileFromNotification: true, // Optionally open the file after download
    );
    print('Download task ID: $taskId');
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Images'), Tab(text: 'Videos')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          project.images?.isEmpty ?? true
              ? Center(child: Text("No data found"))
              : ListView(
                children:
                    project.images!
                        .map(
                          (img) => ListTile(
                            title: Text('Image: $img'),
                            leading: Icon(Icons.image),
                            onTap: () {
                              // Optionally, navigate to image viewer
                            },
                          ),
                        )
                        .toList(),
              ),
          project.videos?.isEmpty ?? true
              ? Center(child: Text("No data found"))
              : ListView(
                children:
                    project.videos!
                        .map(
                          (vid) => ListTile(
                            title: Text('Video: $vid'),
                            leading: Icon(Icons.play_circle_fill),
                            onTap: () {
                              // Optionally, navigate to video player
                            },
                          ),
                        )
                        .toList(),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final picker = ImagePicker();
          final pickedFile = await picker.pickImage(
            source: ImageSource.gallery,
          );
          if (pickedFile != null) {
            final downloadUrl = await uploadMedia(pickedFile);
            if (downloadUrl.isNotEmpty) {
              await downloadMedia(downloadUrl, pickedFile.name);
            }
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
