class Task {
  int? id;
  int? projectId;
  String? content;
  bool? isCompleted;

  Task({this.id, this.projectId, this.content, this.isCompleted});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    content = json['content'];
    isCompleted = json['is_completed'];
  }

  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'content': content,
      'is_completed': isCompleted
    };
  }
}