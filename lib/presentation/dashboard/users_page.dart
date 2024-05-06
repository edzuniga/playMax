import 'package:flutter/material.dart';
import 'package:playmax_app_1/presentation/dashboard/modals/add_user_modal.dart';
import 'package:playmax_app_1/presentation/utils/supabase_instance.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:playmax_app_1/config/colors.dart';
import 'package:playmax_app_1/presentation/widgets/titulo_tabla_widget.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _supabase = SupabaseManager().supabaseClient;
  late PostgrestFilterBuilder<List<Map<String, dynamic>>> _getUsers;

  @override
  void initState() {
    super.initState();
    _getUsers = _supabase.from('users').select();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          width: screenSize.width * 0.9,
          height: screenSize.height * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Listado de usuarios',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: AppColors.kStrongPink,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        onPressed: () {
                          _addUser();
                        },
                        child: const Text(
                          'Agregar usuario',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(color: Colors.black12),
                width: double.infinity,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TituloColumnaTabla(
                      ancho: screenSize.width * 0.05,
                      titulo: '#',
                    ),
                    TituloColumnaTabla(
                      ancho: screenSize.width * 0.35,
                      titulo: 'Nombre',
                    ),
                    TituloColumnaTabla(
                      ancho: screenSize.width * 0.25,
                      titulo: 'Correo',
                    ),
                    TituloColumnaTabla(
                      ancho: screenSize.width * 0.1,
                      titulo: 'Rol',
                    ),
                    TituloColumnaTabla(
                      ancho: screenSize.width * 0.05,
                      titulo: '',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _getUsers,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Ocurrió un error, purueba más tarde.'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                            'No hay usuario aún. Agrega uno para visualizarlo.'),
                      );
                    } else {
                      List<Map<String, dynamic>> usersList = snapshot.data;

                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: usersList.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> user = usersList[index];
                            //String de rol condicionado
                            String rolString = '';
                            Color rolColor = Colors.purple.shade100;
                            switch (user['rol']) {
                              case 1:
                                rolString = 'Admin';
                                rolColor = Colors.blue.shade100;
                                break;
                              case 2:
                                rolString = 'Operador';
                                break;
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: screenSize.width * 0.05,
                                  child: Text('${index + 1}'),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.35,
                                  child: Text(user['name']),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.25,
                                  child: Text(user['email']),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: rolColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  width: screenSize.width * 0.1,
                                  child: Text(rolString),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.05,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text('...'),
                                  ),
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addUser() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const AlertDialog(
        scrollable: true,
        title: Text(
          'Agregar usuario',
          style: TextStyle(color: Colors.white),
        ),
        content: AddUserModal(),
      ),
    );
  }
}
