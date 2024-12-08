import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  final String apiKey = '4ce4a0d76065460ca826efb4451aaa18';
  final String baseUrl = 'https://newsapi.org/v2';


  Future<List<Article>> fetchTopHeadlines() async {
    try {
      final response = await http
          .get(
        Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['articles'] != null) {
          return (data['articles'] as List)
              .map((json) => Article.fromJson(json))
              .toList();
        } else {
          print('No articles found in the response.');
          throw Exception('No articles found in the response.');
        }
      } else {
        print('Failed to load articles. Status Code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load articles. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching top headlines: $e');
      rethrow;
    }
  }


  Future<List<Article>> fetchArticles(String category) async {
    try {
      final response = await http
          .get(
        Uri.parse('$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey'),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['articles'] != null) {
          return (data['articles'] as List)
              .map((json) => Article.fromJson(json))
              .toList();
        } else {
          print('No articles found for category: $category');
          throw Exception('No articles found for category: $category');
        }
      } else {
        print('Failed to load category news. Status Code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load category news. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching category news for $category: $e');
      rethrow;
    }
  }


  Future<List<Article>> searchArticles(String query) async {
    try {
      final response = await http
          .get(
        Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey'),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['articles'] != null) {
          return (data['articles'] as List)
              .map((json) => Article.fromJson(json))
              .toList();
        } else {
          print('No articles found for query: $query');
          throw Exception('No articles found for query: $query');
        }
      } else {
        print('Failed to load search results. Status Code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load search results. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while searching articles for query: $query: $e');
      rethrow;
    }
  }
}
