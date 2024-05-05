import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/functions/get_formatted_time_function.dart';
import 'package:playmax_app_1/presentation/widgets/text_input_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewPlayerModal extends ConsumerStatefulWidget {
  const NewPlayerModal({super.key});

  @override
  ConsumerState<NewPlayerModal> createState() => _NewPlayerModalState();
}

class _NewPlayerModalState extends ConsumerState<NewPlayerModal> {
  final supabase = Supabase.instance.client;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _nameController.clear();
    _startController.clear();
    _endController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
        //width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInputWidget(
              controlador: _nameController,
              label: 'Nombre',
              hintText: 'Nombre del jugador',
            ),
            const Gap(30),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 10,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('Hora de inicio:'),
                  ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: () async {
                        TimeOfDay ahora = TimeOfDay.now();
                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay(hour: ahora.hour, minute: ahora.minute),
                        );

                        if (newTime != null) {
                          _startTime = newTime;
                          String formattedTime =
                              FormattedTime.getFormattedTime(newTime);
                          _startController.text = formattedTime;
                        }
                      },
                      label: const Text('Seleccionar hora')),
                ],
              ),
            ),
            const Gap(10),
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined),
                const Gap(10),
                Expanded(
                  child: TextFormField(
                    controller: _startController,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La hora es obligatoria!!';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const Gap(30),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 10,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('Hora de fin:'),
                  ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: () async {
                        TimeOfDay ahora = TimeOfDay.now();
                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay(hour: ahora.hour, minute: ahora.minute),
                        );

                        if (newTime != null) {
                          _endTime = newTime;
                          String formattedTime =
                              FormattedTime.getFormattedTime(newTime);
                          _endController.text = formattedTime;
                        }
                      },
                      label: const Text('Seleccionar hora')),
                ],
              ),
            ),
            const Gap(10),
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined),
                const Gap(10),
                Expanded(
                  child: TextFormField(
                    controller: _endController,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La hora es obligatoria!!';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const Gap(5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (FormattedTime.checkSelectedTimeOfDay(
                          _startTime!, _endTime!)) {
                        final player = PlayerModel(
                          name: _nameController.text,
                          start: _startTime!,
                          end: _endTime!,
                          isActive: true,
                        );
                        //*Try to insert in table
                        await _tryToInsertPlayer(player);
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'La hora de fin debe ser mayor a la de inicio',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ));
                      }
                    }
                  },
                  child: const Text(
                    'Agregar jugador',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _tryToInsertPlayer(PlayerModel player) async {
    Map playerMap = player.toJson();
    try {
      await supabase.from('active_players').insert(playerMap);
      if (!mounted) return;
      context.pop();
    } on PostgrestException catch (e) {
      if (!mounted) return;
      context.pop();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Ocurrió un error al intentar agregar al jugador -> ${e.message}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }
}
