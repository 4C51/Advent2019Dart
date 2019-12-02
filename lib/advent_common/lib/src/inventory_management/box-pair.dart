import 'package:AdventCore/data_structures.dart';

import 'box.dart';

class BoxPair implements Comparable {
  Box box1;
  Box box2;
  Diff diff;

  BoxPair(Box this.box1, Box this.box2) {
    diff = box1.id.diff(box2.id);
  }

  @override
  int compareTo(other) {
    var otherPair = (other as BoxPair);

    return diff.matchedString.compareTo(otherPair.diff.matchedString);
  }

  @override
  bool operator ==(other) {
    var otherPair = other as BoxPair;
    return diff.matchedString == otherPair.diff.matchedString;
  }
}