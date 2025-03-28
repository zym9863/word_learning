import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/word.dart';
import '../providers/word_provider.dart';
import '../constants/colors.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word.word),
        elevation: 1,
        actions: [
          Consumer<WordProvider>(
            builder: (ctx, wordProvider, _) {
              final currentWord = wordProvider.getWordByName(word.word) ?? word;
              return IconButton(
                icon: Icon(
                  currentWord.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: currentWord.isFavorite ? AppColors.errorRed : Colors.white,
                  size: 26,
                ),
                onPressed: () {
                  wordProvider.toggleFavorite(currentWord);
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shadowColor: Colors.black.withOpacity(0.15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 单词首字母圆形图标
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.activeBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              word.word.isNotEmpty ? word.word[0].toUpperCase() : '',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.activeBlue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                word.word,
                                style: const TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                word.phonetic,
                                style: const TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.mediumGrey, thickness: 1),
                    const SizedBox(height: 16),
                    Text(
                      'Meaning:',
                      style: const TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.activeBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      word.meaning,
                      style: const TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        fontSize: 16,
                        color: AppColors.darkGrey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.format_quote, color: AppColors.memoryYellow, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Examples:',
                  style: const TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: word.examples.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.08),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.mediumGrey.withOpacity(0.5), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppColors.memoryYellow,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                word.examples[index],
                                style: const TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  fontSize: 16,
                                  color: AppColors.darkGrey,
                                  height: 1.5,
                                ),
                              ),
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
        ),
      ),
    );
  }
}