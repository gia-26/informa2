import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/app/components/categoryTab_card.dart';
import 'package:informa2/modules/app/provider/auth_provider.dart';
import 'package:informa2/modules/news/components/newsGrid_card.dart';
import 'package:informa2/modules/news/models/news_model.dart';
import 'package:informa2/modules/news/provider/news_provider.dart';
import 'package:informa2/modules/news/screens/news_details_screen.dart';
import 'package:informa2/modules/radio/components/program_card.dart';
import 'package:informa2/modules/radio/components/radio_card.dart';
import 'package:informa2/modules/radio/models/program_model.dart';
import 'package:informa2/modules/radio/models/radio_model.dart';
import 'package:informa2/modules/radio/provider/program_provider.dart';
import 'package:informa2/modules/radio/provider/radio_provider.dart';
import 'package:informa2/modules/radio/service/audio_service.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedCategory = 'Noticias';
  late Future<List<NewsModel>> _newsFuture;
  late Future<List<RadioModel>> _radioFuture;
  late Future<List<ProgramModel>> _programFuture;

  @override
  void initState() {
    super.initState();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    final radioProvider = Provider.of<RadioProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProviderApp>(context, listen: false);
    final programProvider = Provider.of<ProgramProvider>(
      context,
      listen: false,
    );
    _newsFuture = newsProvider.getFavoriteNews(
      authProvider.usuarioActual?.uid ?? '',
    );
    _radioFuture = radioProvider.getFavoriteRadios(
      authProvider.usuarioActual?.uid ?? '',
    );
    _programFuture = programProvider.getFavoritePrograms(
      authProvider.usuarioActual?.uid ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioService = context.watch<MyAudioService>();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Favoritos', style: TextStyle(color: Colors.white)),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20, bottom: 20, top: 15),
              child: Row(
                children: [
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

            if (selectedCategory == 'Radio') ...[
              _buildSectionTitle('Tus estaciones', 'favoritas'),
              const SizedBox(height: 20),
              FutureBuilder(
                future: _radioFuture,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final radioStations = asyncSnapshot.data ?? [];

                  if (radioStations.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay estaciones de radio favoritas disponibles',
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
                            audioService.setCurrentRadio(radioStations[index]);
                          },
                          onRemove: () {
                            final authProvider = Provider.of<AuthProviderApp>(
                              context,
                              listen: false,
                            );
                            final radioProvider = Provider.of<RadioProvider>(
                              context,
                              listen: false,
                            );

                            setState(() {
                              _radioFuture = radioProvider.getFavoriteRadios(
                                authProvider.usuarioActual?.uid ?? '',
                              );
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Tus programas', 'favoritos'),
              const SizedBox(height: 20),
              FutureBuilder(
                future: _programFuture,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final programs = asyncSnapshot.data ?? [];

                  if (programs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay programas favoritos disponibles',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 20),
                      itemCount: programs.length,
                      itemBuilder: (context, index) {
                        return ProgramCard(
                          program: programs[index],
                          onRemove: () {
                            final authProvider = Provider.of<AuthProviderApp>(
                              context,
                              listen: false,
                            );
                            final programProvider = Provider.of<ProgramProvider>(
                              context,
                              listen: false,
                            );

                            setState(() {
                              _programFuture = programProvider.getFavoritePrograms(
                                authProvider.usuarioActual?.uid ?? '',
                              );
                            });
                          }
                        );
                      },
                    ),
                  );
                },
              ),
            ],

            if (selectedCategory == 'Noticias') ...[
              _buildSectionTitle('Mira tus noticias', 'favoritas'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder<List<NewsModel>>(
                  future: _newsFuture,
                  builder: (context, newsSnapshot) {
                    if (newsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final newsList = newsSnapshot.data ?? [];

                    if (newsList.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay noticias favoritas disponibles',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: newsList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) {
                        return NewsGridCard(
                          news: newsList[index],
                          onTap: () async {
                            await Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) =>
                                    NewsDetailsScreen(news: newsList[index]),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                              ),
                            );

                            final authProvider = Provider.of<AuthProviderApp>(
                              context,
                              listen: false,
                            );
                            final newsProvider = Provider.of<NewsProvider>(
                              context,
                              listen: false,
                            );

                            setState(() {
                              _newsFuture = newsProvider.getFavoriteNews(
                                authProvider.usuarioActual?.uid ?? '',
                              );
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
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
