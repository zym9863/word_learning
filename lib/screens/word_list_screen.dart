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
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.activeBlue.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
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
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.activeBlue.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              Provider.of<WordProvider>(context, listen: false).refresh();
            },
            tooltip: 'Refresh Words',
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.refresh, size: 26),
          ),
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
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.cardGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索收藏的单词...',
          hintStyle: const TextStyle(
            color: AppColors.darkGrey, 
            fontSize: 16,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 20),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.mediumGrey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.clear, color: AppColors.darkGrey, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.mediumGrey.withValues(alpha: 0.3), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.activeBlue, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        ),
        style: const TextStyle(
          fontSize: 16, 
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w500,
        ),
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
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.activeBlue)));
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
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: showFavorites 
                          ? LinearGradient(
                              colors: [AppColors.errorRed.withValues(alpha: 0.1), AppColors.lightRed.withValues(alpha: 0.1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : AppColors.primaryGradient.scale(0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (showFavorites ? AppColors.errorRed : AppColors.activeBlue).withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      showFavorites ? Icons.favorite_border : Icons.menu_book_outlined,
                      size: 48,
                      color: showFavorites ? AppColors.errorRed : AppColors.activeBlue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    showFavorites
                        ? 'No favorite words yet!'
                        : 'No words available',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro Rounded',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    showFavorites
                        ? 'Start adding words to your favorites to see them here.'
                        : 'Tap the refresh button to load new words.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.darkGrey,
                      fontFamily: 'SF Pro Rounded',
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            _buildSearchBar(showFavorites),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: words.length,
                itemBuilder: (ctx, index) {
                  final word = words[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: AppColors.cardGradient,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.9),
                          blurRadius: 1,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        splashColor: AppColors.activeBlue.withValues(alpha: 0.1),
                        highlightColor: AppColors.activeBlue.withValues(alpha: 0.05),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => WordDetailScreen(word: word),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 增强的单词首字母圆形图标
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.activeBlue.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    word.word.isNotEmpty ? word.word[0].toUpperCase() : '',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'SF Pro Rounded',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              // 增强的单词内容
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      word.word,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontFamily: 'SF Pro Rounded',
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      word.phonetic,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.activeBlue.withValues(alpha: 0.8),
                                        fontFamily: 'SF Pro Rounded',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      word.meaning,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.darkGrey,
                                        fontFamily: 'SF Pro Rounded',
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 增强的收藏按钮
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: word.isFavorite 
                                      ? AppColors.errorRed.withValues(alpha: 0.1)
                                      : Colors.grey.withValues(alpha: 0.1),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    word.isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: word.isFavorite ? AppColors.errorRed : AppColors.darkGrey,
                                    size: 24,
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
                              ),
                            ],
                          ),
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