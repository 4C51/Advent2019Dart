import 'fabric.dart';
import 'fabric_section.dart';
import 'dart:math';

final claimStringRegex = new RegExp(r'#(\d+) @ (\d+),(\d+): (\d+)x(\d+)');

class FabricClaim {
  int id;
  int xOffset;
  int yOffset;
  int width;
  int height;
  Fabric parentFabric;
  Set<FabricSection> claimedSections;
  int area;

  FabricClaim(Fabric this.parentFabric, int this.id, int this.xOffset, int this.yOffset, int this.width, int this.height) {
    area = width * height;

    parentFabric.claims.add(this);
    _claimSections();
  }

  _claimSections() {
    claimedSections = FabricSection.fromClaim(parentFabric, this);
  }

  List<FabricSection> get contestedSections {
    return claimedSections.where((section) => section.claimCount > 1).toList();
  }

  List<List<Point>> getColumns() {
    List<List<Point>> columns = new List();
    for (var i = xOffset; i < xOffset + width; i++) {
      List<Point> column = new List();
      for (var j = yOffset; j < yOffset + height; j++) {
        column.add(new Point(i, j));
      }

      columns.add(column);
    }

    return columns;
  }

  List<List<Point>> getRows() {
    List<List<Point>> rows = new List();
    for (var i = yOffset; i < yOffset + height; i++) {
      List<Point> row = new List();
      for (var j = xOffset; j < xOffset + width; j++) {
        row.add(new Point(i, j));
      }

      rows.add(row);
    }

    return rows;
  }

  static FabricClaim fromClaimCode(Fabric fabric, String claimCode) {
    var claimVars = claimStringRegex.firstMatch(claimCode).groups([1, 2, 3, 4, 5]).map((s) => int.parse(s)).toList();
    return new FabricClaim(fabric, claimVars[0], claimVars[1], claimVars[2], claimVars[3], claimVars[4]);
  }

  @override
  int get hashCode {
    return id;
  }

  @override
  bool operator ==(other) {
    var otherClaim = other as FabricClaim;
    return id == otherClaim.id;
  }
}