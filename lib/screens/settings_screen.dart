import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_key_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  final _apiKeyService = ApiKeyService();
  bool _isLoading = true;
  bool _isApiKeySaved = false;
  bool _isApiKeyVisible = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadApiKey() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiKey = await _apiKeyService.getApiKey();
      setState(() {
        if (apiKey != null && apiKey.isNotEmpty) {
          _apiKeyController.text = apiKey;
          _isApiKeySaved = true;
        } else {
          _isApiKeySaved = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '加载API密钥失败: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveApiKey() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      setState(() {
        _errorMessage = 'API密钥不能为空';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _apiKeyService.saveApiKey(apiKey);
      setState(() {
        _isLoading = false;
        if (success) {
          _isApiKeySaved = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('API密钥保存成功')),
          );
        } else {
          _errorMessage = 'API密钥保存失败';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '保存API密钥时出错: $e';
      });
    }
  }

  Future<void> _clearApiKey() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _apiKeyService.clearApiKey();
      setState(() {
        _isLoading = false;
        if (success) {
          _apiKeyController.clear();
          _isApiKeySaved = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('API密钥已清除')),
          );
        } else {
          _errorMessage = 'API密钥清除失败';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '清除API密钥时出错: $e';
      });
    }
  }

  Future<void> _pasteFromClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data != null && data.text != null && data.text!.isNotEmpty) {
        setState(() {
          _apiKeyController.text = data.text!;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = '剪贴板为空';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '从剪贴板粘贴时出错: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: _isLoading
          ? Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: AppColors.cardGradient,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.vpn_key,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'API密钥设置',
                              style: TextStyle(
                                fontSize: 22, 
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF Pro Rounded',
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '请输入您的Gemini API密钥，用于获取单词数据。',
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 16,
                            fontFamily: 'SF Pro Rounded',
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.mediumGrey.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _apiKeyController,
                            decoration: InputDecoration(
                              labelText: 'Gemini API密钥',
                              labelStyle: const TextStyle(
                                color: AppColors.darkGrey,
                                fontFamily: 'SF Pro Rounded',
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: AppColors.activeBlue, width: 2),
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.activeBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        _isApiKeyVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.activeBlue,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isApiKeyVisible = !_isApiKeyVisible;
                                      },
                                      tooltip: _isApiKeyVisible ? '隐藏API密钥' : '显示API密钥',
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.memoryYellow.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.content_paste,
                                        color: AppColors.memoryYellow,
                                        size: 20,
                                      ),
                                      onPressed: _pasteFromClipboard,
                                      tooltip: '从剪贴板粘贴',
                                    ),
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, 
                                vertical: 16,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'SF Pro Rounded',
                              fontWeight: FontWeight.w500,
                            ),
                            obscureText: !_isApiKeyVisible,
                            enableSuggestions: false,
                            autocorrect: false,
                          ),
                        ),
                        if (_errorMessage != null) ...[  
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.errorRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.errorRed.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.errorRed,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: AppColors.errorRed,
                                      fontFamily: 'SF Pro Rounded',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.activeBlue.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: _saveApiKey,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: const Icon(Icons.save, size: 20),
                                  label: const Text(
                                    '保存API密钥',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Rounded',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: _isApiKeySaved 
                                      ? LinearGradient(
                                          colors: [AppColors.errorRed.withOpacity(0.8), AppColors.lightRed.withOpacity(0.8)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : LinearGradient(
                                          colors: [AppColors.mediumGrey.withOpacity(0.3), AppColors.mediumGrey.withOpacity(0.2)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: _isApiKeySaved ? _clearApiKey : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: _isApiKeySaved ? Colors.white : AppColors.darkGrey,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: const Icon(Icons.delete, size: 20),
                                  label: const Text(
                                    '清除API密钥',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro Rounded',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: AppColors.cardGradient,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: AppColors.secondaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              '关于API密钥',
                              style: TextStyle(
                                fontSize: 22, 
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF Pro Rounded',
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '• API密钥用于访问Gemini API获取单词数据\n'
                          '• 您可以在Google AI Studio获取免费的API密钥\n'
                          '• API密钥将安全地存储在您的设备上\n'
                          '• 我们不会将您的API密钥发送到我们的服务器',
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 16,
                            fontFamily: 'SF Pro Rounded',
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}