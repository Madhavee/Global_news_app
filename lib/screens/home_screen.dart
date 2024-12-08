import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../services/news_service.dart';
import '../services/favorites_service.dart';
import 'article_detail_screen.dart';
import 'category_screen.dart';
import 'search_screen.dart';
import 'notifications_screen.dart';
import 'Favourite_Article_Screen.dart';
import '../services/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Article>> _latestArticles;
  late FavoritesService _favoritesService;

  @override
  void initState() {
    super.initState();
    _favoritesService = Provider.of<FavoritesService>(context, listen: false);
    _fetchArticles();
  }

  void _fetchArticles() {
    _latestArticles = NewsService().fetchArticles('general');
  }

  Future<void> _refreshArticles() async {
    setState(() {
      _latestArticles = NewsService().fetchArticles('general');
    });
    await _latestArticles;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
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
            'Breaking News',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(),
                  ),
                );
              },
              tooltip: 'View Notifications',
            ),
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.black),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black, Colors.grey.shade900]
                : [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshArticles,
          child: FutureBuilder<List<Article>>(
            future: _latestArticles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                List<Article> articles = snapshot.data!;
                if (articles.isEmpty) {
                  return Center(child: Text('No articles available.'));
                }

                Article topArticle = articles.first;
                List<Article> recentArticles = articles.sublist(1);

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailScreen(article: topArticle),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildImage(topArticle.urlToImage, height: 200, width: double.infinity),
                                Container(
                                  color: isDarkMode ? Colors.grey[850] : Colors.white,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        topArticle.title,
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        topArticle.publishedAt != null
                                            ? _formatDate(topArticle.publishedAt!)
                                            : 'Unknown Date',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: isDarkMode ? Colors.grey[400] : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Recent News Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: Column(
                          children: recentArticles.map((article) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArticleDetailScreen(article: article),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.deepOrange.shade800,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _buildImage(article.urlToImage, height: 80, width: 80),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isDarkMode ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            article.publishedAt != null
                                                ? _formatDate(article.publishedAt!)
                                                : 'Unknown Date',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              _favoritesService.isFavorite(article)
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: _favoritesService.isFavorite(article)
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (_favoritesService.isFavorite(article)) {
                                                  _favoritesService.removeFavorite(article);
                                                } else {
                                                  _favoritesService.addFavorite(article);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: Text('Unexpected error occurred.'));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryScreen(),
            ),
          );
        },
        child: Icon(Icons.grid_view),
        backgroundColor: Colors.orange,
        tooltip: 'Filter by Category',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 10,
      ),
    );
  }

  Widget _buildImage(String url, {double height = 200, double width = double.infinity}) {
    if (url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true) {
      return Image.network(
        url,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage(height, width);
        },
      );
    } else {
      return _buildPlaceholderImage(height, width);
    }
  }

  Widget _buildPlaceholderImage(double height, double width) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[300],
      child: Icon(
        Icons.image,
        size: 100,
        color: Colors.grey[500],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)}, ${date.year}';
  }

  String _getMonthName(int month) {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[month - 1];
  }
}
