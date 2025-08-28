import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/word_provider.dart';
import 'screens/word_list_screen.dart';
import 'constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => WordProvider(),
      child: MaterialApp(
        title: 'Word Learning',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.activeBlue),
          scaffoldBackgroundColor: AppColors.lightGrey,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.activeBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            titleTextStyle: const TextStyle(
              fontFamily: 'SF Pro Rounded',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          tabBarTheme: TabBarThemeData(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: AppColors.memoryYellow,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: AppColors.memoryYellow.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            labelStyle: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Rounded',
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro Rounded',
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.transparent,
            margin: EdgeInsets.zero,
          ),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(fontFamily: 'SF Pro Rounded', fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontFamily: 'SF Pro Rounded', fontWeight: FontWeight.w600),
            titleMedium: TextStyle(fontFamily: 'SF Pro Rounded', fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(fontFamily: 'SF Pro Rounded'),
            bodyMedium: TextStyle(fontFamily: 'SF Pro Rounded', color: AppColors.darkGrey),
          ),
        ),
        home: Builder(
          builder: (context) {
            // 确保应用启动时重新调用API获取新的单词列表
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final wordProvider = Provider.of<WordProvider>(context, listen: false);
              // 每次应用启动时都清空现有单词列表并获取新的单词
              wordProvider.refresh();
            });
            return const WordListScreen();
          },
        ),
      ),
    );
  }
}

