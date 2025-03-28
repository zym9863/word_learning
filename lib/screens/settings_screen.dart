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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API密钥设置',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '请输入您的Gemini API密钥，用于获取单词数据。',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: 'Gemini API密钥',
                      border: const OutlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isApiKeyVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isApiKeyVisible = !_isApiKeyVisible;
                              });
                            },
                            tooltip: _isApiKeyVisible ? '隐藏API密钥' : '显示API密钥',
                          ),
                          IconButton(
                            icon: const Icon(Icons.content_paste),
                            onPressed: _pasteFromClipboard,
                            tooltip: '从剪贴板粘贴',
                          ),
                        ],
                      ),
                    ),
                    obscureText: !_isApiKeyVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  if (_errorMessage != null) ...[  
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _saveApiKey,
                        icon: const Icon(Icons.save),
                        label: const Text('保存API密钥'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isApiKeySaved ? _clearApiKey : null,
                        icon: const Icon(Icons.delete),
                        label: const Text('清除API密钥'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red,
                          disabledBackgroundColor: Colors.grey.shade200,
                          disabledForegroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    '关于API密钥',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• API密钥用于访问Gemini API获取单词数据\n'
                    '• 您可以在Google AI Studio获取免费的API密钥\n'
                    '• API密钥将安全地存储在您的设备上\n'
                    '• 我们不会将您的API密钥发送到我们的服务器',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}