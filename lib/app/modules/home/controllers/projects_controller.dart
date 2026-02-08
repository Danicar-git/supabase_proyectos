import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:image_picker/image_picker.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/task_model.dart';

class ProjectsController extends GetxController {
  // Conector Supabase para las operaciones de base de datos
  final SupabaseClient client = Supabase.instance.client;
 //Variables reacrtivas que actualizan la vista automáticamente al cambiar su valor
  RxList<Project> projects = <Project>[].obs;
  //carga de tareas de proyecto seleccionado
  RxList<Task> tasks = <Task>[].obs; 
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  // Carga de proyectos filtrando por el ID de usuario logueado
  Future<void> fetchProjects() async {
    isLoading.value = true;
    try {
      final userId = client.auth.currentUser!.id;
      final response = await client
          .from('projects')
          .select()
          .eq('user_id', userId)
          .order('id', ascending: false);
      
      final data = response as List;
      projects.value = data.map((e) => Project.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar("Error", "Error cargando proyectos: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createProject(String title, String desc) async {
    try {
      final userId = client.auth.currentUser!.id;
      await client.from('projects').insert({
        'user_id': userId,
        'title': title,
        'description': desc
      });
      fetchProjects(); // Recargar lista
      Get.back(); // Cerrar dialogo
    } catch (e) {
      Get.snackbar("Error", "No se pudo crear el proyecto");
    }
  }

  //nueva funcion para carga de imagenes
  Future<void> createProjectWithImage(String title, String desc, String imagePath) async {
    isLoading.value = true;
    try {
      final userId = client.auth.currentUser!.id;
      String? publicUrl;

      if (imagePath.isNotEmpty) {
        final fileName = 'project_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File(imagePath);
        await client.storage.from('images').upload(fileName, file);
        publicUrl = client.storage.from('images').getPublicUrl(fileName);
      }

      await client.from('projects').insert({
        'user_id': userId,
        'title': title,
        'description': desc,
        'image_url': publicUrl,
      });

      fetchProjects(); 
      Get.back();
      Get.snackbar("Éxito", "Proyecto creado con imagen");
    } catch (e) {
      Get.snackbar("Error", "Fallo al crear proyecto: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProject(int id) async {
    await client.from('projects').delete().eq('id', id);
    fetchProjects();
  }

 // Carga de tareas por id de proyecto
  Future<void> fetchTasks(int projectId) async {
    isLoading.value = true;
    //limpiar tareas anteriores al cargar nuevas
    tasks.clear();  
    try {
      final response = await client
          .from('tasks')
          .select()
          .eq('project_id', projectId)
          .order('id');
      
      final data = response as List;
      tasks.value = data.map((e) => Task.fromJson(e)).toList();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(int projectId, String content) async {
    await client.from('tasks').insert({
      'project_id': projectId,
      'content': content,
      'is_completed': false
    });
    fetchTasks(projectId); //recarga de tareas del proyecto actual
  }

// Logica de si una tarea está completada
  Future<void> toggleTask(Task task) async {
    await client.from('tasks').update({
      'is_completed': !(task.isCompleted ?? false)
    }).eq('id', task.id!);
    task.isCompleted = !(task.isCompleted ?? false);
    tasks.refresh();
  }
}