// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import 'package:supabase_notes/app/modules/add_note/bindings/add_note_binding.dart';
import 'package:supabase_notes/app/modules/add_note/views/add_note_view.dart';
import 'package:supabase_notes/app/modules/edit_note/bindings/edit_note_binding.dart';
import 'package:supabase_notes/app/modules/edit_note/views/edit_note_view.dart';
import 'package:supabase_notes/app/modules/login/bindings/login_binding.dart';
import 'package:supabase_notes/app/modules/login/views/login_view.dart';
import 'package:supabase_notes/app/modules/profile/bindings/profile_binding.dart';
import 'package:supabase_notes/app/modules/profile/views/profile_view.dart';
import 'package:supabase_notes/app/modules/register/bindings/register_binding.dart';
import 'package:supabase_notes/app/modules/register/views/register_view.dart';

//import 'package:supabase_notes/app/modules/home/bindings/home_binding.dart';
//import 'package:supabase_notes/app/modules/home/views/home_view.dart';
//añadimos los nuevos links a projects
import '../modules/home/controllers/projects_controller.dart';
import '../modules/home/views/projects_view.dart';
import '../modules/home/views/project_details_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => ProjectsView(),
      binding: BindingsBuilder(() {
        // Modificamos el home para abrir proyectos
        Get.put(ProjectsController());
      }),
    ),
    // ruta nueva de detalles del proyecto
    GetPage(
      name: _Paths.PROJECT_DETAILS,
      // Recibimos el objeto 'project' a través de los argumentos de navegación
      page: () => ProjectDetailsView(project: Get.arguments),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ADD_NOTE,
      page: () => AddNoteView(),
      binding: AddNoteBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_NOTE,
      page: () => EditNoteView(),
      binding: EditNoteBinding(),
    ),
  ];
}
