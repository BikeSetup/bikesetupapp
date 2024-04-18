enum BikeType {
  dh(biketype: 'Downhill Bike', path: "assets/DH.png", hasShock: true, hasFork: true),
  enduro(
      biketype: 'Enduro Bike', path: "assets/Enduro.png", hasShock: true, hasFork: true),
  dirtjump(
      biketype: 'Dirt Bike', path: "assets/Dirt.png", hasShock: false, hasFork: true),
  xc(biketype: 'Cross Country Bike', path: "assets/XC.png", hasShock: false, hasFork: true),
  singlespeed(
      biketype: 'Singlespeed Bike',
      path: "assets/Singlespeed.png",
      hasShock: false,
      hasFork: false),
  road(
      biketype: 'Road Bike', path: "assets/Road.png", hasShock: false, hasFork: false),
  error(
      biketype: 'Error',
      path: "No Bike Found",
      hasShock: false,
      hasFork: false);

  final String biketype;
  final String path;
  final bool hasShock;
  final bool hasFork;
  const BikeType(
      {required this.biketype,
      required this.path,
      required this.hasShock,
      required this.hasFork});

  static BikeType fromString(String biketype) {
    try {
      return BikeType.values.firstWhere((e) => e.biketype == biketype);
    } catch (e) {
      return BikeType.error;
    }
  }
}
