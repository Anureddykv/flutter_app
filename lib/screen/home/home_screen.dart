import 'package:flutter/material.dart';
import 'package:flutter_app_project/screen/home/chart_screen.dart';
import 'package:flutter_app_project/screen/home/flutter_map.dart';
import 'package:flutter_app_project/screen/home/home_controller.dart';
import 'package:get/get.dart';
import '../../auth/auth_controller.dart';
import 'project_detail.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    controller.fetchProjects();
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => Get.to(() => MapScreen()),
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () => Get.to(() => ChartScreen()),
          ),
          IconButton(
            onPressed: () {
              AuthController.to.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) => controller.searchText.value = val,
              decoration: InputDecoration(
                labelText: 'Search Project',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () =>
                  controller.projects.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: controller.filteredProjects.length,
                        itemBuilder: (context, index) {
                          final project = controller.filteredProjects[index];
                          return ListTile(
                            title: Text(project.name),
                            subtitle: Text(project.description),
                            onTap: () {
                              Get.to(
                                () => ProjectDetailScreen(project: project),
                              );
                            },
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}


