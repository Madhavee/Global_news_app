import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/article.dart';

class FavoritesService extends ChangeNotifier {
  List<Article> _favorites = [];

  // Get the list of favorites
  List<Article> get favorites => _favorites;

  // Load the favorites from SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      List<dynamic> jsonList = json.decode(favoritesJson);
      _favorites = jsonList.map((json) => Article.fromJson(json)).toList();
    }
    notifyListeners();
  }

  // Add an article to favorites
  Future<void> addFavorite(Article article) async {
    _favorites.add(article);
    await _saveFavorites();
    notifyListeners();
  }

  // Remove an article from favorites
  Future<void> removeFavorite(Article article) async {
    _favorites.removeWhere((fav) => fav.title == article.title);
    await _saveFavorites();
    notifyListeners();
  }

  // Check if an article is in favorites
  bool isFavorite(Article article) {
    return _favorites.any((fav) => fav.title == article.title);
  }

  // Modify the read status of an article (mark as read or unread)
  Future<void> updateReadStatus(Article article, bool isRead) async {
    int index = _favorites.indexWhere((fav) => fav.title == article.title);
    if (index != -1) {
      _favorites[index].isRead = isRead;
      await _saveFavorites();
      notifyListeners();
    }
  }

  // Add a tag to an article
  Future<void> addTag(Article article, String tag) async {
    int index = _favorites.indexWhere((fav) => fav.title == article.title);
    if (index != -1) {
      if (!_favorites[index].tags.contains(tag)) {
        _favorites[index].tags.add(tag);
        await _saveFavorites();
        notifyListeners();
      }
    }
  }

  // Remove a tag from an article
  Future<void> removeTag(Article article, String tag) async {
    int index = _favorites.indexWhere((fav) => fav.title == article.title);
    if (index != -1) {
      _favorites[index].tags.remove(tag);
      await _saveFavorites();
      notifyListeners();
    }
  }

  // Save the favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoritesJson = _favorites.map((article) => json.encode(article.toJson())).toList();
    prefs.setString('favorites', json.encode(favoritesJson));
  }
}
