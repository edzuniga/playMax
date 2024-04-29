import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInputWidget extends StatefulWidget {
  const TextInputWidget({
    super.key,
    required this.controlador,
    this.valorInicial,
    this.label,
    this.hintText,
    this.isPassword = false,
    this.isEmail = false,
  });

  final TextEditingController controlador;
  final String? valorInicial;
  final String? label;
  final String? hintText;
  final bool isPassword;
  final bool isEmail;

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  bool _isObscured = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controlador,
      initialValue: widget.valorInicial,
      style: GoogleFonts.roboto(),
      decoration: InputDecoration(
        label: widget.label != null ? Text(widget.label!) : null,
        hintText: widget.hintText,
        hintStyle: GoogleFonts.roboto(fontStyle: FontStyle.italic),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        hoverColor: Colors.red,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
      ),
      obscureText: widget.isPassword ? _isObscured : false,
      validator: (value) {
        //General condition for required inputs
        if (value == null || value.isEmpty) {
          return 'Campo obligatorio';
        }
        //Special condition justo for password input
        if (widget.isPassword && value.length < 6) {
          return 'Debe tener al menos 6 caracteres';
        }

        if (!widget.isEmail) {
          return null;
        }

        //Special condition just for email inputs
        if (!EmailValidator.validate(value)) {
          return 'Debe ser un correo válido';
        }

        return null;
      },
    );
  }
}
