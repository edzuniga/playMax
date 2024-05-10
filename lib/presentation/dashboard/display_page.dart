import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:playmax_app_1/config/colors.dart';
import 'package:playmax_app_1/data/player_model.dart';
import 'package:playmax_app_1/presentation/functions/get_formatted_time_function.dart';
import 'package:playmax_app_1/presentation/providers/supabase_instance.dart';

class DisplayPage extends ConsumerStatefulWidget {
  const DisplayPage({super.key});

  @override
  ConsumerState<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends ConsumerState<DisplayPage> {
  late SupabaseClient _supabase;
  late List<PlayerModel> _jugadoresInactivos;
  late SupabaseStreamBuilder _stream;
  //Crear controlador para el youtube player
  late YoutubePlayerController _youtubeController;
  List<String> youtubePlaylist = [
    'gyvJL8-9Sxc',
    'Ac4XmNtXD3k',
    'rkoUUdIBL-w',
  ];

  @override
  void initState() {
    super.initState();
    _supabase = ref.read(supabaseManagementProvider);
    _stream = _supabase
        .from('active_players')
        .stream(primaryKey: ['id_active_users'])
        .gte(
          'created_at',
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
        )
        .order('fin');
    _jugadoresInactivos = [];
    //Initialize the youtube controller
    _youtubeController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        loop: true,
        showFullscreenButton: true,
        mute: true,
        showVideoAnnotations: false,
        enableCaption: false,
      ),
    );

    _youtubeController.loadPlaylist(
      list: youtubePlaylist,
      listType: ListType.playlist,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Gap(10),
                  SizedBox(
                    width: 200,
                    child: Image.asset('assets/img/logo_playmax.png'),
                  ),
                  const Gap(20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    width: screenSize.width * 0.4,
                    height: 400,
                    child: YoutubePlayer(
                      controller: _youtubeController,
                      aspectRatio: 16 / 9,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: StreamBuilder(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            'Ocurrió un error al querer cargar los jugadores!!'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                            'Aún no hay jugadores que deban salir el día de hoy!!'),
                      );
                    } else {
                      List<Map<String, dynamic>> jugadoresMap = snapshot.data!;
                      //Borrar el listado para iniciar en blanco
                      _jugadoresInactivos.clear();
                      //Poblar el listado
                      for (var jugador in jugadoresMap) {
                        if (jugador['is_active'] == false) {
                          _jugadoresInactivos
                              .add(PlayerModel.fromJson(jugador));
                        }
                      }

                      return ListView.builder(
                        itemCount: _jugadoresInactivos.length,
                        itemBuilder: (context, index) {
                          PlayerModel jugadorInactivo =
                              _jugadoresInactivos[index];

                          String formattedEndTime =
                              TimeFunctions.getFormattedTime(
                                  jugadorInactivo.end);
                          return Container(
                            height: 120,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.grey.shade200),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          jugadorInactivo.name.toUpperCase(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.roboto(
                                            fontSize: 35,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            height: 0.9,
                                          ),
                                        ),
                                        Text(
                                          'Pulsera: ${jugadorInactivo.colorPulsera}'
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.kPurple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 250,
                                  height: double.infinity,
                                  color: Colors.red,
                                  child: Text(
                                    formattedEndTime.toUpperCase(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    //_youtubeController.close();
    super.dispose();
  }
}
