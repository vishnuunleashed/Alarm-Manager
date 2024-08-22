class AlarmModel{
  int? id;
  String label;
  String alarmtime;

  AlarmModel({this.id,this.label = "Casual Alarm",required this.alarmtime});

  AlarmModel copyWith({
    int? id,
    String? label,
    String? dateAndTime,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      label: label ?? this.label,
      alarmtime: dateAndTime ?? this.alarmtime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'label': this.label,
      'alarmtime': this.alarmtime,
    };
  }


  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json["id"],
      label: json["label"],
      alarmtime: json["alarmtime"],
    );
  }

}