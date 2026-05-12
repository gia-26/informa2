import 'package:flutter/material.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/app/components/categoryTab_card.dart';
import 'package:informa2/modules/news/components/news_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Para manejar el estado de la pestaña seleccionada
  String selectedCategory = 'Todo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: primaryColor,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=10'),
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
                          'Giovanni',
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
                  categoryTab('Todo', selectedCategory, (value) => setState(() => selectedCategory = value)),
                  categoryTab('Noticias', selectedCategory, (value) => setState(() => selectedCategory = value)),
                  categoryTab('Radio', selectedCategory, (value) => setState(() => selectedCategory = value)),
                ],
              ),
            ),

            //CONTENIDO
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: Center(
                  child: Column(
                    children: [
                      if (selectedCategory == 'Todo' || selectedCategory == 'Noticias')
                        _buildSectionTitle('Descubre nuevas', 'noticias'),
                      if (selectedCategory == 'Todo' || selectedCategory == 'Noticias')
                        const NewsCarousel(),
                      if (selectedCategory == 'Todo' || selectedCategory == 'Radio')
                        _buildSectionTitle('Escucha nuestra', 'radio'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
        onPressed: () {},
      ),
    );
  }

  Widget _buildSectionTitle(
    String normalText,
    String purpleText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
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
          TextButton(
            onPressed: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              );*/
            },
            child: Text(
              'Ver Todos',
              style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}