import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/config/colors.dart';
import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/dashboard/export_dashboard_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErasePlayerModal extends StatefulWidget {
  const ErasePlayerModal({required this.playerInfo, super.key});
  final PlayerModel playerInfo;

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
          Text(
            '¿Estás seguro que deseas borrar este jugador?\n-> ${widget.playerInfo.name}',
            style: const TextStyle(
              fontSize: 16,
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
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: AppColors.kPurple,
                  ),
                ),
              ),
              const Gap(10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kStrongPink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () async {
                  await _tryDeletePlayer();
                },
                child: const Text(
                  'Borrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _tryDeletePlayer() async {
    try {
      await supabase
          .from('active_players')
          .delete()
          .eq('id_active_users', widget.playerInfo.idActiveUsers!);
      if (!mounted) return;
      context.pop();
    } on PostgrestException catch (e) {
      if (!mounted) return;
      context.pop();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Ocurrió un error al intentar borrar el jugador -> ${e.message}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
