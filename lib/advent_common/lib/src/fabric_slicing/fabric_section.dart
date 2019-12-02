import 'fabric.dart';
import 'fabric_claim.dart';

class FabricSection {
  int x;
  int y;
  Set<FabricClaim> claims = new Set();

  get claimCount {
    return claims.length;
  }

  FabricSection(int this.x, int this.y);

  addClaim(FabricClaim claim) {
    claims.add(claim);
  }

  static Set<FabricSection> fromClaim(Fabric fabric, FabricClaim claim) {
    var sections = new Set<FabricSection>();
    
    claim.getRows().forEach((row) => row.forEach((point) => sections.add(fabric.addSectionForClaim(new FabricSection(point.x, point.y), claim))));

    return sections;
  }

  @override
  int get hashCode {
    return x * 100000000 + y;
  }

  @override
  bool operator ==(other) {
    var otherSection = other as FabricSection;
    return x == otherSection.x && y == otherSection.y;
  }
}