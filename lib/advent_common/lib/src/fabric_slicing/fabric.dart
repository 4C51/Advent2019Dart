import 'fabric_claim.dart';
import 'fabric_section.dart';

class Fabric {
  Set<FabricSection> sections = new Set();
  Set<FabricClaim> claims = new Set();

  void addClaim(String claimCode) {
    FabricClaim.fromClaimCode(this, claimCode);
  }

  void addClaims(List<String> claimCodes) {
    for (var claimCode in claimCodes) {
      addClaim(claimCode);
    }
  }

  bool hasSection(FabricSection section) {
    return sections.contains(section);
  }

  List<FabricSection> get contestedSections {
    return sections.where((section) => section.claimCount > 1).toList();
  }

  List<FabricClaim> get uncontestedClaims {
    return claims.where((claim) => claim.contestedSections.length == 0).toList();
  }

  FabricSection addSectionForClaim(FabricSection section, FabricClaim claim) {
    var existing = sections.lookup(section);

    if (existing != null) {
      existing.addClaim(claim);
    } else {
      sections.add(section);
      section.addClaim(claim);
    }

    return existing ?? section;
  }
}