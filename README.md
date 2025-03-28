# Word Learning

中文 | [English](README_EN.md)

一个用于学习英语单词的Flutter应用。

## 功能特点

- **随机单词学习**：每次刷新可获取10个随机英语单词
- **单词详情**：查看单词的音标、释义和例句
- **收藏功能**：将重要单词添加到收藏夹，方便复习
- **搜索功能**：在收藏的单词中快速搜索
- **API集成**：使用Gemini API获取单词数据，支持自定义API密钥

## 技术架构

- **开发框架**：Flutter
- **状态管理**：Provider
- **数据存储**：SharedPreferences（用于保存收藏单词和API密钥）
- **网络请求**：http包
- **UI设计**：Material Design 3

## 项目结构

```
lib/
  ├── constants/       # 常量定义（颜色等）
  ├── models/          # 数据模型
  ├── providers/       # 状态管理
  ├── screens/         # 界面
  ├── services/        # 服务（API调用等）
  └── main.dart        # 应用入口
```

## 主要界面

- **单词列表**：显示随机获取的单词列表，支持刷新获取新单词
- **收藏列表**：显示已收藏的单词，支持搜索功能
- **单词详情**：展示单词的详细信息，包括音标、释义和例句
- **设置界面**：配置Gemini API密钥

## 使用方法

1. 首次启动应用，会自动加载示例单词
2. 点击右上角设置图标，进入设置页面配置Gemini API密钥
3. 点击右下角刷新按钮获取新的随机单词
4. 点击单词卡片查看详情，可以收藏或取消收藏单词
5. 切换到收藏标签页查看已收藏的单词

## 开发环境

- Flutter SDK
- Dart SDK
- Android Studio / VS Code

## 依赖项

- provider: 状态管理
- http: 网络请求
- shared_preferences: 本地数据存储

## 开始使用

1. 克隆项目
2. 运行 `flutter pub get` 安装依赖
3. 运行 `flutter run` 启动应用
