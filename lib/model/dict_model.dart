class DictModel {
  final String word;
  final String content;

  DictModel({
    required this.word,
    required this.content,
  });

  DictModel.fromJson(Map<String, dynamic> json)
      : word = json['WORD'] ?? json['word'],
        content = json['CONTENT'] ?? json['content'];

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'content': content,
    };
  }
}
