import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'project_model.dart';

class HomeController extends GetxController {
  var searchText = ''.obs;
  var projects = <Project>[].obs;

  // Fetch projects from Firestore
  Future<void> fetchProjects() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('projects').get();
      projects.clear();
      for (var doc in snapshot.docs) {
        projects.add(
          Project.fromMap(
            doc.id,
            doc.data(),
          ),
        );
      }
    } catch (e) {
      print("Error fetching projects: $e");
    }
  }

  List<Project> get filteredProjects =>
      projects
          .where(
            (project) => project.name.toLowerCase().contains(
              searchText.value.toLowerCase(),
            ),
          )
          .toList();
}
