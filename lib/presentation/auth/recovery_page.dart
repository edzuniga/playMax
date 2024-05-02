import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/config/colors.dart';
import 'package:playmax_app_1/config/routes.dart';

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key});

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final GlobalKey<FormState> _recoveryFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 25,
        ),
        width: 450,
        height: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Form(
          key: _recoveryFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Image.asset('assets/img/logo_playmax.png'),
                  ),
                ),
                const Gap(60),
                const Center(
                  child: Text(
                    'Recuperar contraseña',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Gap(45),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.black),
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
                const Gap(60),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: AppColors.kStrongPink,
                    ),
                    onPressed: () {
                      _tryPasswordRecovery();
                    },
                    child: const Text(
                      'Recuperar contraseña',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Gap(20),
                Container(
                  alignment: Alignment.centerRight,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      context.goNamed(Routes.login);
                    },
                    child: const Text(
                      'Regresar',
                      style: TextStyle(
                        color: AppColors.kStrongPink,
                      ),
                    ),
                  ),
                ),
                const Gap(40),
                const Divider(
                  color: Colors.black12,
                ),
                const Center(
                    child: Text(
                  'Derechos Reservados | UP Studios',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 12,
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _tryPasswordRecovery() {
    if (_recoveryFormKey.currentState!.validate()) {}
  }
}
