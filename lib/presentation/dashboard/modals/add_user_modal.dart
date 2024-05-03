import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/config/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddUserModal extends StatefulWidget {
  const AddUserModal({super.key});

  @override
  State<AddUserModal> createState() => _AddUserModalState();
}

class _AddUserModalState extends State<AddUserModal> {
  final _supabase = Supabase.instance.client;
  bool _isObscuredPassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int? _rolController;
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _newUserFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _newUserFormKey,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 600,
        ),
        padding: const EdgeInsets.all(
          20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                label: Text('Nombre completo'),
                hintText: 'Juan Jiménez Castro',
                hintStyle: TextStyle(color: Colors.black26),
                labelStyle: TextStyle(color: AppColors.kGrey),
                focusColor: AppColors.kPurple,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kStrongPink),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                suffixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }

                return null;
              },
            ),
            const Gap(20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Correo'),
                hintText: 'ejemplo@ejemplo.com',
                hintStyle: TextStyle(color: Colors.black26),
                labelStyle: TextStyle(color: AppColors.kGrey),
                focusColor: AppColors.kPurple,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kStrongPink),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                suffixIcon: Icon(Icons.email_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }
                if (!EmailValidator.validate(value)) {
                  return 'Ingrese un correo válido';
                }
                return null;
              },
            ),
            const Gap(25),
            TextFormField(
              controller: _passwordController,
              obscureText: _isObscuredPassword ? true : false,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                label: const Text('Contraseña'),
                hintText: '**************',
                hintStyle: const TextStyle(color: Colors.black26),
                labelStyle: const TextStyle(color: AppColors.kGrey),
                focusColor: AppColors.kPurple,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kStrongPink),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscuredPassword = !_isObscuredPassword;
                    });
                  },
                  icon: Icon(
                    _isObscuredPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }
                if (value.length < 6) {
                  return 'Debe ser de al menos 6 caracteres';
                }
                return null;
              },
            ),
            const Gap(20),
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Admin')),
                  DropdownMenuItem(value: 2, child: Text('Operador')),
                ],
                onChanged: (value) {
                  _rolController = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Campo obligatorio';
                  }
                  return null;
                },
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: AppColors.kPurple),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kStrongPink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: () {
                    _tryAddUser();
                  },
                  child: const Text(
                    'Agregar usuario',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

  void _tryAddUser() async {
    if (_newUserFormKey.currentState!.validate()) {
      try {
/*
        //Agregar la info a la tabla de users
        await _supabase.from('users').insert({
          'id_users': userUid,
          'name': _nameController.text,
          'email': _emailController.text.trim(),
          'rol': _rolController,
        }); */
      } on AuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Ocurrió un error: ${e.message}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
  }
}
