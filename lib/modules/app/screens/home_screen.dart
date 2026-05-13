import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/app/components/categoryTab_card.dart';
import 'package:informa2/modules/app/provider/auth_provider.dart';
import 'package:informa2/modules/app/screens/favorites_screen.dart';
import 'package:informa2/modules/news/components/news_carousel.dart';
import 'package:informa2/modules/news/screens/news_screen.dart';
import 'package:informa2/modules/radio/components/mini_player.dart';
import 'package:informa2/modules/radio/components/program_card.dart';
import 'package:informa2/modules/radio/components/radio_card.dart';
import 'package:informa2/modules/radio/models/program_model.dart';
import 'package:informa2/modules/radio/models/radio_model.dart';
import 'package:informa2/modules/radio/provider/program_provider.dart';
import 'package:informa2/modules/radio/provider/radio_provider.dart';
import 'package:informa2/modules/radio/service/audio_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // Para manejar el estado de la pestaña seleccionada
  String selectedCategory = 'Todo';
  final radioProvider = RadioProvider();
  final programProvider = ProgramProvider();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      MyAudioService().pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioService = context.watch<MyAudioService>();
    final authProvider = context.watch<AuthProviderApp>();
    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: primaryColor,
                          backgroundImage: const NetworkImage(
                            'https://i.pravatar.cc/150?img=10',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¡Buen día!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                authProvider.usuarioActual?.name ?? 'Usuario',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _headerIcon(Icons.favorite_border_rounded),
                        const SizedBox(width: 10),
                        _headerIcon(Icons.settings_outlined),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  //SECCIÓN DE TABS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Row(
                      children: [
                        categoryTab(
                          'Todo',
                          selectedCategory,
                          (value) => setState(() => selectedCategory = value),
                        ),
                        categoryTab(
                          'Noticias',
                          selectedCategory,
                          (value) => setState(() => selectedCategory = value),
                        ),
                        categoryTab(
                          'Radio',
                          selectedCategory,
                          (value) => setState(() => selectedCategory = value),
                        ),
                      ],
                    ),
                  ),

                  //CONTENIDO
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: backgroundColor),
                    child: Center(
                      child: Column(
                        children: [
                          if (selectedCategory == 'Todo') ...[
                            _buildSectionTitle('Descubre nuevas', 'noticias'),
                            const NewsCarousel(),
                          ],
                          if (selectedCategory == 'Todo' ||
                              selectedCategory == 'Radio') ...[
                            _buildSectionTitle(
                              'Explora nuestras',
                              'estaciones',
                            ),
                            const SizedBox(height: 10),
                            _radioSection(audioService),
                            const SizedBox(height: 10),
                            _buildSectionTitle(
                              'Visita nuestros',
                              'programas',
                            ),
                            const SizedBox(height: 10),
                            _programSection(),
                          ],

                          if (selectedCategory == 'Noticias') ...[
                            const SizedBox(height: 15),
                            const NewsScreen(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(
            child: Material(
              type: MaterialType.transparency,
              child: audioService.currentRadio != null
                  ? _miniPlayer(audioService.currentRadio!)
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniPlayer(RadioModel radio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [MiniPlayer(initialRadio: radio)],
    );
  }

  Widget _radioSection(MyAudioService? audioService) {
    return FutureBuilder<List<RadioModel>>(
      future: radioProvider.getRadios(),
      builder: (context, radioSnapshot) {
        if (radioSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final radioStations = radioSnapshot.data ?? [];

        if (radioStations.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron estaciones de radio.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        return SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            itemCount: radioStations.length,
            itemBuilder: (context, index) {
              return RadioCard(
                radio: radioStations[index],
                onTap: () {
                  audioService?.setCurrentRadio(radioStations[index]);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _programSection() {
    return FutureBuilder<List<ProgramModel>>(
      future: programProvider.getPrograms(),
      builder: (context, programSnapshot) {
        if (programSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final programs = programSnapshot.data ?? [];

        if (programs.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron programas.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            itemCount: programs.length,
            itemBuilder: (context, index) {
              return ProgramCard(
                program: programs[index],
              );
            },
          ),
        );
      },
    );
  }

  Widget _headerIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: () {
          if (icon == Icons.favorite_border_rounded) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            );
          } else if (icon == Icons.settings_outlined) {

          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String normalText, String purpleText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(text: normalText),
                  WidgetSpan(child: SizedBox(width: 9)),
                  TextSpan(
                    text: purpleText,
                    style: const TextStyle(color: secundaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
