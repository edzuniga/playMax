import 'package:flutter/material.dart';

class TituloColumnaTabla extends StatelessWidget {
  const TituloColumnaTabla({
    super.key,
    required this.titulo,
    required this.ancho,
  });
  final String titulo;
  final double ancho;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho,
      child: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
