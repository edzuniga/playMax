import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/functions/get_formatted_time_function.dart';
import 'package:playmax_app_1/presentation/providers/supabase_instance.dart';
import 'package:playmax_app_1/presentation/widgets/text_input_widget.dart';

class UpdatePlayerModal extends ConsumerStatefulWidget {
  const UpdatePlayerModal({required this.jugadorRecibido, super.key});
  final PlayerModel jugadorRecibido;

  @override
  ConsumerState<UpdatePlayerModal> createState() => _UpdatePlayerModalState();
}

class _UpdatePlayerModalState extends ConsumerState<UpdatePlayerModal> {
  bool _isTryingToUpdatePlayer = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  late final TextEditingController _cantidadController;
  late final TextEditingController _colorPulseraController;

  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    String tiempoInicial =
        TimeFunctions.getFormattedTime(widget.jugadorRecibido.start);
    String tiempoFinal =
        TimeFunctions.getFormattedTime(widget.jugadorRecibido.end);
    _nameController = TextEditingController(text: widget.jugadorRecibido.name);
    _startController = TextEditingController(text: tiempoInicial);
    _endController = TextEditingController(text: tiempoFinal);
    _cantidadController =
        TextEditingController(text: widget.jugadorRecibido.cantidad.toString());
    _colorPulseraController =
        TextEditingController(text: widget.jugadorRecibido.colorPulsera);
    _startTime = widget.jugadorRecibido.start;
    _endTime = widget.jugadorRecibido.end;
  }

  @override
  void dispose() {
    _nameController.clear();
    _startController.clear();
    _endController.clear();
    _cantidadController.clear();
    _colorPulseraController.clear();
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
            TextInputWidget(
              controlador: _colorPulseraController,
              label: 'Color de pulsera',
              hintText: 'Verde... Morado...., Rojo..., etc...',
            ),
            const Gap(30),
            TextInputWidget(
              controlador: _cantidadController,
              label: 'Cantidad de personas entrando',
              hintText: '2',
              isJustNumbers: true,
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
                  onPressed: (_isTryingToUpdatePlayer)
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            if (TimeFunctions.checkSelectedTimeOfDay(
                                    _startTime!, _endTime!) &&
                                TimeFunctions.isEndTimeAfterCurrent(
                                    _endTime!)) {
                              final player = PlayerModel(
                                idActiveUsers:
                                    widget.jugadorRecibido.idActiveUsers,
                                createdAt: widget.jugadorRecibido.createdAt,
                                name: _nameController.text,
                                start: _startTime!,
                                end: _endTime!,
                                isActive: true,
                                cantidad: int.parse(_cantidadController.text),
                                colorPulsera:
                                    (_colorPulseraController.text.isNotEmpty)
                                        ? _colorPulseraController.text
                                        : '',
                              );
                              //*Try to update the player
                              await _tryToUpdatePlayer(player);
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
                  child: (_isTryingToUpdatePlayer)
                      ? SpinPerfect(
                          infinite: true,
                          child: const Icon(
                            Icons.refresh_outlined,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Actualizar jugador',
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

  Future<void> _tryToUpdatePlayer(PlayerModel player) async {
    final supabaseClient = ref.read(supabaseManagementProvider.notifier);
    setState(() => _isTryingToUpdatePlayer = true);
    await supabaseClient.wasPlayerUpdated(player).then((message) {
      if (message == 'success') {
        setState(() => _isTryingToUpdatePlayer = true);
        context.pop();
      } else {
        setState(() => _isTryingToUpdatePlayer = false);
        context.pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Ocurrió un error al intentar editar al jugador -> $message',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ));
      }
    });
  }
}
