import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:informa2/helpers/constants/constants.dart';
import 'package:informa2/modules/news/models/news_model.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;
  final VoidCallback onTap;

  const NewsCard({Key? key, required this.news, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              //IMAGEN DE FONDO
              Hero(
                tag: 'news_image_${news.id}',
                child: Image.network(
                  news.imageUrl,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: primaryColor,
                    child: const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              ),

              //GRADIENTE SUPERIOR
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        backgroundColor.withOpacity(
                          0.95,
                        ), // Morado muy oscuro abajo
                        backgroundColor.withOpacity(0.4),
                        Colors.transparent, // Transparente arriba
                      ],
                      stops: const [0.0, 0.5, 0.8],
                    ),
                  ),
                ),
              ),

              //CONTENIDO
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // BADGE DE CATEGORÍA
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: secundaryColor.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        news.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // TÍTULO
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // EXCERPT
                    Html(
                      data: news.excerpt,
                      style: {
                        "body": Style(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: FontSize(13),
                          lineHeight: LineHeight(
                            1.4,
                          ),
                          maxLines: 2,
                          textOverflow:
                              TextOverflow.ellipsis,
                          margin: Margins
                              .zero,
                          padding:
                              HtmlPaddings.zero,
                        ),
                      },
                    ),
                    const SizedBox(height: 12),

                    // FECHA
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: textColor.withOpacity(0.8),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          DateFormat('dd MMM, yyyy').format(news.dateTime),
                          style: TextStyle(
                            color: textColor.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
