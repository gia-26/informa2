import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/app/provider/auth_provider.dart';
import 'package:informa2/modules/radio/models/radio_model.dart';
import 'package:informa2/modules/radio/provider/radio_provider.dart';
import 'package:informa2/modules/radio/service/audio_service.dart';
import 'package:provider/provider.dart';

class RadioCard extends StatefulWidget {
  final RadioModel radio;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const RadioCard({Key? key, required this.radio, required this.onTap, this.onRemove})
    : super(key: key);

  @override
  State<RadioCard> createState() => _RadioCardState();
}

class _RadioCardState extends State<RadioCard> {
  late bool isFavorite = false;
  late Future<List<RadioModel>> _radioFavorites;

  @override
  void initState() {
    super.initState();
    final radioProvider = Provider.of<RadioProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProviderApp>(context, listen: false);
    _radioFavorites = radioProvider.getFavoriteRadios(authProvider.usuarioActual?.uid ?? '');
    // Verificar si la radio actual está en favoritos
    _radioFavorites.then((favRadios) {
      setState(() {
        isFavorite = favRadios.any((r) => r.id == widget.radio.id);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final audioService = context.watch<MyAudioService>();
    final bool isThisRadioSelected = audioService.currentRadio?.id == widget.radio.id;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              // IMAGEN DE FONDO
              Image.network(
                widget.radio.imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // GRADIENTE OSCURO
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      backgroundColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),

              // BOTÓN DE PLAY FLOTANTE
              Positioned(
                top: 20,
                right: 20,
                child: StreamBuilder(
                  stream: audioService.playerStateStream,
                  builder: (context, playerSnapshot) {
                    final playerState = playerSnapshot.data;
                    final isPlaying = playerState?.playing ?? false;
                    final bool isActuallyPlayingThis =
                        isPlaying && isThisRadioSelected;
                    return GestureDetector(
                      onTap: () {
                        if (isThisRadioSelected) {
                          if (isPlaying) {
                            audioService.pause();
                          } else {
                            audioService.play();
                          }
                        } else {
                          audioService.playStream(widget.radio);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: secundaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: secundaryColor.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          isActuallyPlayingThis
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
              ),

              //INFORMACIÓN INFERIOR
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: secundaryColor.withOpacity(0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.radio.category.toUpperCase(),
                            style: TextStyle(
                              color: backgroundColor.withOpacity(0.9),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "La ${widget.radio.acronimo}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.radio.frequency,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 195,
                left: 195,

                child: _buildCircularButton(
                  icon: isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite? Colors.redAccent : Colors.white,
                  onTap: () {
                    final authProvider = Provider.of<AuthProviderApp>(context, listen: false);
                    final radioProvider = Provider.of<RadioProvider>(context, listen: false);
                    final uid = authProvider.usuarioActual?.uid;
                    if (uid == null) return;

                    if (isFavorite) {
                      radioProvider.removeRadioFromFavorites(uid, widget.radio);
                      if (widget.onRemove != null) widget.onRemove!(); 
                      setState(() {
                        isFavorite = false;
                      });
                    } else {
                      radioProvider.addRadioToFavorites(uid, widget.radio);
                      setState(() {
                        isFavorite = true;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
