class DictModel {
  final String word;
  final String content;

  DictModel.fromJson(Map<String, dynamic> json)
      : word = json['WORD'],
        content = json['CONTENT'];
}
