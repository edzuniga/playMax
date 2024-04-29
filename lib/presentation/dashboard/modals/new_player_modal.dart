import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:playmax_app_1/presentation/widgets/text_input_widget.dart';

class NewPlayerModal extends StatefulWidget {
  const NewPlayerModal({super.key});

  @override
  State<NewPlayerModal> createState() => _NewPlayerModalState();
}

class _NewPlayerModalState extends State<NewPlayerModal> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: SizedBox(
        width: screenSize.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInputWidget(
              controlador: _nameController,
              label: 'Nombre',
              hintText: 'Nombre del jugador',
            ),
            const Gap(15),
            const Text('Hora de inicio:'),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: _startController,
              decoration: InputDecoration(
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                icon: const Icon(
                  Icons.timer,
                ),
                hintText: 'Seleccione la hora... ',
              ),
              onTap: () async {
                TimeOfDay ahora = TimeOfDay.now();
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay(hour: ahora.hour, minute: ahora.minute),
                );

                if (newTime != null) {
                  _startController.text = "${newTime.hour}";
                }
              },
              validator: (val) {
                if (val == null || val == "") {
                  return 'Debe Seleccionar una Hora!';
                }
                return null;
              },
            ),
            const Gap(15),
            const Text('Hora de fin:'),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: _endController,
              decoration: InputDecoration(
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                icon: const Icon(
                  Icons.timer,
                ),
                hintText: 'Seleccione la hora... ',
              ),
              onTap: () async {
                TimeOfDay ahora = TimeOfDay.now();
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay(hour: ahora.hour, minute: ahora.minute),
                );

                if (newTime != null) {}
              },
              validator: (val) {
                if (val == null || val == "") {
                  return 'Debe Seleccionar una Hora!';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
