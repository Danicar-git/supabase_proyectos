import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/projects_controller.dart';
//import 'project_details_view.dart';
import '../../../routes/app_pages.dart';

class ProjectsView extends StatelessWidget {
  final controller = Get.put(ProjectsController());

  ProjectsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Proyectos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              controller.client.auth.signOut();
              Get.offAllNamed(Routes.LOGIN);
            },
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        
        return ListView.builder(
          itemCount: controller.projects.length,
          itemBuilder: (context, index) {
            final project = controller.projects[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // mostrar imagen si existe, con manejo de error para imágenes no cargadas
                  if (project.imageUrl != null)
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Image.network(
                        project.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    
                  ListTile(
                    title: Text(project.title ?? "Sin título", 
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(project.description ?? ""),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteProject(project.id!),
                    ),
                    onTap: () {
                      controller.fetchTasks(project.id!);
                      Get.toNamed(Routes.PROJECT_DETAILS, arguments: project);
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(context),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleC = TextEditingController();
    final descC = TextEditingController();
    // Variable local para guardar la ruta de la imagen seleccionada temporalmente
    RxString imagePath = ''.obs; 

    Get.defaultDialog(
      title: "Nuevo Proyecto",
      content: Column(
        children: [
          TextField(controller: titleC, decoration: const InputDecoration(labelText: "Título")),
          TextField(controller: descC, decoration: const InputDecoration(labelText: "Descripción")),
          const SizedBox(height: 10),
          
          // Boton seleccion imagen
          Obx(() => Column(
            children: [
              if (imagePath.isNotEmpty) 
                Text("Imagen seleccionada!", style: TextStyle(color: Colors.green)),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Añadir Foto"),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    imagePath.value = image.path;
                  }
                },
              ),
            ],
          )),
        ],
      ),
      textConfirm: "Guardar",
      textCancel: "Cancelar",
      onConfirm: () {
        // Llamamos a la nueva función
        controller.createProjectWithImage(titleC.text, descC.text, imagePath.value);
      },
    );
  }
}