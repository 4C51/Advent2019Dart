import 'package:AdventCore/data_structures.dart';

class BoxId implements Comparable {
  String id;
  BucketCounter<String> idStats;
  int duplicates;
  int triplicates;

  BoxId(String this.id) {
    idStats = new BucketCounter(id.split(''));

    duplicates = idStats.countBucketsWithCount(2);
    triplicates = idStats.countBucketsWithCount(3);
  }

  Diff diff(BoxId otherId) {
    return new Diff(id, otherId.id);
  }

  @override
  int compareTo(other) {
    var otherId = other as BoxId;
    return id.compareTo(otherId.id);
  }

  @override
  bool operator ==(other) {
    var otherId = other as BoxId;
    return id == otherId.id;
  }
}