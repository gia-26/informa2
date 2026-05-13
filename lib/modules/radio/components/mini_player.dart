import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/radio/models/radio_model.dart';
import 'package:informa2/modules/radio/screens/player_screen.dart';
import 'package:informa2/modules/radio/service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  final RadioModel? initialRadio;

  const MiniPlayer({Key? key, this.initialRadio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioService = context.watch<MyAudioService>();

    return StreamBuilder<RadioModel?>(
      stream: audioService.currentRadioStream,
      initialData:  initialRadio ?? audioService.currentRadio,
      builder: (context, radioSnapshot) {
        final radio = radioSnapshot.data ?? initialRadio;

        if (radio == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => PlayerScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
        
                  const begin = Offset(0.0, 1.0); 
                  const end = Offset.zero;
                  const curve = Curves.easeOutQuint;
        
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
        
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 800),
              ),
            );
          },
          child: Center(
            child: Container(
              width: 350,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [secundaryColor, secundaryColor.withOpacity(0.9), backgroundColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                color: secundaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(radio.imageUrl),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Información de la pista
                  Expanded(
                    child: StreamBuilder<IcyMetadata?>(
                      stream: audioService.metadataStream,
                      builder: (context, snapshot) {
                        final metadata = snapshot.data;
                        
                        String title = metadata?.info?.title ?? "Cargando estación...";
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(radio.name, 
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                            Text(
                              title, 
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  StreamBuilder<PlayerState>(
                    stream: audioService.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
        
                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: secundaryColor),
                        );
                      }
        
                      if (playing == true) {
                        return IconButton(
                          icon: Icon(Icons.pause, color: secundaryColor),
                          onPressed: () => audioService.pause(),
                        );
                      }
        
                      return IconButton(
                        icon: Icon(Icons.play_arrow, color: secundaryColor),
                        onPressed: () => {
                          if (audioService.currentRadio != null && audioService.currentRadio?.streamingUrl == radio.streamingUrl) audioService.play()
                          else audioService.playStream(radio)
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}