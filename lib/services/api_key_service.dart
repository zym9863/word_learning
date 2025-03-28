import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyService {
  static const String _apiKeyPrefKey = 'gemini_api_key';

  // 保存API密钥到SharedPreferences
  Future<bool> saveApiKey(String apiKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_apiKeyPrefKey, apiKey);
    } catch (e) {
      print('保存API密钥失败: $e');
      return false;
    }
  }

  // 从SharedPreferences获取API密钥
  Future<String?> getApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_apiKeyPrefKey);
    } catch (e) {
      print('获取API密钥失败: $e');
      return null;
    }
  }

  // 检查是否已设置API密钥
  Future<bool> hasApiKey() async {
    final apiKey = await getApiKey();
    return apiKey != null && apiKey.isNotEmpty;
  }

  // 清除保存的API密钥
  Future<bool> clearApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_apiKeyPrefKey);
    } catch (e) {
      print('清除API密钥失败: $e');
      return false;
    }
  }
}