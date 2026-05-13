import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/radio/service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:informa2/modules/radio/models/radio_model.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatefulWidget {
  final RadioModel? initialRadio;
  const PlayerScreen({Key? key, this.initialRadio}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioService = context.watch<MyAudioService>();

    return StreamBuilder<RadioModel?>(
      stream: audioService.currentRadioStream,
      initialData: widget.initialRadio ?? audioService.currentRadio,
      builder: (context, radioSnapshot) {
        final radio = radioSnapshot.data ?? widget.initialRadio;
        if (radio == null) {
          return const Scaffold(
            body: Center(child: Text("Estación no encontrada")),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(radio.imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      secundaryColor,
                      BlendMode.softLight,
                    ),
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(color: Colors.black.withOpacity(0.4)),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: secundaryColor,
                              size: 45,
                              fontWeight: FontWeight.bold,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    StreamBuilder(
                      stream: MyAudioService().playerStateStream,
                      builder: (context, playerSnapshot) {
                        if (playerSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: secundaryColor,
                          );
                        }

                        if (playerSnapshot.data?.playing == true) {
                          _rotationController.repeat();
                        } else {
                          _rotationController.stop();
                        }
                        return RotationTransition(
                          turns: _rotationController,
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: secundaryColor.withOpacity(0.6),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(radio.imageUrl),
                            ),
                          ),
                        );
                      },
                    ),

                    const Spacer(),

                    StreamBuilder(
                      stream: MyAudioService().playerStateStream,
                      builder: (context, playerSnapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: playerSnapshot.data?.playing == true
                                      ? Colors.redAccent
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                playerSnapshot.data?.playing == true
                                    ? "EN VIVO"
                                    : "OFFLINE",
                                style: TextStyle(
                                  color: playerSnapshot.data?.playing == true
                                      ? Colors.redAccent
                                      : Colors.white70,
                                  fontSize: 14,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    StreamBuilder<IcyMetadata?>(
                      stream: MyAudioService().metadataStream,
                      builder: (context, snapshot) {
                        final metadata = snapshot.data;
                        String title =
                            metadata?.info?.title ?? "Cargando estación...";
                        return SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  radio.name,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Ciudad de México",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.skip_previous,
                            color: secundaryColor,
                            size: 40,
                          ),
                          onPressed: () => MyAudioService().previous(),
                        ),

                        StreamBuilder<PlayerState>(
                          stream: MyAudioService().playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final processingState =
                                playerState?.processingState;
                            final playing = playerState?.playing;

                            // Si está cargando el buffer
                            if (processingState == ProcessingState.loading ||
                                processingState == ProcessingState.buffering) {
                              return SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: secundaryColor,
                                ),
                              );
                            }

                            // Si está sonando
                            if (playing == true) {
                              return CircleAvatar(
                                backgroundColor: secundaryColor.withOpacity(
                                  0.3,
                                ),
                                radius: 40,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.pause,
                                    color: textColor,
                                    size: 40,
                                  ),
                                  onPressed: () => audioService.pause(),
                                ),
                              );
                            }

                            // Botón de play
                            return CircleAvatar(
                              backgroundColor: secundaryColor.withOpacity(0.3),
                              radius: 40,
                              child: IconButton(
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: textColor,
                                  size: 40,
                                ),
                                onPressed: () => audioService.play(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.skip_next,
                            color: secundaryColor,
                            size: 40,
                          ),
                          onPressed: () => audioService.next(),
                        ),
                      ],
                    ),

                    const Spacer(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
