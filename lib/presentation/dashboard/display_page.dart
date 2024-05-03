import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  //Crear controlador para el youtube player
  late YoutubePlayerController _youtubeController;
  String youtubeVideoId = 'gyvJL8-9Sxc';

  @override
  void initState() {
    super.initState();
    //Initialize the youtube controller
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: youtubeVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        mute: true,
      ),
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
                  const Gap(20),
                  SizedBox(
                    width: 200,
                    child: Image.asset('assets/img/logo_playmax.png'),
                  ),
                  const Gap(80),
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
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                ),
              ),
              height: double.infinity,
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) => Container(
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(), color: Colors.grey.shade200),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          width: 200,
                          child: Text(
                            'Julio Melendez Castro Abimelec'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 250,
                        height: double.infinity,
                        color: Colors.red,
                        child: Text('4:00pm'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ),
            )),
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
