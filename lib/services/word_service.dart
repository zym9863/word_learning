import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word.dart';
import 'api_key_service.dart';

class WordService {
  static const String _apiUrl =
      'https://zym9863-gemini.deno.dev/v1/chat/completions';
  final ApiKeyService _apiKeyService = ApiKeyService();

  Future<List<Word>> getRandomWords(int count) async {
    // 每次调用都确保获取新的单词
    try {
      // 添加时间戳作为防缓存参数
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final apiUrlWithTimestamp = '$_apiUrl?t=$timestamp';

      // 获取API密钥
      final apiKey = await _apiKeyService.getApiKey();
      if (apiKey == null || apiKey.isEmpty) {
        print('API密钥未设置，使用示例数据');
        return _getSampleWords();
      }

      final response = await http.post(
        Uri.parse(apiUrlWithTimestamp),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
        body: jsonEncode({
          'messages': [
            {
              'role': 'user',
              'content':
                  'Generate $count random English words commonly found in the Chinese postgraduate entrance examination with their meanings, phonetics, and 2 example sentences for each. Format the response as a JSON array with each word having these properties: word, meaning, phonetic, examples (array of strings).',
            },
          ],
          'model': 'gemini-2.5-flash-preview-05-20',
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        // 处理API响应
        String responseBody = response.body;

        try {
          // 解析响应体
          final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

          // Gemini API 返回的内容在 choices[0].message.content 中
          if (jsonResponse.containsKey('choices') &&
              jsonResponse['choices'] is List &&
              jsonResponse['choices'].isNotEmpty) {
            final content = jsonResponse['choices'][0]['message']['content'];

            // 检查并去除可能存在的Markdown代码块标记
            String processedContent = content;
            if (processedContent.startsWith('```')) {
              // 找到第一行结束位置
              int firstLineEnd = processedContent.indexOf('\n');
              if (firstLineEnd != -1) {
                // 去除第一行（```json）
                processedContent = processedContent.substring(firstLineEnd + 1);

                // 去除最后的```
                int lastMarkdownEnd = processedContent.lastIndexOf('```');
                if (lastMarkdownEnd != -1) {
                  processedContent =
                      processedContent.substring(0, lastMarkdownEnd).trim();
                }
              }
            }

            // 解析处理后的内容为JSON数组
            final List<dynamic> wordsJson = jsonDecode(processedContent);
            return wordsJson.map((json) => Word.fromJson(json)).toList();
          }
        } catch (e) {
          print('解析API响应失败: $e');
          print('处理后的响应内容: $responseBody');
        }

        // Fallback to sample data if parsing fails
        return _getSampleWords();
      } else {
        // Return sample data if API call fails
        return _getSampleWords();
      }
    } catch (e) {
      // Return sample data if any error occurs
      return _getSampleWords();
    }
  }

  // Sample data to use when API fails or for testing
  List<Word> _getSampleWords() {
    return [
      Word(
        word: 'abandon',
        meaning: 'to leave a place, thing, or person, usually forever',
        phonetic: '/əˈbændən/',
        examples: [
          'They had to abandon their car in the snowstorm.',
          'The captain was the last to abandon the sinking ship.',
        ],
      ),
      Word(
        word: 'ability',
        meaning: 'the physical or mental power or skill needed to do something',
        phonetic: '/əˈbɪləti/',
        examples: [
          'He has the ability to explain complex ideas clearly.',
          'Her musical ability was evident from an early age.',
        ],
      ),
      Word(
        word: 'abroad',
        meaning: 'in or to a foreign country',
        phonetic: '/əˈbrɔːd/',
        examples: [
          'She is currently staying abroad in France,',
          'Many people dream of traveling abroad after graduation.',
        ],
      ),
      Word(
        word: 'absence',
        meaning: 'the state of being away from a place or person',
        phonetic: '/ˈæbsəns/',
        examples: [
          'His absence was noted at the meeting.',
          'In the absence of evidence, the case was dismissed.',
        ],
      ),
      Word(
        word: 'absorb',
        meaning:
            'to take in or soak up (energy or a liquid or other substance) by chemical or physical action',
        phonetic: '/əbˈzɔːrb/',
        examples: [
          'Plants absorb carbon dioxide from the air.',
          'The sponge quickly absorbed all the water.',
        ],
      ),
      Word(
        word: 'abstract',
        meaning:
            'existing in thought or as an idea but not having a physical existence',
        phonetic: '/ˈæbstrækt/',
        examples: [
          'Love and justice are abstract concepts.',
          'His paintings became more abstract over time.',
        ],
      ),
      Word(
        word: 'academic',
        meaning: 'relating to education, schools, universities, etc.',
        phonetic: '/ˌækəˈdemɪk/',
        examples: [
          'She has excellent academic qualifications.',
          'The university\'s academic year begins in September,',
        ],
      ),
      Word(
        word: 'accelerate',
        meaning: 'to make something happen more quickly or earlier',
        phonetic: '/əkˈseləreɪt/',
        examples: [
          'The car accelerated rapidly from 0 to 60 mph.',
          'The program is designed to accelerate learning.',
        ],
      ),
      Word(
        word: 'accent',
        meaning:
            'a distinctive way of pronouncing a language associated with a particular country, area, or social class',
        phonetic: '/ˈæksent/',
        examples: [
          'She speaks English with a French accent.',
          'Regional accents can sometimes be difficult to understand.',
        ],
      ),
      Word(
        word: 'accommodate',
        meaning: 'to provide someone with a place to live or to be stored in',
        phonetic: '/əˈkɒmədeɪt/',
        examples: [
          'The hotel can accommodate up to 500 guests.',
          'We need to accommodate these changes in our schedule.',
        ],
      ),
    ];
  }
}
