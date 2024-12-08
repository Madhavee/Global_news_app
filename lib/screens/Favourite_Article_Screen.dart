import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../services/favorites_service.dart';
import 'article_detail_screen.dart';
import '../services/theme_provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the favorites list from the FavoritesService
    final favoritesService = Provider.of<FavoritesService>(context);
    final favorites = favoritesService.favorites;

    // Access the theme to get the AppBar color based on the theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange.shade300,
                  Colors.deepOrange.shade300,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
          title: Text(
            'Favorite Articles',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          actions: [
            // Light/Dark Mode Toggle Button
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.black,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: isDarkMode ? Colors.black : Colors.white,
        child: favorites.isEmpty
            ? const Center(child: Text('No favorite articles'))
            : ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final article = favorites[index];

            return GestureDetector(
              onTap: () {
                // Navigate to article detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(article: article),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  color: isDarkMode
                      ? Colors.grey[850]
                      : (article.isRead ? Colors.grey[300] : Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: Colors.orange.shade800,
                      width: 1,
                    ),
                  ),
                  elevation: 8, // Adding shadow for the card
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    leading: article.urlToImage.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        article.urlToImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Icon(Icons.image, size: 60),
                    title: Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      article.publishedAt != null
                          ? 'Published on ${_formatDate(article.publishedAt!)}'
                          : 'Unknown date',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.black54,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        article.isRead ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: article.isRead ? Colors.green : Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {
                        // Toggle read status
                        favoritesService.updateReadStatus(article, !article.isRead);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(article.isRead
                                ? 'Marked as read'
                                : 'Marked as unread'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Method to format the date
  String _formatDate(DateTime date) {
    final List<String> monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return '${date.day} ${monthNames[date.month - 1]}, ${date.year}';
  }
}
