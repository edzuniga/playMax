import 'package:flutter/material.dart';
import 'package:playmax_app_1/config/colors.dart';
import 'package:playmax_app_1/presentation/widgets/titulo_tabla_widget.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          width: screenSize.width * 0.9,
          height: 700,
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
                        onPressed: () {},
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
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.05,
                              child: Text('${index + 1}'),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.35,
                              child: const Text(
                                  'Aviazas Abimelec Espinoza Banegas'),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.25,
                              child: const Text('ejemplo@ejemplolargo.com'),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(5),
                              width: screenSize.width * 0.1,
                              child: const Text('operador'),
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
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
