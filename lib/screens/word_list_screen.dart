import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_provider.dart';
import '../constants/colors.dart';
import 'word_detail_screen.dart';
import 'settings_screen.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Word Learning'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, size: 26),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const SettingsScreen(),
                  ),
                );
              },
              tooltip: '设置',
            ),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Words'),
              Tab(text: 'Favorites'),
            ],
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: TabBarView(
          children: [
            _buildWordList(context, false),
            _buildWordList(context, true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<WordProvider>(context, listen: false).refresh();
          },
          tooltip: 'Refresh Words',
          backgroundColor: AppColors.activeBlue,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar(bool showFavorites) {
    // 只在收藏界面显示搜索框
    if (!showFavorites) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索收藏的单词...',
          hintStyle: const TextStyle(color: AppColors.darkGrey, fontSize: 15),
          prefixIcon: const Icon(Icons.search, color: AppColors.activeBlue),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.darkGrey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: AppColors.mediumGrey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: AppColors.activeBlue, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
        style: const TextStyle(fontSize: 16),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildWordList(BuildContext context, bool showFavorites) {
    return Consumer<WordProvider>(
      builder: (ctx, wordProvider, child) {
        if (wordProvider.isLoading) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.activeBlue)));
        }

        var words = showFavorites ? wordProvider.favoriteWords : wordProvider.words;
        
        // 如果在收藏界面且有搜索查询，过滤单词列表
        if (showFavorites && _searchQuery.isNotEmpty) {
          words = words.where((word) => 
            word.word.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            word.meaning.toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();
        }

        if (words.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  showFavorites ? Icons.favorite_border : Icons.menu_book_outlined,
                  size: 64,
                  color: AppColors.mediumGrey,
                ),
                const SizedBox(height: 16),
                Text(
                  showFavorites
                      ? 'No favorite words yet!'
                      : 'No words available. Tap refresh to load words.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildSearchBar(showFavorites),
            Expanded(
              child: ListView.builder(
          itemCount: words.length,
          itemBuilder: (ctx, index) {
            final word = words[index];
            return Card(
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                splashColor: AppColors.activeBlue.withOpacity(0.1),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => WordDetailScreen(word: word),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 单词首字母圆形图标
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.activeBlue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            word.word.isNotEmpty ? word.word[0].toUpperCase() : '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.activeBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 单词内容
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              word.word,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              word.phonetic,
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              word.meaning,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 收藏按钮
                      IconButton(
                        icon: Icon(
                          word.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: word.isFavorite ? AppColors.errorRed : AppColors.darkGrey,
                          size: 26,
                        ),
                        onPressed: () {
                          // 在收藏界面中，直接调用removeFavorite方法取消收藏
                          // 在单词列表界面中，使用toggleFavorite方法切换收藏状态
                          if (showFavorites) {
                            wordProvider.removeFavorite(word);
                          } else {
                            wordProvider.toggleFavorite(word);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
            ),
          ],
        );
      },
    );
  }
}