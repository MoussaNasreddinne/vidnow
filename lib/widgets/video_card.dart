import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/models/video.dart';
import 'package:test1/services/favorite_service.dart';
import 'package:test1/service_locator.dart';

class VideoCard extends StatelessWidget {
  final Video recommendation;
  final VoidCallback onTap;
  final Function(bool isCurrentlyFavorite)? onFavoriteToggle;

  const VideoCard({
    super.key,
    required this.recommendation,
    required this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final FavoriteService favoriteService = locator<FavoriteService>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (_, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color.fromARGB(255, 30, 0, 70)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withAlpha(100)
                    : Colors.grey.withAlpha(150),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'video-thumbnail-${recommendation.id}',
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    recommendation.thumbnailUrl,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: Icon(Icons.broken_image,
                              color: Colors.white54, size: 50),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (recommendation.description.isNotEmpty)
                      Text(
                        recommendation.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontSize: 13),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (recommendation.isPremium)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'PREMIUM',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (!recommendation.isPremium) const Spacer(),
                        Obx(() {
                          final bool isFav =
                              favoriteService.isFavorite(recommendation.id);
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                            child: IconButton(
                              key: ValueKey<bool>(isFav),
                              icon: Icon(
                                isFav
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFav
                                    ? Colors.red
                                    : theme.iconTheme.color?.withOpacity(0.7),
                                size: 24,
                              ),
                              onPressed: () {
                                if (onFavoriteToggle != null) {
                                  onFavoriteToggle!(isFav);
                                } else {
                                  if (isFav) {
                                    favoriteService.removeFavorite(recommendation);
                                  } else {
                                    favoriteService.addFavorite(recommendation);
                                  }
                                }
                              },
                            ),
                          );
                        }),
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
