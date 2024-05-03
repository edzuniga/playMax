import 'package:animate_do/animate_do.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/config/colors.dart';
import 'package:playmax_app_1/config/routes.dart';
import 'package:playmax_app_1/presentation/providers/auth_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  //Instancia de supabase
  final supabase = Supabase.instance.client;
  //Controlador para el switch
  bool _isSwitchEnabled = false;
  bool _isTryingLogin = false;
  bool _isCheckingAuthStatus = true;
  bool _isObscuredPassword = true;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _isAuthenticated();
    super.initState();
  }

  //Method to check authentication status
  Future<void> _isAuthenticated() async {
    //!NECESSARY to wait for widget to be in the widget tree
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }
    //Call provider to chech auth status
    int isAuth = await ref.read(authStateProvider.notifier).chechAuthStatus();
    if (isAuth == 1) {
      if (!mounted) return;
      setState(() => _isCheckingAuthStatus = false);
      context.goNamed(Routes.activePlayer); //redirect to dashboard home
    } else {
      setState(() => _isCheckingAuthStatus = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: _isCheckingAuthStatus
          ? const CircularProgressIndicator()
          : Container(
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
                            borderSide:
                                BorderSide(color: AppColors.kStrongPink),
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
                        obscureText: _isObscuredPassword ? true : false,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          label: const Text('Contraseña'),
                          hintText: '**************',
                          hintStyle: const TextStyle(color: Colors.black26),
                          labelStyle: const TextStyle(color: AppColors.kGrey),
                          focusColor: AppColors.kPurple,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.kStrongPink),
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
                                      value: _isSwitchEnabled,
                                      activeColor: AppColors.kStrongPink,
                                      onChanged: (bool? value) {
                                        // This is called when the user toggles the switch.
                                        setState(() {
                                          _isSwitchEnabled = value ?? false;
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
                            (_isTryingLogin)
                                ? null
                                : _tryLogin(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                          },
                          child: (!_isTryingLogin)
                              ? const Text(
                                  'Ingresar',
                                  style: TextStyle(color: Colors.white),
                                )
                              : SpinPerfect(
                                  infinite: true,
                                  child: const Icon(
                                    Icons.refresh_outlined,
                                    color: Colors.white,
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
    _passwordController.dispose();
    super.dispose();
  }

  void _tryLogin({required String email, required String password}) async {
    if (_loginFormKey.currentState!.validate()) {
      //Poner la app en estado de espera
      setState(() {
        _isTryingLogin = true;
      });
      //Probar el login desde el manejador de estado
      String tryLoginReply = await ref
          .read(authStateProvider.notifier)
          .tryLogin(email: email, password: password);

      //Implementación dependiendo la respuesta obtenida
      if (tryLoginReply == 'loggedIn') {
        setState(() {
          _isTryingLogin = false;
        });
        if (!mounted) return;
        context.goNamed(Routes.activePlayer);
      } else {
        //Respuesta de NO LoggedIn
        setState(() {
          _isTryingLogin = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        String errorMessage = tryLoginReply;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              (errorMessage != 'Invalid login credentials')
                  ? errorMessage
                  : 'Revise su correo y contraseña!!',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }
  }
}
