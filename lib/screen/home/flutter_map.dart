import 'package:flutter/material.dart';
import 'package:flutter_app_project/screen/home/project_detail.dart';
import 'package:flutter_app_project/screen/home/project_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  Future<List<Project>> fetchProjects() async {
    final snapshot = await FirebaseFirestore.instance.collection('projects').get();
    return snapshot.docs.map((doc) => Project.fromMap(doc.id, doc.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Project Map')),
      body: FutureBuilder<List<Project>>(
        future: fetchProjects(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final projects = snapshot.data!
              .where((p) => p.location != null)
              .toList();

          if (projects.isEmpty) return Center(child: Text("No projects with location data"));

          return FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                projects[0].location!.latitude,
                projects[0].location!.longitude,
              ),
              initialZoom: 10.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.flutter_app_project',
              ),
              MarkerLayer(
                markers: projects.map((project) {
                  return Marker(
                    point: LatLng(
                      project.location!.latitude,
                      project.location!.longitude,
                    ),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ProjectDetailScreen(project: project));
                      },
                      child: Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
