import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ErasePlayerModal extends StatefulWidget {
  const ErasePlayerModal({required this.playerUid, super.key});
  final String playerUid;

  @override
  State<ErasePlayerModal> createState() => _ErasePlayerModalState();
}

class _ErasePlayerModalState extends State<ErasePlayerModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 20,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '¿Estás seguro que deseas borrar este jugador?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Cancelar'),
              ),
              const Gap(10),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Borrar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
