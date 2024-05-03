import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/providers/active_players_provider.dart';
import 'package:playmax_app_1/presentation/widgets/text_input_widget.dart';

class NewPlayerModal extends ConsumerStatefulWidget {
  const NewPlayerModal({super.key});

  @override
  ConsumerState<NewPlayerModal> createState() => _NewPlayerModalState();
}

class _NewPlayerModalState extends ConsumerState<NewPlayerModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

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
                          String formattedTime = _getFormattedTime(newTime);
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
                          String formattedTime = _getFormattedTime(newTime);
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_checkSelectedTimeOfDay()) {
                        ref.read(activePlayersProvider.notifier).addPlayer(
                            PlayerModel(
                                idActiveUsers: 1,
                                name: _nameController.text,
                                start: _startTime!,
                                end: _endTime!));
                        Navigator.pop(context);
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

                        /*Fluttertoast.showToast(
                              msg: "La hora de fin debe ser mayor a la de inicio",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0); */
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

  String _getFormattedTime(TimeOfDay time) {
    String amOrPm = 'am';
    String formattedHour = '${time.hour}';
    String formattedMinute = '${time.minute}';
    if (time.hour > 12) {
      formattedHour = (time.hour - 12).toString();
      amOrPm = 'pm';
    }
    if (time.minute < 10) {
      formattedMinute = '0${time.minute}';
    }
    return "$formattedHour:$formattedMinute$amOrPm";
  }

  //Métthod to check if the end
  bool _checkSelectedTimeOfDay() {
    int startTimeInMinutes = _startTime!.hour * 60 + _startTime!.minute;
    int endTimeInMinutes = _endTime!.hour * 60 + _endTime!.minute;
    return endTimeInMinutes > startTimeInMinutes;
  }
}
