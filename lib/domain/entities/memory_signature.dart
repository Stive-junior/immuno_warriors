class MemorySignature {
  final String pathogenType;
  final double attackBonus;
  final double defenseBonus;
  final DateTime expiryDate;

  MemorySignature({
    required this.pathogenType,
    required this.attackBonus,
    required this.defenseBonus,
    required this.expiryDate,
  });

  bool isValid() {
    return expiryDate.isAfter(DateTime.now());
  }
}