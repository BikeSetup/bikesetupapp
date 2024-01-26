enum BikeType {
  road(biketype: 'Road', hasShock: false, hasFork: false),
  fullsuspension(biketype: 'Fullsuspension', hasShock: true, hasFork: true),
  hardtail(biketype: 'Hardtail', hasShock: false, hasFork: true),
  error(biketype: 'Error', hasShock: false, hasFork: false);

  final String biketype;
  final bool hasShock;
  final bool hasFork;
  const BikeType({required this.biketype, required this.hasShock, required this.hasFork});

  static BikeType fromString(String biketype) {
    try {
      return BikeType.values.firstWhere((e) => e.biketype == biketype);
    } catch (e) {
      return BikeType.error;
    }
  }
}