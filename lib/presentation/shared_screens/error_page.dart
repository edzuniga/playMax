import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/config/routes.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () {
            context.goNamed(Routes.login);
          },
          child: const Text('Regresar')),
    );
  }
}
