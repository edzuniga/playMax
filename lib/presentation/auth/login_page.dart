import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/config/colors.dart';
import 'package:playmax_app_1/config/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controlador para el switch
  bool _switchValue = false;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 25,
        ),
        width: 450,
        height: 750,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Form(
          key: _loginFormKey,
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
                    'Login',
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
                const Gap(30),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
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
                      onPressed: () {},
                      icon: const Icon(Icons.visibility),
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
                const Gap(40),
                SizedBox(
                  width: screenSize.width,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 0.7,
                              child: CupertinoSwitch(
                                // This bool value toggles the switch.
                                value: _switchValue,
                                activeColor: AppColors.kStrongPink,
                                onChanged: (bool? value) {
                                  // This is called when the user toggles the switch.
                                  setState(() {
                                    _switchValue = value ?? false;
                                  });
                                },
                              ),
                            ),
                            const Text(
                              'Recuérdame',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {
                          context.goNamed(Routes.recovery);
                        },
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: AppColors.kStrongPink),
                        ),
                      ),
                    ],
                  ),
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
                      _tryLogin();
                    },
                    child: const Text(
                      'Ingresar',
                      style: TextStyle(color: Colors.white),
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
    _passwordController.dispose();
    super.dispose();
  }

  void _tryLogin() {
    if (_loginFormKey.currentState!.validate()) {
      context.goNamed(Routes.activePlayer);
    }
  }
}
