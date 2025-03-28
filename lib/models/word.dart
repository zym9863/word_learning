class Word {
  final String word;
  final String meaning;
  final String phonetic;
  final List<String> examples;
  final bool isFavorite;

  Word({
    required this.word,
    required this.meaning,
    required this.phonetic,
    required this.examples,
    this.isFavorite = false,
  });

  Word copyWith({
    String? word,
    String? meaning,
    String? phonetic,
    List<String>? examples,
    bool? isFavorite,
  }) {
    return Word(
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      phonetic: phonetic ?? this.phonetic,
      examples: examples ?? this.examples,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'meaning': meaning,
      'phonetic': phonetic,
      'examples': examples,
      'isFavorite': isFavorite,
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      meaning: json['meaning'],
      phonetic: json['phonetic'],
      examples: (json['examples'] as List).map((e) => e.toString()).toList(),
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}