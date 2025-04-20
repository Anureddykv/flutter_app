import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UploadSampleProjectsScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

   UploadSampleProjectsScreen({super.key});

  Future<void> uploadSampleProjects() async {
    final List<Map<String, dynamic>> sampleProjects = [
      {
        'id': '1',
        'name': 'AI Assistant',
        'description': 'A voice-activated AI bot.',
      },
      {
        'id': '2',
        'name': 'Banking App',
        'description': 'Manage your finances easily.',
      },
      {
        'id': '3',
        'name': 'E-Commerce App',
        'description': 'An online store platform.',
      },
      {
        'id': '4',
        'name': 'Food Delivery App',
        'description': 'Order food from your favorite restaurants.',
      },
      {
        'id': '5',
        'name': 'Weather App',
        'description': 'Check the weather forecast.',
      },
      {
        'id': '6',
        'name': 'News App',
        'description': 'Stay updated with the latest news.',
      },
      {
        'id': '7',
        'name': 'Music Player',
        'description': 'Listen to your favorite music.',
      },
      {
        'id': '8',
        'name': 'Video Player',
        'description': 'Watch your favorite videos.',
      },
      {
        'id': '9',
        'name': 'Photo Editor',
        'description': 'Edit your photos easily.',
      },
      {
        'id': '10',
        'name': 'Calendar App',
        'description': 'Manage your schedule and events.',
      }
    ];

    for (var project in sampleProjects) {
      await firestore.collection('projects').add(project);
    }

    print("Sample projects uploaded to Firestore!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Sample Projects")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await uploadSampleProjects();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Sample projects added!")),
            );
          },
          child: Text("Upload Sample Projects"),
        ),
      ),
    );
  }
}
