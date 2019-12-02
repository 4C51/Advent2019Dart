import 'box-id.dart';

class Box implements Comparable {
  BoxId id;

  Box(String id) {
    this.id = new BoxId(id);
  }

  @override
  int compareTo(other) {
    var otherBox = other as Box;

    return id.compareTo(otherBox.id);
  }

  @override
  bool operator ==(other) {
    var otherBox = other as Box;
    return id == otherBox.id;
  }
}