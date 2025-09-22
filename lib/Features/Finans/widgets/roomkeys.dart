class RoomKeys {
  static const String k2 = '2li';
  static const String k3 = '3lu';
  static const String k4 = '4lu';

  static const all = [k2, k3, k4];

  static String label(String k) {
    switch (k) {
      case k2:
        return "2’li Oda";
      case k3:
        return "3’lü Oda";
      case k4:
        return "4’lü Oda";
      default:
        return k;
    }
  }
}
