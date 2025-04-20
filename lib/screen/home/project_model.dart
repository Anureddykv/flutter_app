import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final List<String>? images;
  final List<String>? videos;
  final GeoPoint? location;

  Project({
    required this.id,
    required this.name,
    required this.description,
    this.images,
    this.videos,
    this.location,

  });

  factory Project.fromMap(String id, Map<String, dynamic> data) {
    return Project(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      videos: data['videos'] != null ? List<String>.from(data['videos']) : null,
      location: data['location'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'images': images,
      'videos': videos,
      'location': location,

    };
  }
}
