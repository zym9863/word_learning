import 'package:flutter/material.dart';

class AppColors {
  // 主色调
  static const Color activeBlue = Color(0xFF4A89DC); // 活力蓝：象征专注与信任
  static const Color lightBlue = Color(0xFF6BA6E3); // 浅蓝色：用于渐变
  static const Color deepBlue = Color(0xFF3B73C7); // 深蓝色：用于渐变
  static const Color memoryYellow = Color(0xFFF5B946); // 记忆黄：刺激记忆关联
  static const Color lightYellow = Color(0xFFF8C76A); // 浅黄色：用于渐变
  
  // 中性色
  static const Color lightGrey = Color(0xFFF5F7FA); // 浅灰：背景
  static const Color ultraLightGrey = Color(0xFFFAFBFC); // 超浅灰：卡片背景
  static const Color mediumGrey = Color(0xFFCCD1D9); // 中灰：分割线
  static const Color darkGrey = Color(0xFF656D78); // 深灰：正文
  
  // 反馈色
  static const Color correctGreen = Color(0xFF48CFAD); // 正确绿
  static const Color lightGreen = Color(0xFF6BC5D2); // 浅绿色：用于渐变
  static const Color errorRed = Color(0xFFED5565); // 错误红
  static const Color lightRed = Color(0xFFF06292); // 浅红色：用于渐变
  
  // 渐变色定义
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [activeBlue, lightBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [memoryYellow, lightYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Colors.white, ultraLightGrey],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [correctGreen, lightGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}