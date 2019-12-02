import 'package:AdventCommon/src/inventory_management/box-pair.dart';

import 'box.dart';

class BoxCollection {
  List<Box> boxes = new List();
  int checksum;

  BoxCollection(List<String> ids) {
    ids.forEach((id) => boxes.add(new Box(id)));
    checksum = _calcChecksum();
  }

  int _calcChecksum() {
    var dupCount = boxes.where((box) => box.id.duplicates > 0).length;
    var tripCount = boxes.where((box) => box.id.triplicates > 0).length;
    return dupCount * tripCount;
  }

  Iterable<BoxPair> getCloseBoxes([int difference = 1]) {
    var pairs = new List<BoxPair>();

    boxes.forEach((box) {
      boxes.forEach((box2) {
        if (box.id.diff(box2.id).diffCount == difference) {
          var pair = new BoxPair(box, box2);
          if (!pairs.contains(pair)) {
            pairs.add(pair);
          }
        }
      });
    });

    return pairs;
  }
}