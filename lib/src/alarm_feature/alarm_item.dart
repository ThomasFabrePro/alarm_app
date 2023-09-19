/// A placeholder class that represents an entity or model.
class AlarmItem {
  const AlarmItem(this.id, this.title, this.description, this.time);
  final int id;
  final String title;
  final String description;
  final String time;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'time': time,
    };
  }

  factory AlarmItem.fromMap(Map<String, dynamic> map) {
    return AlarmItem(
      map['id'],
      map['title'],
      map['description'],
      map['time'],
    );
  }
}
