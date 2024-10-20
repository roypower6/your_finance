class KeyStatisticListModel {
  final String className;
  final String keystatName;
  final String dataValue;
  final String cycle;
  final String unitName;

  KeyStatisticListModel.fromJson(Map<String, dynamic> json)
      : className = json['CLASS_NAME'],
        keystatName = json['KEYSTAT_NAME'],
        dataValue = json['DATA_VALUE'],
        cycle = json['CYCLE'],
        unitName = json['UNIT_NAME'];
}
