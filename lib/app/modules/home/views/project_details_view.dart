import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/project_model.dart';
import '../controllers/projects_controller.dart';

class ProjectDetailsView extends StatelessWidget {
  //recuperamos el proyecto desde los argumentos de navegación
  final Project project;
  //Buscamps el controlador en memoria
  final ProjectsController controller = Get.find();

  ProjectDetailsView({required this.project, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskC = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text(project.title ?? "Tareas")),
      body: Column(
        children: [
          // Input para nueva tarea
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskC,
                    decoration: const InputDecoration(
                      hintText: "Nueva tarea...",
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (taskC.text.isNotEmpty) {
                      controller.addTask(project.id!, taskC.text);
                      taskC.clear();
                    }
                  },
                )
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.tasks.isEmpty) {
                return const Center(child: Text("No hay tareas en este proyecto"));
              }
              return ListView.builder(
                itemCount: controller.tasks.length,
                itemBuilder: (context, index) {
                  final task = controller.tasks[index];
                  return CheckboxListTile(
                    title: Text(
                      task.content ?? "",
                      style: TextStyle(
                        decoration: (task.isCompleted ?? false) 
                          ? TextDecoration.lineThrough 
                          : null
                      ),
                    ),
                    value: task.isCompleted,
                    //Lista que permite marcar tareas actualizandolas en bbdd
                    onChanged: (val) => controller.toggleTask(task),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}