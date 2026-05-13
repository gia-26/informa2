import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/app/provider/auth_provider.dart';
import 'package:informa2/modules/radio/provider/program_provider.dart';
import 'package:provider/provider.dart';
import '../models/program_model.dart';

class ProgramCard extends StatefulWidget {
  final ProgramModel program;
  final VoidCallback? onRemove;

  const ProgramCard({Key? key, required this.program, this.onRemove}) : super(key: key);

  @override
  State<ProgramCard> createState() => _ProgramCardState();
}

class _ProgramCardState extends State<ProgramCard> {
  late bool isFavorite = false;
  late Future<List<ProgramModel>> _programFavorites;

  @override
  void initState() {
    super.initState();
    final programProvider = Provider.of<ProgramProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProviderApp>(context, listen: false);
    _programFavorites = programProvider.getFavoritePrograms(authProvider.usuarioActual?.uid ?? '');
    // Verificar si el programa actual está en favoritos
    _programFavorites.then((favPrograms) {
      setState(() {
        isFavorite = favPrograms.any((p) => p.id == widget.program.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            //IMAGEN DE FONDO
            Image.network(
              widget.program.program_icon,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: primaryColor,
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),

            //GRADIENTE PARA PROFUNDIDAD
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      backgroundColor.withOpacity(0.1),
                      backgroundColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),

            // CONTENEDOR DE TEXTO
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      border: Border(
                        top: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.program.program_name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        _buildCircularButton(
                          icon: isFavorite ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite ? Colors.redAccent : Colors.white,
                          onTap: () {
                            final authProvider = Provider.of<AuthProviderApp>(
                              context,
                              listen: false,
                            );
                            final programProvider = Provider.of<ProgramProvider>(
                              context,
                              listen: false,
                            );
                            final uid = authProvider.usuarioActual?.uid;
                            if (uid == null) return;

                            if (isFavorite) {
                              programProvider.removeProgramFromFavorites(
                                uid,
                                widget.program,
                              );
                              if (widget.onRemove != null) widget.onRemove!(); 
                              setState(() {
                                isFavorite = false;
                              });
                            } else {
                              programProvider.addProgramToFavorites(
                                uid,
                                widget.program,
                              );
                              setState(() {
                                isFavorite = true;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
