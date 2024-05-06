import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:playmax_app_1/presentation/utils/supabase_instance.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/functions/get_formatted_time_function.dart';
import 'package:playmax_app_1/presentation/widgets/text_input_widget.dart';

class NewPlayerModal extends ConsumerStatefulWidget {
  const NewPlayerModal({super.key});

  @override
  ConsumerState<NewPlayerModal> createState() => _NewPlayerModalState();
}

class _NewPlayerModalState extends ConsumerState<NewPlayerModal> {
  bool isTryingToAddPlayer = false;
  final _supabase = SupabaseManager().supabaseClient;
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
                              TimeFunctions.getFormattedTime(newTime);
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
                              TimeFunctions.getFormattedTime(newTime);
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
                  onPressed: (isTryingToAddPlayer)
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            if (TimeFunctions.checkSelectedTimeOfDay(
                                    _startTime!, _endTime!) &&
                                TimeFunctions.isEndTimeAfterCurrent(
                                    _endTime!)) {
                              final player = PlayerModel(
                                createdAt: DateTime.now().toString(),
                                name: _nameController.text,
                                start: _startTime!,
                                end: _endTime!,
                                isActive: true,
                              );
                              //*Try to insert in table
                              await _tryToInsertPlayer(player);
                            } else {
                              Fluttertoast.showToast(
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 3,
                                webBgColor: 'red',
                                webPosition: 'center',
                                msg:
                                    'La hora de fin debe ser mayor a la de inicio y a la hora actual!!',
                              );
                            }
                          }
                        },
                  child: (isTryingToAddPlayer)
                      ? SpinPerfect(
                          infinite: true,
                          child: const Icon(
                            Icons.refresh_outlined,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
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
    setState(() => isTryingToAddPlayer = true);
    Map playerMap = player.toJson();
    try {
      await _supabase.from('active_players').insert(playerMap);
      setState(() => isTryingToAddPlayer = false);
      if (!mounted) return;
      context.pop();
    } on PostgrestException catch (e) {
      setState(() => isTryingToAddPlayer = false);
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
