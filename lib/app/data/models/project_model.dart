class Project {
  int? id;
  String? title;
  String? description;
  String? imageUrl;

  Project({this.id, this.title, this.description});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'image_url': imageUrl};
  }
}