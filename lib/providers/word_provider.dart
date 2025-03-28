import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';
import '../services/word_service.dart';

class WordProvider with ChangeNotifier {
  final WordService _wordService = WordService();
  List<Word> _words = [];
  List<Word> _favoriteWords = [];
  bool _isLoading = false;
  static const String _favoritesKey = 'favorite_words';

  WordProvider() {
    loadFavorites();
    // 不在构造函数中调用fetchWords，而是在应用启动时或用户手动刷新时调用
  }

  // 刷新单词列表，清空现有列表并获取新的单词
  Future<void> refresh() async {
    _words = [];
    notifyListeners();
    await fetchWords();
  }

  List<Word> get words => _words;
  List<Word> get favoriteWords => _favoriteWords;
  bool get isLoading => _isLoading;

  Future<void> fetchWords() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 每次调用都获取10个新的四六级高频词汇，并完全替换原有列表
      _words = await _wordService.getRandomWords(10);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching words: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
      
      _favoriteWords = favoritesJson
          .map((json) => Word.fromJson(jsonDecode(json)))
          .toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = _favoriteWords
          .map((word) => jsonEncode(word.toJson()))
          .toList();
      
      await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  void toggleFavorite(Word word) {
    final index = _words.indexWhere((w) => w.word == word.word);
    if (index != -1) {
      final updatedWord = _words[index].copyWith(isFavorite: !_words[index].isFavorite);
      _words[index] = updatedWord;

      if (updatedWord.isFavorite) {
        _favoriteWords.add(updatedWord);
      } else {
        _favoriteWords.removeWhere((w) => w.word == updatedWord.word);
      }

      saveFavorites();
      notifyListeners();
    }
  }

  void removeFavorite(Word word) {
    _favoriteWords.removeWhere((w) => w.word == word.word);
    
    final index = _words.indexWhere((w) => w.word == word.word);
    if (index != -1) {
      _words[index] = _words[index].copyWith(isFavorite: false);
    }

    saveFavorites();
    notifyListeners();
  }

  Word? getWordByName(String wordName) {
    try {
      return _words.firstWhere((word) => word.word == wordName);
    } catch (e) {
      try {
        return _favoriteWords.firstWhere((word) => word.word == wordName);
      } catch (e) {
        return null;
      }
    }
  }
}