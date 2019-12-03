import 'package:AdventCommon/common.dart';

class ManhattenGrid {
  final _points = Set<ManhattenPoint>();

  addPoint(ManhattenPoint point) => _points.add(point);
  removePoint(ManhattenPoint point) => _points.remove(point);
}
