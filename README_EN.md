# Word Learning

[中文](README.md) | English

A Flutter application for learning English words.

## Features

- **Random Word Learning**: Get 10 random English words each time you refresh
- **Word Details**: View word phonetics, definitions, and example sentences
- **Favorites**: Add important words to favorites for easy review
- **Search Function**: Quickly search among your favorite words
- **API Integration**: Use Gemini API to get word data, supports custom API key

## Technical Architecture

- **Development Framework**: Flutter
- **State Management**: Provider
- **Data Storage**: SharedPreferences (for saving favorite words and API key)
- **Network Requests**: http package
- **UI Design**: Material Design 3

## Project Structure

```
lib/
  ├── constants/       # Constants definition (colors, etc.)
  ├── models/          # Data models
  ├── providers/       # State management
  ├── screens/         # Screens
  ├── services/        # Services (API calls, etc.)
  └── main.dart        # Application entry
```

## Main Screens

- **Word List**: Displays randomly fetched word list, supports refreshing to get new words
- **Favorites List**: Displays favorited words, supports search function
- **Word Details**: Shows detailed information about a word, including phonetics, definitions, and example sentences
- **Settings Screen**: Configure Gemini API key

## How to Use

1. When first launching the app, example words will be automatically loaded
2. Click the settings icon in the top right corner to enter the settings page and configure the Gemini API key
3. Click the refresh button in the bottom right corner to get new random words
4. Click on a word card to view details, you can add or remove words from favorites
5. Switch to the favorites tab to view your favorited words

## Development Environment

- Flutter SDK
- Dart SDK
- Android Studio / VS Code

## Dependencies

- provider: State management
- http: Network requests
- shared_preferences: Local data storage

## Getting Started

1. Clone the project
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application